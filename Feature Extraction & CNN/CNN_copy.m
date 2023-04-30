%%  Clear environment variables
warning off             % close warnings
close all               % close all prompted windows
clearvars               % clear variables
clc                     % clear command lines


% TST + WP -> KLB
% trial 1: 0.85 (TST + WP) -> 0.15 (TST + WP)
% trial 2: (TST + WP) -> KLB


%%  Import data
filepath = './csvFiles for ML/';
location_name = 'KLB';                               %=====location name for saved testing prediction
receiver_name = 'xiaomi';                             %=====receiver name
Dir1 = '../UrbanNav_IMU/';
Dir2 = 'Newdata_IMU/';
curFolder = [Dir1, Dir2, receiver_name];

% load training data
train_data = readmatrix([filepath, receiver_name,'.csv']);


% load testing data
test_data = readmatrix([filepath, receiver_name,'_test.csv']);

validation = 0;                                      %=====validation (1) or not (0)
disp('===> Data importing complete <===');


%% Allocate training and testing data
% number of training data points
num_samples_train = size(train_data, 1);
% number of features
num_f = size(train_data, 2)-1;
% reorder the sequence in random
train_data = train_data(randperm(num_samples_train), :);  

if validation == 1
    % ratio between number of training to validation
    separa_ratio = 0.85;
    % number of training only datapoints
    num_train_only = round(separa_ratio * num_samples_train); 
    % features for training
    features_train = train_data(1: num_train_only, 2: num_f + 1)'; 
    % labels for training
    labels_train = train_data(1: num_train_only, 1)'; 

    % number of validation only datapoints
    num_test_only = num_samples_train - num_train_only;  
    % features for testing
    features_test = train_data(num_train_only + 1: end, 2: num_f + 1)';        
    % labels for testing
    labels_test = train_data(num_train_only + 1: end, 1)';    
else
    % number of training only datapoints
    num_train_only = num_samples_train; 
    % features for training
    features_train = train_data(:, 2: num_f + 1)'; 
    % labels for training
    labels_train = train_data(:, 1)'; 

    % number of validation only datapoints
    num_test_only = size(test_data, 1);  
    % features for testing
    features_test = test_data(:, 2: num_f + 1)';        
    % labels for testing
    labels_test = test_data(:, 1)';
end
disp('===> Training and testing data separation complete <===');


%%  Data normalization
% use the same normalization for features
[Features_train, normal_input] = mapminmax(features_train, 0, 1);
Features_test = mapminmax('apply', features_test, normal_input);

% use the same normalization for labels
[Labels_train, normal_output] = mapminmax(labels_train, 0, 1);
Labels_test = mapminmax('apply', labels_test, normal_output);


%%  Data reshape

% 3D: (num_features, 1, num_training_datapoints)

% features for training (4D)
Features_train =  double(reshape(Features_train, num_f, 1, 1, num_train_only)); 
% Features_train =  double(reshape(Features_train, num_f, 1, num_train_only)); 
% features for testing (4D)
Features_test  =  double(reshape(Features_test , num_f, 1, 1, num_test_only));
% Features_test  =  double(reshape(Features_test , num_f, 1, num_test_only));
% labels for training (4D)
Labels_train =  double(Labels_train)';                      
% labels for testing (4D)
Labels_test =  double(Labels_test)';                      
disp('===> Data normalization and reshape complete <===');

% CNN structure (04.13 afternoon)
layers = [
 imageInputLayer([num_f, 1, 1])     % 输入层 输入数据规模[num_f, 1, 1]
 
 convolution2dLayer([3, 1], 64)  % 卷积核大小 3*1 生成32张特征图
 batchNormalizationLayer         % 批归一化层
 reluLayer
 maxPooling2dLayer([2, 1],'Stride',2)

 dropoutLayer(0.5)               % Dropout层
 
 convolution2dLayer([3, 1], 64)  % 卷积核大小 3*1 生成32张特征图
 batchNormalizationLayer         % 批归一化层
 reluLayer
 maxPooling2dLayer([2, 1],'Stride',2)

 dropoutLayer(0.5)               % Dropout层

 fullyConnectedLayer(32)
 reluLayer
%  dropoutLayer(0.3)

%  fullyConnectedLayer(32)
%  reluLayer
%  dropoutLayer(0.2)

%  batchNormalizationLayer         % 批归一化层
 fullyConnectedLayer(1)          % 全连接层

 regressionLayer];               % 回归层

analyzeNetwork(layers);
% %%  Network structure
% layers = [
%  imageInputLayer([num_f, 1, 1])     % 输入层 输入数据规模[num_f, 1, 1]
% %     imageInputLayer([1, 1, num_f])
% %     imageInputLayer([num_f, 1])     % 输入层 输入数据规模[num_f, 1, 1]
%  
%  convolution2dLayer([3, 1], 256)  % 卷积核大小 3*1 生成16张特征图
%  batchNormalizationLayer         % 批归一化层
%  reluLayer                       % Relu激活层
% 
%  dropoutLayer(0.2)               % Dropout层
%  
%  convolution2dLayer([3, 1], 128)  % 卷积核大小 3*1 生成32张特征图
%  batchNormalizationLayer         % 批归一化层
%  reluLayer                       % Relu激活层
% 
%  dropoutLayer(0.2)               % Dropout层
% 
%  convolution2dLayer([3, 1], 128)  % 卷积核大小 3*1 生成16张特征图
%  batchNormalizationLayer         % 批归一化层
%  reluLayer                       % Relu激活层
% 
%  dropoutLayer(0.2)               % Dropout层
%  
%  convolution2dLayer([3, 1], 64)  % 卷积核大小 3*1 生成32张特征图
%  batchNormalizationLayer         % 批归一化层
%  reluLayer                       % Relu激活层
% 
%  dropoutLayer(0.5)               % Dropout层
% 
%  reluLayer
%  fullyConnectedLayer(1)          % 全连接层
% 
%  regressionLayer];               % 回归层

% %%  Network structure (04.12 morning)
% layers = [
%  imageInputLayer([num_f, 1, 1])     % 输入层 输入数据规模[num_f, 1, 1]
% %     imageInputLayer([1, 1, num_f])
% %     imageInputLayer([num_f, 1])     % 输入层 输入数据规模[num_f, 1, 1]
%  
%  convolution2dLayer([3, 1], 256)  % 卷积核大小 3*1 生成16张特征图
%  batchNormalizationLayer         % 批归一化层
%  reluLayer                       % Relu激活层
% 
%  dropoutLayer(0.5)               % Dropout层
%  
%  convolution2dLayer([3, 1], 256)  % 卷积核大小 3*1 生成32张特征图
%  batchNormalizationLayer         % 批归一化层
%  reluLayer                       % Relu激活层
% 
%  dropoutLayer(0.5)               % Dropout层
% 
%  convolution2dLayer([3, 1], 128)  % 卷积核大小 3*1 生成16张特征图
%  batchNormalizationLayer         % 批归一化层
%  reluLayer                       % Relu激活层
% 
%  dropoutLayer(0.3)               % Dropout层
%  
%  convolution2dLayer([3, 1], 64)  % 卷积核大小 3*1 生成32张特征图
%  batchNormalizationLayer         % 批归一化层
%  reluLayer                       % Relu激活层
% 
%  dropoutLayer(0.2)               % Dropout层
% 
%  reluLayer
%  fullyConnectedLayer(1)          % 全连接层
% 
%  regressionLayer];               % 回归层

% %%  Network structure (04.12 afternoon)
% layers = [
%  imageInputLayer([num_f, 1, 1])     % 输入层 输入数据规模[num_f, 1, 1]
% %     imageInputLayer([1, 1, num_f])
% %     imageInputLayer([num_f, 1])     % 输入层 输入数据规模[num_f, 1, 1]
%  
%  convolution2dLayer([3, 1], 256)  % 卷积核大小 3*1 生成16张特征图
%  batchNormalizationLayer         % 批归一化层
%  reluLayer                       % Relu激活层
% 
%  dropoutLayer(0.5)               % Dropout层
%  
%  convolution2dLayer([3, 1], 128)  % 卷积核大小 3*1 生成32张特征图
%  batchNormalizationLayer         % 批归一化层
%  reluLayer                       % Relu激活层
% 
%  dropoutLayer(0.3)               % Dropout层
% 
%  convolution2dLayer([3, 1], 64)  % 卷积核大小 3*1 生成16张特征图
%  batchNormalizationLayer         % 批归一化层
%  reluLayer                       % Relu激活层
% 
%  dropoutLayer(0.2)               % Dropout层
%  
%  convolution2dLayer([3, 1], 32)  % 卷积核大小 3*1 生成32张特征图
%  batchNormalizationLayer         % 批归一化层
%  reluLayer                       % Relu激活层
% 
%  dropoutLayer(0.1)               % Dropout层
% 
%  reluLayer
%  fullyConnectedLayer(1)          % 全连接层
% 
%  regressionLayer];               % 回归层


%%  Network parameters settings
% ublox okay!!!
% options = trainingOptions('sgdm', ...      % SGDM 梯度下降算法
%     'MiniBatchSize', 100, ...              % 批大小,每次训练样本个数30
%     'MaxEpochs', 100, ...                  % 最大训练次数 800
%     'InitialLearnRate', 1e-4, ...          % 初始学习率为0.01
%     'LearnRateSchedule', 'piecewise', ...  % 学习率下降
%     'LearnRateDropFactor', 0.5, ...        % 学习率下降因子
%     'LearnRateDropPeriod', 400, ...        % 经过400次训练后 学习率为 0.01 * 0.5
%     'Shuffle', 'every-epoch', ...          % 每次训练打乱数据集
%     'Plots', 'training-progress', ...      % 画出曲线
%     'Verbose', false);


% novatel okay!!!
% options = trainingOptions('sgdm', ...      % SGDM 梯度下降算法
%     'MiniBatchSize', 100, ...              % 批大小,每次训练样本个数30
%     'MaxEpochs', 100, ...                  % 最大训练次数 800 (200 okay)
%     'InitialLearnRate', 1e-4, ...          % 初始学习率为0.01
%     'LearnRateSchedule', 'piecewise', ...  % 学习率下降
%     'LearnRateDropFactor', 0.5, ...        % 学习率下降因子
%     'LearnRateDropPeriod', 400, ...        % 经过400次训练后 学习率为 0.01 * 0.5
%     'Shuffle', 'every-epoch', ...          % 每次训练打乱数据集
%     'Plots', 'training-progress', ...      % 画出曲线
%     'Verbose', false);

% % xiaomi okay!!!:trial 1
% options = trainingOptions('sgdm', ...      % SGDM 梯度下降算法
%     'MiniBatchSize', 100, ...              % 批大小,每次训练样本个数30
%     'MaxEpochs', 100, ...                  % 最大训练次数 800
%     'InitialLearnRate', 1e-4, ...          % 初始学习率为0.01
%     'LearnRateSchedule', 'piecewise', ...  % 学习率下降
%     'LearnRateDropFactor', 0.5, ...        % 学习率下降因子
%     'LearnRateDropPeriod', 400, ...        % 经过400次训练后 学习率为 0.01 * 0.5
%     'Shuffle', 'every-epoch', ...          % 每次训练打乱数据集
%     'Plots', 'training-progress', ...      % 画出曲线
%     'Verbose', false);


disp('===> Neural network structure complete <===');

%%  Analyze the network
% analyzeNetwork(layers);

% disp(num2str(size(Features_train)));
% disp(num2str(size(Labels_train)));

%%  Train the model

for i = 1:20
    model = trainNetwork(Features_train, Labels_train, layers, options);
    
    %%  Model prediction
    % self-validation
    Labels_selfval = predict(model, Features_train);
    % real prediction
    Labels_pred = predict(model, Features_test);
           
    %% Predicted results reverse normalization
    labels_selfval = mapminmax('reverse', Labels_selfval, normal_output);
    labels_pred = mapminmax('reverse', Labels_pred, normal_output);
    
    % labels_selfval(labels_selfval<0, :) = 5;  % added on 2023.04.01
    % labels_pred(labels_pred<0, :) = 5;
    
    labels_selfval = abs(labels_selfval);
    labels_pred = abs(labels_pred);
    
    %% Calculate Errors (RMSE)
    rmse_selfval = sqrt(sum((labels_selfval' - labels_train).^2) ./ num_train_only);
    rmse_pred = sqrt(sum((labels_pred' - labels_test ).^2) ./ num_test_only);
    
    
    %% Visualization
    figure
    plot(1: num_train_only, labels_train, 'r-*', 1: num_train_only, labels_selfval, 'b-o', 'LineWidth', 1)
    legend('Truth', 'Prediction')
    xlabel('sample')
    ylabel('results')
%     string = {'Self-validation of training dataset'; ['RMSE=' num2str(rmse_selfval)]};
    title(['no.', num2str(i) ,' RMSE=', num2str(rmse_selfval)])
    xlim([1, num_train_only])
    grid
    

    rmse_pred = sqrt(sum((labels_pred' - labels_test ).^2) ./ num_test_only);
    figure
    plot(1: num_test_only, labels_test, 'r-*', 1: num_test_only, labels_pred, 'b-o', 'LineWidth', 1)
    legend('Truth', 'Prediction')
    xlabel('sample')
    ylabel('results')
%     string = {'Prediction of testing dataset'; ['RMSE=' num2str(rmse_pred)]};
    title(['no.', num2str(i) ,' RMSE=', num2str(rmse_pred)])
    xlim([1, num_test_only])
    grid
    
    SavedName = ['no.',num2str(i),'_cnn_predict_', receiver_name,'.mat'];
    save(SavedName,'labels_pred','labels_test','num_test_only','model','options','layers', 'normal_input', 'normal_output','rmse_pred');

end
%% Save the trained model
% To local copy
save(['./LocalCopy/cnn_predict_',location_name,'_',receiver_name,'.mat'],'labels_pred','labels_test','num_test_only','model','options','layers', 'normal_input', 'normal_output','rmse_pred');

% To individual folders
SavedName = ['cnn_predict_', receiver_name,'.mat'];
save([curFolder,'/',SavedName],'labels_pred','labels_test','num_test_only','model','options','layers', 'normal_input', 'normal_output','rmse_pred');






% aaa = model_predict(model, normal_input, normal_output, features_test');

