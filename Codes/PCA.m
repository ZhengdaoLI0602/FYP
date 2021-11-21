%%
% Co-drafted by Pin Hsun LEE, Zhengdao LI
% Updated by Zhengdao LI on 2021.11.19
%%
clear coeff score latent

%% Main Settings

whetherToPlot = 1;
whetherToCSV = 0;
test_name = '1234';
% pca_data = cell2mat(Refined_data_FinalV(:,2:size(Refined_data_FinalV,2)));
pca_data = cell2mat(pca_data)
%% Normalize the data for PCA
for i=1:size(pca_data,2)
    PCA_ave = mean(pca_data(:,i));
    PCA_std = std(pca_data(:,i));
    pca_data(:,i)=(pca_data(:,i) - PCA_ave)/PCA_std;
end



%% PCA
[coeff,score,latent] = pca(pca_data, 'numComponent',size(pca_data));  

%% Plot
% pos_error = cell2mat(Refined_data(:,4));
% p = scatter3(score(:,1),score(:,2),score(:,3),10,Truth_value(:,1),'filled'); % PCA1; PCA2; PCA3
if whetherToPlot == 1
    p = scatter3(score(:,1),score(:,2),score(:,3),10,Truth_value(:,1),'filled');

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
    for i=1:size(Truth_value,1)
        fprintf(fid_out,'%d,%d,%d,%d,%d,%d\n',Truth_value(i),score(i,1),score(i,2),score(i,3),score(i,4),score(i,5)); %%
    end
    fclose(fid_out);
end








