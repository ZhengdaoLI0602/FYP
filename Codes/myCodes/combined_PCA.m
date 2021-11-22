%%
% Co-drafted by Pin Hsun LEE, Zhengdao LI
% Updated by Zhengdao LI on 2021.11.19
%%
clear coeff score latent

%% Main Settings

whetherToPlot = 1;
whetherToCSV = 0;
test_name = 'MK';
load('Combined_FeaData.mat')
load('combined_TruthData.mat')



%% Correlation coefficient and select data for pca analysis
% for idt = 2:size(Refined_data_FinalV, 2)
%     R{idt} = corrcoef(truth_data,cell2mat(Refined_data_FinalV(:,idt)));
%     if R{idt}(1,2) <= -0.1 || R{idt}(1,2) >= 0.1
%         pca_data(:,idt-1) = Refined_data_FinalV(:,idt); % idt-1 eliminates the epoch
%     end
% end
% Ridt = corrcoef(truth_data,pca_data(:,1));


CorrToDelete = [];
for idt = 1:size(pca_data, 2)
    R{idt} = corrcoef(truth_data,pca_data(:,idt));
    if abs(R{idt}(1,2)) <= 0.025
        CorrToDelete = [CorrToDelete, idt];
    end
end
pca_data(:,CorrToDelete) = [];
R(CorrToDelete) = []; 


%% Normalize the data for PCA
for i=1:size(pca_data,2)
    PCA_ave = mean(pca_data(:,i));
    PCA_std = std(pca_data(:,i));
    pca_data(:,i)=(pca_data(:,i) - PCA_ave)/PCA_std;
end

%% PCA
[coeff,score,latent] = pca(pca_data, 'numComponent',size(pca_data,2));  %%

%% Add class to the labels (Need to confirm after processing all the data)
% for idx = 1: size(truth_data(:,1),1)
%     if truth_data(idx,1) <= 60
%         truth_data(idx,2) = 1;
%     elseif truth_data(idx,1) > 60 && truth_data(idx,1) <= 120
%         truth_data(idx,2) = 2;
%     elseif truth_data(idx,1) > 120 && truth_data(idx,1) <= 180
%         truth_data(idx,2) = 3;
%     else 
%         truth_data(idx,2) = 4;
%     end
% end

%% Plotting

if whetherToPlot == 1
    p = scatter3(score(:,1),score(:,2),score(:,3),10,truth_data(:,1),'filled');

    xlabel('PCA1');
    ylabel('PCA2');
    zlabel('PCA3');
    title('Principal Component Analysis');
    c = colorbar;
    colormap(jet(256)); %set the colorbar from blue to red
    c.Label.String = 'Positioning Error (m)';
    axis([-4 4 -5 5 -4 6]);
    xticks([-4 -3 -2 -1 0 1 2 3 4]);
    yticks([-5 -4 -3 -2 -1 0 1 2 3 4 5]);
    zticks([-4 -3 -2 -1 0 1 2 3 4 5 6]);
    caxis([0 100]); % set the limit of colorbar 
    rPCA1 = [min(score(:,1)), max(score(:,1))];
    rPCA2 = [min(score(:,2)), max(score(:,2))];
    rPCA3 = [min(score(:,3)), max(score(:,3))];
end


%% Output labels and features matrix (OtMx)

if whetherToCSV  == 1
    
    fid_out = fopen(['csvFiles\',test_name,'_OtMx.csv'],'w+');
    if fid_out<0
        errordlg('File creation failed','Error');
    end

    fprintf(fid_out,'Label,PCA1,PCA2,PCA3,PCA4,PCA5\n');   %%PCA1,2,3: may change to other size
    for i=1:size(truth_data,1)
        fprintf(fid_out,'%d,%d,%d,%d,%d,%d\n',truth_data(i,2),score(i,1),score(i,2),score(i,3),score(i,4),score(i,5)); %%
    end
    
    fclose(fid_out);
end








