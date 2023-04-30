clearvars
clc;
clear;
close all;

%%
% Co-drafted by Zhengdao LI, Pin Hsun LEE
% updated on 09/03/2023
%%
% Refined_data_FinalV: contains all the feature values
% Refined_data: contains both features and truth values before refinement


%% WHETHER TO SAVE THE REFINED CONTENTS================@1
whetherToSave = 1;
Dir1 = '../UrbanNav_IMU/';
Dir2 = 'Newdata_IMU/';
receiver_name = 'novatel';
site_name = 'klb';
curFolder = [Dir1, Dir2, receiver_name,'/'];
SavedName = ['Refined_Content_',site_name,'_',receiver_name,'.mat'];

%%WHETHER TO PLOT THE FEATURES=======================@2
whetherToPlot = 0;

%%LOAD THE LABELLING RESULTS==========================@3
load([curFolder,site_name,'_',receiver_name,'.mat']);



%% Extract the data
for idt = 1: size(GNSS_data,1)  %number of epoches
    Refined_data {idt,1} = GNSS_data{idt,1};   %index of epoch (landmark)

    Refined_data {idt,2} = sqrt(GNSS_data{idt,16}(1)^2  + GNSS_data{idt,16}(2)^2); %EPH (landmark)
    Refined_data {idt,3} = sqrt(GNSS_data{idt,16}(1)^2  + GNSS_data{idt,16}(2)^2 + GNSS_data{idt,16}(3)^2); % 3D error (landmark)

    Refined_data {idt,4} = length(GNSS_data{idt,3})/length(GNSS_data{idt,6});  % number of SV/ total nbr SV (Feature1)

    Refined_data {idt,5} = mean(GNSS_data{idt,4}); % mean elevation angle (Feature2)
    Refined_data {idt,6} = std(GNSS_data{idt,4}); % std elevation angle (Feature3)
    
    Refined_data {idt,7} = mean(GNSS_data{idt,9}(:,4)); % mean C/N0 (Feature4)
    Refined_data {idt,8} = std(GNSS_data{idt,9}(:,4)); % std C/N0 (Feature5)
    
    Refined_data {idt,9} = mean(GNSS_data{idt,9}(:,9)); % Pr residual root(sum of squares) "RSS_e" (Feature6)
   
    Refined_data {idt,10} = mean(abs(GNSS_data{idt,9}(:,6))); % mean Pr residual (Feature7)
    Refined_data {idt,11} = std(abs(GNSS_data{idt,9}(:,6))); % std Pr residual (Feature8)
    
    if size(Pr_rate{idt,1},2)~=0
        Refined_data {idt,12} = mean (abs(GNSS_data{idt,9}(:,7)));   % mean Pr rate consistency (Feature9)
        Refined_data {idt,13} = std(abs(GNSS_data{idt,9}(:,7)));     % std Pr rate consistency (Feature10)
    else
        Refined_data {idt,12} = 0;
        Refined_data {idt,13} = 0;
    end
    
    % added on 04.25
    Refined_data {idt,14} = GNSS_data{idt,18}(1);  % HDOP
    Refined_data {idt,15} = GNSS_data{idt,18}(2);  % VDOP
end

% ===> Refined_data <===
% col1: index of epoch

% col2: EPH (2D error)  
% col3: (EPH^2 + EPV^2)^0.5 (3D error)

% col4: number of SV/ total nbr SV (Feature1)
% col5: mean elevation angle (Feature2)
% col6: std elevation angle (Feature3)
% col7: mean C/N0 (Feature4)
% col8: std C/N0 (Feature5)
% col9: Pr residual root(sum of squares) "RSS_e" (Feature6)
% col10: mean Pr residual (Feature7)
% col11: std Pr residual (Feature8)
% col12: mean Pr rate consistency (Feature9)
% col13: std Pr rate consistency (Feature10)

% col14: HDOP
% col15: VDOP


%% Further Process 1 (delete the invalid values in feature matrix)
idt2Delete = [];
for idt = 1: size(GNSS_data,1)               %loop through epoches
    if (size(Refined_data {idt,2},1)==0) || (size(Refined_data {idt,3},1)==0)|| ...
        (Refined_data {idt,12} ==0) || (Refined_data {idt,12} == 9999)||...
        (Refined_data {idt,13} ==0) || ismissing(Refined_data {idt,2}) || ...
        ismissing(Refined_data {idt,3})         % filter out the missing or abnormal data
        
        idt2Delete = [idt2Delete,idt];
    end
end
Refined_data(idt2Delete,:) = [];               % To delete the invalid sample data

%% Further process 2 (delete the epochs with extreme value)
Refined_data = cell2mat (Refined_data);
ExtremeToDeleteEpoInd1 = [];
ExtremeToDeleteEpoInd2 = [];

% 2.1. Delete NaN value, to prepare ave,std calculation
for i = 2: size (Refined_data,2)
    for j = 1: size (Refined_data,1)  % Delete any NaN, to calculate ave and sigma
        if isnan(Refined_data (j,i))
            ExtremeToDeleteEpoInd1 = [ExtremeToDeleteEpoInd1, j] ; % j: Epoch index to delete
        end
    end
end
ExtremeToDeleteEpoInd1 = unique(ExtremeToDeleteEpoInd1);
Refined_data(ExtremeToDeleteEpoInd1, :) = [];

% 2.2. Select extreme based on normal distribution
for i = 2: size (Refined_data,2)

	sigma = std (Refined_data (:,i));
    ave = mean(Refined_data (:,i));

    for j = 1: size (Refined_data,1)
        if Refined_data (j,i) > (ave+ 4*sigma) || Refined_data (j,i) < (ave - 4*sigma)    % 3 sigma filtering is considered
            ExtremeToDeleteEpoInd2 = [ExtremeToDeleteEpoInd2, j] ; % j: Epoch index
        end
    end
end
ExtremeToDeleteEpoInd2 = unique(ExtremeToDeleteEpoInd2);
Refined_data(ExtremeToDeleteEpoInd2, :) = [];

%% Normalized table
Refined_data_normalized = Refined_data;
col_begin = 4;
col_end = 13;
for i = col_begin : col_end       % Normalizing the columns of features
    this_feature = Refined_data_normalized (:, i);
    this_max = max(this_feature);
    this_min = min(this_feature);
    Refined_data_normalized (:, i) = (Refined_data_normalized (:, i) - this_min)/ (this_max - this_min);

%     (bla - min(bla)) / ( max(bla) - min(bla) )
end
% 
% PCA_ave = mean(pca_data(:,i));
%     PCA_std = std(pca_data(:,i));
%     pca_data(:,i) = (pca_data(:,i) - PCA_ave)/PCA_std;


%% Further Process 3 (obtain the truth value table)
% % RMFV (:,1) = sqrt(cell2mat(Refined_data (:,3)).^2 + cell2mat(Refined_data (:,4)).^2 ); % truth value for positioing error
% RMFV (:,1) = sqrt(Refined_data(:,3).^2); % truth value for positioning error (EPH)
% temp_refined = Refined_data;
% temp_refined(:,3) = [];



%% Final Refinement (Refined_Matrix_Final_Version: RMFV)
% % <== RMFV ==>:
% % Col 1: EPH
% % Col 2: epochs
% % Col 3-12: Feature No.1-10
% % Col 13-14: HDOP,VDOP
% 
% for i = 1: size(temp_refined,2)
%     RMFV (:, i+1) = temp_refined(:,i);
% end
% 
% RMToDelete = [];
% for i = 1: size(RMFV,1)
%     if ismissing(RMFV(i,1))
%         RMToDelete = [RMToDelete, i];
%     end
% end
% RMFV (RMToDelete,:) = [];
% 



%% Saved location
if whetherToSave == 1
    save([curFolder,SavedName],'Refined_data', 'Refined_data_normalized','GNSS_data');
end
save(['.\LocalCopy\',SavedName],'Refined_data','Refined_data_normalized','GNSS_data');

%% Plotting out the features
if whetherToPlot == 1
    %% First Plot 
    figure;
    subplot(3,1,1)
    y0 = Refined_data (:,2);
    plot(y0,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y0)])
    ylabel({'Feature 1:'; 'nSat / total nSat'}) 
 
    subplot(3,1,2)
    y3 = Refined_data (:,4);
    plot(y3,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y3)])
    ylabel({'Feature 2: Mean';'of EA (deg)'}) 
    %%
    subplot(3,1,3)
    y4 = Refined_data (:,5);
    plot(y4,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y4)])
    
    ylabel({'Feature 3: Std of ';'EA (deg)'}) 
    %% Last Plot
    figure;
    y2 = Refined_data (:,3);
    plot(y2,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y2)])
    ylabel('EPH (m)') 
    %% Second Plot
    figure;
    subplot(3,1,1)
    y5 = Refined_data (:,6);
    plot(y5,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y5)])
    ylabel({'Feature 4: Mean';' of C/N0 (dB-Hz)'}) 
    %% 
    subplot(3,1,2)
    y3 = Refined_data (:,7);
    plot(y3,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y3)])
    ylabel({'Feature 5: Std of';'C/N0  (dB-Hz)'}) 
    %%
    subplot(3,1,3)
    y4 = Refined_data (:,8);
    plot(y4,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y4)])
    ylabel({'Feature 8: Std of RSS Pr';' residual  (m)'}) 
    
    %% Fourth Plot
    figure;
    subplot(4,1,1)
    y5 = Refined_data (:,9);
    plot(y5,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y5)])
    ylabel({'Feature 6: Mean';' of Pr residual (m)'}) 
    %%
    subplot(4,1,2)
    y3 = Refined_data (:,10);
    plot(y3,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y3)])
    ylabel({'Feature 7: Std of';'Pr residual (m)'}) 

    %%
    subplot(4,1,3)
    y3 = Refined_data (:,11);
    plot(y3,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y3)])
    ylabel({'Feature 9: Mean of';'consistency';' checking (m)'}) 
    %%
    subplot(4,1,4)
    y4 = Refined_data (:,12);
    plot(y4,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y4)])
    ylabel({'Feature 10: Std of';' consistency ';' checking (m)'}) 

    %%
    xlabel('Epoch') 
end

%% Complete
disp('===> Refinement finished <===');

