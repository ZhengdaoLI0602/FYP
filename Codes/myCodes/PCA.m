%%
% Co-drafted by Pin Hsun LEE, Zhengdao LI
% Updated by Zhengdao LI on 2021.11.17
%%
clear pca_data coeff score latent

% Refined_data_FinalV = cell2mat(Refined_data_FinalV);
pca_data = cell2mat(Refined_data_FinalV(:,2:10));

% Normalize the data for PCA
for i=1:size(pca_data,2)
    PCA_ave = mean(pca_data(:,i));
    PCA_std = std(pca_data(:,i));
    pca_data(:,i)=(pca_data(:,i) - PCA_ave)/PCA_std;
end

[coeff,score,latent] = pca(pca_data, 'numComponent', 3);  

p = scatter3(score(:,1),score(:,2),score(:,3));     %PCA1; PCA2; PCA3
rPCA1 = [min(score(:,1)), max(score(:,1))];
rPCA2 = [min(score(:,2)), max(score(:,2))];
rPCA3 = [min(score(:,3)), max(score(:,3))];

axis([-2 4 -4 10 -8 6])

