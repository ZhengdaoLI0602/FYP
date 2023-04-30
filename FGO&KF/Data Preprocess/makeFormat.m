% 
% 
% === NOTE ===
% This was author
% ============
%
%
%
clc
clearvars
close all
D2R = pi/180;
R2D = 180/pi;


%% CONFIGURATION
preDir = 'D:/Codes after Interim/UrbanNav_IMU/';
nameDir1 = 'Newdata_IMU';
receiverName = 'ublox';
siteName = 'klb';
EnvFolder = [preDir, nameDir1,'/', receiverName];
load([EnvFolder,'/Refined_Content_',siteName,'_',receiverName,'.mat']);

% AvaEpochInd = RMFV(:,2);
AvaEpochInd = Refined_data_normalized(:,1);
% Stime = AvaEpochInd(1);% The start time
Stime = 457695;% The start time of ublox, in order to make comparisons
Etime = 923; %size(RMFV,1); % Total evaluation time (mannually)

% FloatClass for KF
load([EnvFolder,'/cnn_predict_',receiverName,'.mat']);
% labels_pred = labels_pred';


%% LOAD GT DATA
CPT_data0 = readmatrix([EnvFolder,['/gt_',siteName,'.txt']]);
for idt = 2:size(CPT_data0,1)   
    %col 2,10,11??
    CPT_Data(idt-1,1) = CPT_data0(idt,3);
    CPT_Data(idt-1,3) = CPT_data0(idt,3);        %GPST
    CPT_Data(idt-1,4) = CPT_data0(idt,4) + CPT_data0(idt,5)/60 + CPT_data0(idt,6)/3600;
    CPT_Data(idt-1,5) = CPT_data0(idt,7) + CPT_data0(idt,8)/60 + CPT_data0(idt,9)/3600;
    CPT_Data(idt-1,6) = CPT_data0(idt,10);
    
    CPT_Data(idt-1,12) =  CPT_data0(idt,19) ;  % yaw 
    CPT_Data(idt-1,7) = CPT_data0(idt,12)   ;   % north velocity
    CPT_Data(idt-1,8) = CPT_data0(idt,11)   ;   % east velocity
    CPT_Data(idt-1,9) = -CPT_data0(idt,13)  ;  % down velocity  
end  

CPT_Data(:,20) = CPT_Data(:,3); % document CPT GPST
disp('===> CPT data loading complete <===');


%% LOAD IMU DATA
IMUFileName = ['/imu_',siteName,'_',receiverName,'.csv'];
imu_data = IMU_dataConverter([EnvFolder , IMUFileName]);
% ---> Raw File:
% col 3: utc time
% col 5-8 : orientation (axis: x,y,z,w) 
% col 18-20 : angular velocity (axis: x, y, z)
% col 30-32 : linear acceleration (axis: x, y, z)
% ---> IMU_Data:
% col (1): UTC_time
% col (4-6): linear acceleration (axis: x, y, z)
% col (7-9): angular velocity (axis: x, y, z)
% col (10-13): orientation (axis: x,y,z,w)

IMU_Data = [imu_data(:,1), zeros(size(imu_data,1),2), imu_data(:,2:11)];  
IMU_Data(:,20) = IMU_Data(:,1); % document IMU GPST

All_Orient = IMU_Data(:,10:13);
% All_GyroReadings = IMU_Data(:,7:9);
% All_AccelReadings = IMU_Data(:,4:6);
disp('===> IMU data loading complete <===');


%% LOAD GNSS DATA
GNSSFileName = ['/',siteName,'_',receiverName,'.mat'];
load([EnvFolder, GNSSFileName], 'GNSS_data');
GNSS_Data = GNSS_data;
All_GNSSReadings = cell2mat(GNSS_Data(:,2)); % GNSS positioning solution
All_DOP = cell2mat(GNSS_Data(:,18)); % GNSS DOP info (HDOP; VDOP)
GNSS_Data(:,20) = GNSS_Data(:,1); % document GNSS GPST 
disp('===> GNSS data loading complete <===');


%% SYNCHRONIZATION
% ---- synchronization begins ----
% starting time
[~,temp.CPT_ids] = min(abs(CPT_Data(:,1)-Stime));
CPT_Data(1:(temp.CPT_ids-1),:)=[];
[~,temp.GNSS_ids] = min(abs([GNSS_Data{:,1}]-Stime));
GNSS_Data(1:(temp.GNSS_ids-1),:)=[];
% GNSS_Data(1:(temp.GNSS_ids),:)=[];
[~,temp.IMU_ids] = min(abs(IMU_Data(:,1)-Stime));

% % Estimate "zero shift" of imu data using the previous 10 seconds before Stime
% initial_period = find(floor(IMU_Data(:,1))==(floor(IMU_Data(temp.IMU_ids,1))-10+1));
% initial_point_id = initial_period(1,1);
% initial_imu_data = initial_point_id: (temp.IMU_ids-1);
% zero_drift_est = mean(IMU_Data(initial_imu_data', 4:9));
% IMU_Data(:,4:9) = IMU_Data(:,4:9) - zero_drift_est;
% % give gravity acc back (9.80665m/s^2)
% IMU_Data(:,6) = IMU_Data(:,6) + 9.80665;

IMU_Data(1:(temp.IMU_ids-1),:)=[];

% index for CPT,IMU, GNSS starting from 1
CPT_Data(:,1) = CPT_Data(:,1)-Stime+1;
IMU_Data(:,1) = IMU_Data(:,1)-Stime+1;
for idt = 1:size(GNSS_Data,1)
    GNSS_Data{idt,12} = GNSS_Data{idt,1}-Stime+1;
end

% consider the evaluation period only
CPT_Data(CPT_Data(:,1)>Etime,:) = [];
IMU_Data(IMU_Data(:,1)>Etime,:) = [];
GNSS_Data([GNSS_Data{:,12}]'>Etime,:) = [];

% data synchronization
temp.GT_t0 = CPT_Data(2,1);
temp.GT_t = CPT_Data(2:end,1);
temp.GNSS_t = [GNSS_Data{:,12}]';
temp.IMU_t = IMU_Data(:,1);
[~,temp.GNSS_ids] = min(abs(temp.GNSS_t-temp.GT_t0));
[~,temp.IMU_ids] = min(abs(temp.IMU_t-temp.GT_t0));

% minor adjustment
minor_imu1 = IMU_Data(temp.IMU_ids);
minor_imu2 = IMU_Data(temp.IMU_ids + 1);
minor_round = ceil(IMU_Data(temp.IMU_ids));
if (minor_round > minor_imu1) && (minor_round < minor_imu2)
    temp.IMU_ids = temp.IMU_ids + 1;
end

CPT_Data(1,:) = [];
IMU_Data(1:(temp.IMU_ids-1),:)=[];
GNSS_Data(1:(temp.GNSS_ids-1),:)=[];
disp('===> Data synchronization complete <===');

% filter out points whose absolute altitude over 2000m %
num_gnss = size(GNSS_Data,1);
this_llh = zeros(num_gnss,3);
extreme_ind=[];
for i = 1: num_gnss
    this_dop(i,:) = cell2mat(GNSS_Data(i,18));
    if abs(this_dop(i,1)) >= 1e2 && abs(this_dop(i,2)) >= 1e2
        extreme_ind = [extreme_ind; i];
    end
end
if ~isempty(extreme_ind)
    extreme_gnssT = GNSS_Data{extreme_ind,1};
    GNSS_Data(extreme_ind,:)=[];
end
% ---- synchronization ends -----


%% MAKE SENSORDATA
lla0 = GNSS_data{find(cell2mat(GNSS_data(:,1))==(Stime+1)),2}([2,1,3]); 
                % the local origin to convert LLH to ENU

for idt = 1: size(GNSS_Data,1)
    Cur_GNSS_Epoch = cell2mat(GNSS_Data(idt, 20));
    corres_ids_in_imu = find(IMU_Data(:,20)>Cur_GNSS_Epoch & IMU_Data(:,20)<(Cur_GNSS_Epoch+1));
    GNSS_Data{idt,19} = corres_ids_in_imu;
end

% Filter out GNSS epochs not in imu data
EmptyToDelete = [];
for i =1:size(GNSS_Data,1)
    if size(cell2mat(GNSS_Data(i,19)),1)==0 % disgard null value epochs
        EmptyToDelete = [EmptyToDelete,i];
    end
end
GNSS_Data(EmptyToDelete,:) = [];

% get all the valid gnss epochs after PCA (feature extraction)
valid_ts_in_pca = AvaEpochInd; 
% GNSS_Data -> pca %
% [~,temp.valid_gnssLoc_after_pca] = ismember(cell2mat(GNSS_Data(:,20)), valid_ts_in_pca);
% prediction -> GNSS_Data %
[~,temp.valid_pcaLoc_after_gnss] = ismember(valid_ts_in_pca,cell2mat(GNSS_Data(:,20)));
% GNSS_Data = GNSS_Data((temp.valid_gnssLoc_after_pca~=0) , :);

% Final predicted labels and the GPST %
labels_pred = labels_pred((temp.valid_pcaLoc_after_gnss~=0),:);
valid_ts_in_pca = valid_ts_in_pca((temp.valid_pcaLoc_after_gnss~=0),:);
ml_prediction = double([valid_ts_in_pca, labels_pred]);

% % get all the predictions %
% ml_prediction = zeros(size(GNSS_Data, 1), 2);
% for i = 1 :size(GNSS_Data, 1)
%     this_pred = labels_pred(find(valid_ts_in_pca(:,1)  == cell2mat(GNSS_Data(i,20))), 1);
%     ml_prediction(i,1) = cell2mat(GNSS_Data(i,20));
%     if ~isempty(this_pred)
%         ml_prediction(i,2) = this_pred;
%     else
%         ml_prediction(i,2) = nan;
%     end
% end

% [~,temp.valid_cptLoc_after_pca] = ismember(CPT_Data(:,20), cell2mat(GNSS_Data(:,20)));
% CPT_Data = CPT_Data(temp.valid_cptLoc_after_pca~=0, :); % CPT_Data- > GNSS_Data

% CPT_Data -> IMU data& GNSS data %
End_epoch = min(floor(IMU_Data(end,20)), GNSS_Data{end,1});
CPT_Data(find(CPT_Data(:,3)==End_epoch) +1: end, :) = []; 

disp('===> Valid epochs after feature selection complete <===');

% IMU_index_new2 = [];
% for i = 1: size(GNSS_Data,1)
%     IMU_index_new1{i , 1}  = GNSS_Data{i,19};
%     IMU_index_new2 = [IMU_index_new2 , IMU_index_new1{i , 1}'];
% end
% IMU_Data = IMU_Data(IMU_index_new2',:);

% Number of gnss epochs theoretically
num_gnss_pseu_epoch = GNSS_Data{end,1} - GNSS_Data{1,1} + 1;

% for idt = 1: size(GNSS_Data,1)
%     sensorData {1,idt}. GyroReadings = All_GyroReadings (GNSS_Data{idt,19},:);
%     sensorData {1,idt}. AccelReadings = All_AccelReadings (GNSS_Data{idt,19},:);
%     sensorData {1,idt}. GNSSReading = GNSS_Data{idt, 2}([2,1,3]);
%     
%     sensorData {1,idt}. numIMUReadings = length(GNSS_Data{idt,19});
%     numIMUSamplesPerGPS (idt,1) = length(GNSS_Data{idt,19});
%     sensorData {1,idt}. HDOP = GNSS_Data{idt, 18}(1,1);
%     sensorData {1,idt}. VDOP = GNSS_Data{idt, 18}(1,2);
%     sensorData {1,idt}. GnssT = GNSS_Data{idt, 20};
% end


% Start_gnss_time = Stime + 1;
% id_gnss_valid_epoch = 1;


whether_gnss_valid_epoch = 1;
sensor_idx = 1;
for idt = 1: 1: num_gnss_pseu_epoch
    % check whether valid epoch after feature extraction
%     if ismember((Stime+idt), cell2mat(GNSS_Data(:,1)))
%         whether_gnss_valid_epoch = 1;
%     else
%         whether_gnss_valid_epoch = 0;
%     end

%     sensorData {1,sensor_idx}. GyroReadings = IMU_Data (floor(IMU_Data(:,20))==(Stime+idt), 11:13);
    sensorData {1,idt}. GyroReadings = IMU_Data (floor(IMU_Data(:,20))==(Stime+idt), 11:13);
%     sensorData {1,sensor_idx}. AccelReadings = IMU_Data (floor(IMU_Data(:,20))==(Stime+idt), 8:10);
    sensorData {1,idt}. AccelReadings = IMU_Data (floor(IMU_Data(:,20))==(Stime+idt), 8:10);
%     sensorData {1,sensor_idx}. numIMUReadings = size(sensorData{1,sensor_idx}.GyroReadings , 1);
    sensorData {1,idt}. numIMUReadings = 400; %length(GNSS_Data{idt,19});
%     numIMUSamplesPerGPS (sensor_idx,1) = size(sensorData{1,sensor_idx}.GyroReadings , 1);
    numIMUSamplesPerGPS (idt,1) = 400; %length(GNSS_Data{idt,19});
%     sensorData {1,sensor_idx}. whether_gnss_valid  = whether_gnss_valid_epoch;
%     sensorData {1, idt}. whether_gnss_valid  = whether_gnss_valid_epoch;
%     sensorData {1,sensor_idx}. GnssT = Stime+idt;
    sensorData {1,idt}. GnssT = Stime+idt;
%     sensorData {1,idt}. GNSSReading = GNSS_Data{idt, 2}([2,1,3]);
    GNSS_raw_index = find(cell2mat(GNSS_data(:,1))==(Stime+idt));
    % not valid GNSS epoch after feature extraction
    if ~isempty(extreme_ind) && ismember((Stime+idt), extreme_gnssT) 
        sensorData {1,idt}. GNSSReading = nan;
    elseif ~isempty(GNSS_raw_index)
        % has GNSS ls solution
%         sensorData {1,sensor_idx}. GNSSReading = GNSS_data{GNSS_raw_index, 2}([2,1,3]);
        sensorData {1,idt}. GNSSReading = GNSS_data{GNSS_raw_index, 2}([2,1,3]);
    else
        % no GNSS ls solution; reset the index so that recovered in next iteration 
%         sensor_idx = sensor_idx - 1;
        sensorData {1,idt}. GNSSReading = nan;
    end   
%     sensor_idx = sensor_idx + 1;
end

% Add ML prediction (Col21) results in the GNSS data  %added on 2023.04.07
% for ind = 1:size(labels_pred,1)
%     GNSS_Data{ind, 21} = labels_pred(ind,1);
% end

% cnn_predict = [valid_ts_in_pca, labels_pred];   %added on 2023.04.03
% (to sychronize the data together based on the time labels)

disp('===> sensorData and ML prediction data set up <===');


% AHRS regulation
for idt = 1:size(IMU_Data,1)
    disp(['AHRS Processing--> ',num2str(idt),'/',num2str(size(IMU_Data,1))])
    temp_imu_eul(idt,1) = IMU_Data(idt,1);
    temp_imu_eul(idt,2:4) = quat2eul(IMU_Data(idt,10:13)).*[R2D,R2D,R2D];
    %yaw
    temp_imu_eul(idt,4) = -temp_imu_eul(idt,4);
    if temp_imu_eul(idt,4) < 0
        temp_imu_eul(idt,4) = temp_imu_eul(idt,4)+360;
    end
    %roll
    if temp_imu_eul(idt,2)<0
        temp_imu_eul(idt,2) = temp_imu_eul(idt,2)+360;
    end
    temp_imu_eul(idt,2) = -temp_imu_eul(idt,2)+180;
    %pitch
    temp_imu_eul(idt,3) = -temp_imu_eul(idt,3);
end
IMU_Data(:,14:16) = temp_imu_eul(:,[3,2,4]); %(pitch; roll; yaw)
disp('===> AHRS set up <===');

%% OTHER PARAMETERS
%  @ numGPSSamplesPerOptim
% numGPSSamplesPerOptim = 100;
%  @ Initial position
initPos = [0,0,0]; 
%  @ IMU freq
imuFs = 400; 
%  @ Freq ratio
numGPSSamplesPerOptim = 2;
%  @ imuNoise
%   Gyro noise PSD (deg^2 per hour, converted to rad^2/s)  
    imuNoise.GyroscopeNoise = 3.158273408348594e-04*eye(3); %0.005^2 * eye(3);
%   Accelerometer noise PSD (micro-g^2 per Hz, converted to m^2 s^-3)                
    imuNoise.AccelerometerNoise = 1.23182208e-04*eye(3); %0.008^2 * eye(3);
%   Accelerometer bias random walk PSD (m^2 s^-5)
    imuNoise.AccelerometerBiasNoise = ...
        diag([9.62361e-09  9.62361e-09 2.16531225e-08]); %1.0E-5 * eye(3);
%   Gyro bias random walk PSD (rad^2 s^-3)
    imuNoise.GyroscopeBiasNoise = 6.633890475354988e-09*eye(3)  ;% 4.0E-11 * eye(3);
%  @ Initial orient
initOrient = quaternion(All_Orient(1,4),All_Orient(1,1),All_Orient(1,2),All_Orient(1,3));
%  @ GT (or LLA)
posLLH = CPT_Data(:,4:6);
% for i = 1:size(sensorData,2)
%     posLLH_fgo(i,:) = CPT_Data(find(CPT_Data(:,3) == sensorData{1,i}.GnssT),4:6);
% end

%  @ Parameters for KF
D2R = pi/180;
R2D = 180/pi;
deg_to_rad = 0.01745329252;
rad_to_deg = 1 / deg_to_rad;
micro_g_to_meters_per_second_squared = 9.80665E-6;
% Initial attitude uncertainty per axis (deg, converted to rad)
LC_KF_config.init_att_unc = deg2rad(2);
% Initial velocity uncertainty per axis (m/s)
LC_KF_config.init_vel_unc = 0.1;
% Initial position uncertainty per axis (m)
LC_KF_config.init_pos_unc = 10;
% Initial accelerometer bias uncertainty per instrument (micro-g, converted to m/s^2)
LC_KF_config.init_b_a_unc = 10000 * micro_g_to_meters_per_second_squared;
% Initial gyro bias uncertainty per instrument (deg/hour, converted to rad/sec)
LC_KF_config.init_b_g_unc = 200 * deg_to_rad / 3600;

% Gyro noise PSD (deg^2 per hour, converted to rad^2/s)                
LC_KF_config.gyro_noise_PSD = 0.005^2;
% Accelerometer noise PSD (micro-g^2 per Hz, converted to m^2 s^-3)                
LC_KF_config.accel_noise_PSD = 0.008^2;
% Accelerometer bias random walk PSD (m^2 s^-5)
% LC_KF_config.accel_bias_PSD = 1.0E-5; 
LC_KF_config.accel_bias_PSD = 1.0E-10; % newly testing on 2022.04.24
% Gyro bias random walk PSD (rad^2 s^-3)
LC_KF_config.gyro_bias_PSD = 4.0E-11;

% Position measurement noise SD per axis (m)
LC_KF_config.pos_meas_SD = 25;
% Velocity measurement noise SD per axis (m/s)
LC_KF_config.vel_meas_SD = 10;
disp('===> Other parameters set up <===');


%% SAVE FILES
% valid_ts_in_pca = cell2mat(RMFV(:,2)); % get all the valid gnss epochs after PCA
% [~,temp.valid_loc_in_GT2] = ismember(valid_ts_in_pca, posLLH(:,1:3));
% CPT_Ref = posLLH(temp.valid_loc_in_GT2,:); % GT for plotting
% [~,temp.valid_loc_in_GNSS] = ismember(valid_ts_in_pca, posLLH(:,1:3));


% save ([EnvFolder,'/IntiResults/IMUGNSS4FGO.mat'],'sensorData','imuFs','initPos',...
%     'initOrient','imuNoise','LC_KF_config','numGPSSamplesPerOptim','numIMUSamplesPerGPS', 'posLLH','lla0','fuzzyOutput');

save ([EnvFolder,'/IntiResults/IMUGNSS4FGO.mat'],'sensorData','imuFs','initPos',...
    'initOrient','imuNoise','LC_KF_config','numGPSSamplesPerOptim','numIMUSamplesPerGPS', ...
    'posLLH');

% save ([EnvFolder,'/IntiResults/IMUGNSS4KF.mat'],'GNSS_Data','IMU_Data','CPT_Data',...
%     'D2R','R2D','deg_to_rad','LC_KF_config','micro_g_to_meters_per_second_squared',...
%     'rad_to_deg','fuzzyOutput');

save ([EnvFolder,'/IntiResults/IMUGNSS4KF.mat'],...
    'D2R','R2D','deg_to_rad','LC_KF_config','micro_g_to_meters_per_second_squared',...
    'rad_to_deg');


save ('DirInfo.mat','EnvFolder');
save ([EnvFolder,'/IntiResults/ComInfo.mat'],'EnvFolder','GNSS_Data','GNSS_data','IMU_Data','CPT_Data','lla0','ml_prediction');
disp('===> All files saved <===');





