load("pedestrianSensorDataIMUGPS.mat","sensorData","imuFs","imuNoise", ...
     "numGPSSamplesPerOptim","posLLA","initOrient","initPos","numIMUSamplesPerGPS");

numGPSSamplesPerOptim = 2;
% global meaCollect
% global ImCollect
% meaCollect  = [];
% ImCollect = {};

nodesPerTimeStep = [exampleHelperFactorGraphNodes.Pose; ...
                    exampleHelperFactorGraphNodes.Velocity; ...
                    exampleHelperFactorGraphNodes.IMUBias];
numNodesPerTimeStep = numel(nodesPerTimeStep);
currNodeIDs = nodesPerTimeStep + [0 numNodesPerTimeStep];
currNodeIDs = currNodeIDs(:).';

t0IndexPose = exampleHelperFactorGraphNodes.Pose;
t1IndexPose = t0IndexPose + numNodesPerTimeStep;
t0IndexVel = exampleHelperFactorGraphNodes.Velocity;
t1IndexVel = t0IndexVel + numNodesPerTimeStep;
t0IndexBias = exampleHelperFactorGraphNodes.IMUBias;
t1IndexBias = t0IndexBias + numNodesPerTimeStep;

G = factorGraph;
prevPose =  [initPos compact(initOrient)]; % x y z | qw qx qy qz
prevVel = [0 0 0]; % m/s
prevBias = [0 0 0 0 0 0]; % Gyroscope and accelerometer biases.n        ??4: noise cov

fPosePrior = factorPoseSE3Prior(currNodeIDs(t0IndexPose),Measurement=prevPose, ...
    Information=diag([4e4 4e4 4e4 1e4 1e4 1e4]));
fVelPrior = factorVelocity3Prior(currNodeIDs(t0IndexVel),Measurement=prevVel, ...
    Information=100*eye(3));
fBiasPrior = factorIMUBiasPrior(currNodeIDs(t0IndexBias),Measurement=prevBias, ...
    Information=1e6*eye(6));

addFactor(G,fPosePrior);
addFactor(G,fVelPrior);
addFactor(G,fBiasPrior);

nodeState(G,currNodeIDs(t0IndexPose),prevPose);
nodeState(G,currNodeIDs(t0IndexVel),prevVel);
nodeState(G,currNodeIDs(t0IndexBias),prevBias);

lla0 = sensorData{1}.GPSReading;

opts = factorGraphSolverOptions(MaxIterations=100);

numGPSSamples = numel(sensorData);
poseIDs = zeros(1,numGPSSamples);

visHelper = Copy_of_exampleHelperVisualizeFactorGraphAndFilteredPosition;

for ii = 1:numGPSSamples
    % 1. Store the current pose ID. 
    poseIDs(ii) = currNodeIDs(t0IndexPose);
    
    % 2. Create an IMU factor. 
        % imuFs: frequency of IMU (i.e.,400Hz)
    fIMU = factorIMU(currNodeIDs,imuFs, ...   
        imuNoise.GyroscopeBiasNoise, ...
        imuNoise.AccelerometerBiasNoise, ...
        imuNoise.GyroscopeNoise, ...
        imuNoise.AccelerometerNoise, ...
        sensorData{ii}.GyroReadings,sensorData{ii}.AccelReadings);

    % 3. Create a GPS factor. 
        % HDOP; VDOP
    fGPS = factorGPS(currNodeIDs(t0IndexPose),HDOP=sensorData{ii}.HDoP, ...
        VDOP=sensorData{ii}.VDoP, ...
        ReferenceLocation=lla0, ...
        Location=sensorData{ii}.GPSReading);

    % 4. Add the factors to the graph. 
    addFactor(G,fIMU);
    addFactor(G,fGPS);

    % 5. Set initial node states using previous state estimates and a state prediction from the IMU measurements.
    [predictedPose,predictedVel] = predict(fIMU,prevPose,prevVel,prevBias);
    nodeState(G,currNodeIDs(t1IndexPose),predictedPose);
    nodeState(G,currNodeIDs(t1IndexVel),predictedVel);
    nodeState(G,currNodeIDs(t1IndexBias),prevBias);
    
    % 6. Optimize the factor graph.
    if (mod(ii,numGPSSamplesPerOptim) == 0) || (ii == numGPSSamples)
        solnInfo = optimize(G,opts);

        % Visualize the current position estimate.
        updatePlot(visHelper,ii,G,poseIDs,posLLA,lla0,numIMUSamplesPerGPS);
        drawnow
    end

    % 7. Advance one time step by updating the previous state estimates to the current ones and incrementing the current node IDs.
    prevPose = nodeState(G,currNodeIDs(t1IndexPose));
    prevVel = nodeState(G,currNodeIDs(t1IndexVel));
    prevBias = nodeState(G,currNodeIDs(t1IndexBias));

    currNodeIDs = currNodeIDs + numNodesPerTimeStep;
end

onBoardPos = lla2enu(posLLA,lla0,"ellipsoid");
onBoardPos = onBoardPos(cumsum(numIMUSamplesPerGPS-1),:); % Convert to sampling rate of factor graph.
estPos = zeros(numel(poseIDs),3);
for ii = 1:numel(poseIDs)
    currPose = nodeState(G, poseIDs(ii));
    estPos(ii,:) = currPose(1:3);
end
posDiff = estPos - onBoardPos;    
posDiff(isnan(posDiff(:,1)),:) = []; % Remove any missing position readings from the onboard filter.
posRMS = sqrt(mean(posDiff.^2));  
fprintf("3D Position RMS: X: %.2f, Y: %.2f, Z: %.2f (m)\n",posRMS(1),posRMS(2),posRMS(3));




