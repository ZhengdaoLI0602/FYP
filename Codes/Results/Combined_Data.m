%% WP data (input line 3, 16)
ToDelete=[];
load('WP\xiaomi\WP_xiaomi');
receiver_GNSS_data = GNSS_data;
for idt=1:size(Pr_rate,1)
    if isempty(Pr_rate{idt,1})
        ToDelete = [ToDelete, idt];
    end
end
Pr_rate(ToDelete,:)=[];
receiver_Pr_rate = Pr_rate;
clearvars -except receiver_GNSS_data receiver_Pr_rate;

%% TST data
ToDelete=[];
load('TST\xiaomi\TST_xiaomi');
receiver_GNSS_data = [receiver_GNSS_data; GNSS_data];
for idt=1:size(Pr_rate,1)
    if isempty(Pr_rate{idt,1})
        ToDelete = [ToDelete, idt];
    end
end
Pr_rate(ToDelete,:)=[];
receiver_Pr_rate = [receiver_Pr_rate; Pr_rate];
clearvars -except receiver_GNSS_data receiver_Pr_rate;

%% Extract the data
whetherToPlot = 1;
for idt = 1: size(receiver_GNSS_data,1)  %number of epoches
    Refined_data {idt,1} = receiver_GNSS_data{idt,1};   %index of epoch
    Refined_data {idt,2} = length(receiver_GNSS_data{idt,3})/length(receiver_GNSS_data{idt,6});  % number of SV/ total nbr SV #
    Refined_data {idt,3} = sqrt(receiver_GNSS_data{idt,16}(3)^2); % EPV
    Refined_data {idt,4} = sqrt(receiver_GNSS_data{idt,16}(1)^2  + receiver_GNSS_data{idt,16}(2)^2); %EPH

    Refined_data {idt,5} = mean(receiver_GNSS_data{idt,4}); % mean elevation angle #
    Refined_data {idt,6} = std(receiver_GNSS_data{idt,4}); % std elevation angle #
    
    Refined_data {idt,7} = mean(receiver_GNSS_data{idt,9}(:,4)); % mean C/N0 #
    Refined_data {idt,8} = std(receiver_GNSS_data{idt,9}(:,4)); % std C/N0 #
    
    Refined_data {idt,9} = mean(receiver_GNSS_data{idt,9}(:,9)); % Pr residual RSS_e #
   
%     ToCheck = receiver_GNSS_data{idt,9}(:,6);
    Refined_data {idt,10} = mean(abs(receiver_GNSS_data{idt,9}(:,6))); % mean Pr residual #
    Refined_data {idt,11} = std(abs(receiver_GNSS_data{idt,9}(:,6))); % std Pr residual #
    
    if size(receiver_Pr_rate{idt,1},2)~=0
        Refined_data {idt,12} = mean (abs(receiver_GNSS_data{idt,9}(:,7)));   % mean Pr rate consistency #
        Refined_data {idt,13} = std(abs(receiver_GNSS_data{idt,9}(:,7)));       %std Pr rate consistency #
    else
        Refined_data {idt,12} = 0;
        Refined_data {idt,13} = 0;
    end
end

%% Further Process 1 (delete the invalid values in feature matrix)
idt2Delete = [];
for idt = 1: size(receiver_GNSS_data,1)  %number of epoches
    if (size(Refined_data {idt,3},1)==0) ||(size(Refined_data {idt,4},1)==0)|| ...
        (Refined_data {idt,12} ==0) || (Refined_data {idt,12} == 9999)||...
        (Refined_data {idt,13} ==0) 
        idt2Delete = [idt2Delete,idt];
    end

end
Refined_data(idt2Delete,:)=[]; % To delete the invalid sample data

%% Delete the Vertical errors
Refined_data (:,3) = [];

% extreme number of total SV: no data !!!!
%% Further process 2 (delete the epochs with extreme value)
Refined_data = cell2mat (Refined_data);
ExtremeToDeleteFeaInd = [];
ExtremeToDeleteEpoInd = [];
for i = 2: size (Refined_data,2)
%     if i == 3  % delete the vertial errors already
%         continue;
%     end
	sigma = std (Refined_data (:,i));
    ave = mean(Refined_data (:,i));
    for j = 1: size (Refined_data,1)
        if Refined_data (j,i) > (ave+ 4*sigma) || Refined_data (j,i) < (ave - 4*sigma)
            ExtremeToDeleteFeaInd = [ExtremeToDeleteFeaInd, i] ; % i: Feature index
            ExtremeToDeleteEpoInd = [ExtremeToDeleteEpoInd, j] ; % j: Epoch index
        end
    end
end
ExtremeToDelete = [ExtremeToDeleteFeaInd; ExtremeToDeleteEpoInd]';

ExtremeToDeleteEpoInd = unique(ExtremeToDeleteEpoInd);
Refined_data(ExtremeToDeleteEpoInd, :) = [];
%% Further Process 3 (obtain the truth value table)
% RMFV (:,1) = sqrt(cell2mat(Refined_data (:,3)).^2 + cell2mat(Refined_data (:,4)).^2 ); % truth value for positioing error
RMFV (:,1) = sqrt(Refined_data (:,3).^2 ); % truth value for positioing error (EPH)
temp_refined = Refined_data;
temp_refined(:,3) = [];



%% Final Refinement (Refined_Matrix_Final_Version: RMFV)
%  ==RMFV==:
% Col 1: EPH
% Col 2: epochs
% Col 3 -12: Feature No.1-10

for i = 1: size(temp_refined,2)
    RMFV (:, i+1) = temp_refined(:,i);
end

RMToDelete = [];
for i = 1: size(RMFV,1)
    if ismissing(RMFV(i,1))
        RMToDelete = [RMToDelete, i];
    end
end
RMFV (RMToDelete,:) = [];


% if whetherToSave == 1
%     save([Dir1,Dir2,Dir3,SavedName],'RMFV','Refined_data','ExtremeToDelete');
% end
% save(['.\LocalCopy\',SavedName],'RMFV','Refined_data','ExtremeToDelete');


if whetherToPlot == 1
    %% First Plot    
    figure;
    tiledlayout(5,1)
    nexttile
    plot(Refined_data (:,2),'b');
    xlim([0 1.05*size(Refined_data,1)])
    ylim([0 1.05*max(Refined_data (:,2))])
    xlabel('Epoch')
    ylabel({'Feature 1:'; 'nSat / total nSat'})
    
    nexttile
    plot(Refined_data (:,4),'b')
    xlim([0 1.05*size(Refined_data,1)])
    ylim([0 1.05*max(Refined_data (:,4))])
    xlabel('Epoch')
    ylabel({'Feature 2: Mean';'of EA (deg)'}) 
    
    nexttile
    plot(Refined_data (:,5),'b')
    xlim([0 1.05*size(Refined_data,1)])
    ylim([0 1.05*max(Refined_data (:,5))])
    xlabel('Epoch')
    ylabel({'Feature 3: Std of ';'EA (deg)'}) 
     
    nexttile
    plot(Refined_data (:,6),'b')
    xlim([0 1.05*size(Refined_data,1)])
    ylim([0 1.05*max(Refined_data (:,6))])
    xlabel('Epoch')
    ylabel({'Feature 4: Mean';' of C/N0 (dB-Hz)'}) 
     
    nexttile
    plot(Refined_data (:,7),'b')
    xlim([0 1.05*size(Refined_data,1)])
    ylim([0 1.05*max(Refined_data (:,7))])
    xlabel('Epoch')
    ylabel({'Feature 5: Std of';'C/N0  (dB-Hz)'}) 
    
    %% Second Plot
    figure;
    tiledlayout(5,1)
    nexttile
    plot(Refined_data (:,9),'b')
    xlim([0 1.05*size(Refined_data,1)])
    ylim([0 1.05*max(Refined_data (:,9))])
    xlabel('Epoch')
    ylabel({'Feature 6: Mean';' of Pr residual (m)'})
   
    nexttile
    plot(Refined_data (:,10),'b')
    xlim([0 1.05*size(Refined_data,1)])
    ylim([0 1.05*max(Refined_data (:,10))])
    xlabel('Epoch')
    ylabel({'Feature 7: Std of';'Pr residual (m)'}) 

    nexttile
    plot(Refined_data (:,8),'b')
    xlim([0 1.05*size(Refined_data,1)])
    ylim([0 1.05*max(Refined_data (:,8))])
    xlabel('Epoch')
    ylabel({'Feature 8: Std of RSS Pr';' residual  (m)'}) 
    
    nexttile
    plot(Refined_data (:,11),'b')
    xlim([0 1.05*size(Refined_data,1)])
    ylim([0 1.05*max(Refined_data (:,11))])
    xlabel('Epoch')
    ylabel({'Feature 9: Mean of';'consistency';' checking (m)'}) 

    nexttile
    plot(Refined_data (:,12),'b')
    xlim([0 1.05*size(Refined_data,1)])
    ylim([0 1.05*max(Refined_data (:,12))])
    xlabel('Epoch')
    ylabel({'Feature 10: Std of';' consistency ';' checking (m)'}) 
     
    %% Third Plot
    figure;
    tiledlayout(1,1)
    nexttile
    plot(Refined_data (:,3),'b')
    xlim([0 1.05*size(Refined_data,1)])
    ylim([0 1.05*max(Refined_data (:,3))])
    xlabel('Epoch')
    ylabel('EPH (m)') 
end

%%
% Co-drafted by Pin Hsun LEE, Zhengdao LI
% Updated by Zhengdao LI on 2021.12.17

%% PCA Analysis
clear coeff score latent truth_data pca_data
whetherToPlot = 1;
whetherToCSV = 1;
%% Load the files
pca_data = RMFV(:, 3:end);   % feature data and truth data for each set of data
truth_data = RMFV(:, 1);


%% Correlation coefficient and select data for pca analysis
% CorrToDelete = [];
% for idt = 1:size(pca_data, 2)
%     R{idt} = corrcoef(truth_data,pca_data(:,idt));
%     if abs(R{idt}(1,2)) <= 0.05
%         CorrToDelete = [CorrToDelete, idt];
%     end
%     R1 (idt, 1)  = abs(R{idt}(1,2));
% end
% 
% pca_data(:,CorrToDelete) = [];
% R(CorrToDelete) = []; 

%% Normalize the data for PCA
for i=1:size(pca_data,2)
    PCA_ave = mean(pca_data(:,i));
    PCA_std = std(pca_data(:,i));
    pca_data(:,i) = (pca_data(:,i) - PCA_ave)/PCA_std;
end

%% PCA
[coeff,score,latent] = pca(pca_data, 'numComponent', size(pca_data,2));

%% Plotting

if whetherToPlot == 1
    figure;
    tiledlayout(1,1)
    nexttile
    p = scatter3(score(:,1),score(:,2),score(:,3),10,truth_data(:,1),'filled');
    xlabel('PCA1');
    ylabel('PCA2');
    zlabel('PCA3');
    title('Principal Component Analysis');
    c = colorbar;
    colormap(jet(256)); %set the colorbar from blue to red
    c.Label.String = 'Positioning Error (m)';
%     axis([-4 4 -5 5 -4 6]);
%     xticks([-4 -3 -2 -1 0 1 2 3 4]);
%     yticks([-5 -4 -3 -2 -1 0 1 2 3 4 5]);
%     zticks([-4 -3 -2 -1 0 1 2 3 4 5 6]);
    caxis([0 30]); % set the limit of colorbar 
    rPCA1 = [min(score(:,1)), max(score(:,1))];
    rPCA2 = [min(score(:,2)), max(score(:,2))];
    rPCA3 = [min(score(:,3)), max(score(:,3))];
end


%% Output labels and features matrix (OtMx)

if whetherToCSV  == 1
    
    fid_out = fopen(['WP_xaiomi_ML.csv'],'w+');
    if fid_out<0
        errordlg('File creation failed','Error');
    end

    fprintf(fid_out,'Label,PCA1,PCA2,PCA3,PCA4,PCA5,PCA6,PCA7\n');   %%PCA1,2,3: may change to other size
    for i=1:size(truth_data,1)
        fprintf(fid_out,'%d,%d,%d,%d,%d,%d,%d,%d\n',truth_data(i,1),score(i,1),score(i,2),score(i,3),score(i,4),score(i,5),score(i,6),score(i,7)); %%
    end
    
    fclose(fid_out);
end