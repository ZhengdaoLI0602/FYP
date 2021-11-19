%%
% Co-drafted by Pin Hsun LEE, Zhengdao LI
% Updated by Zhengdao LI on 2021.11.19
%%
clear pca_data coeff score latent

whetherToPlot = 0;
pca_data = cell2mat(Refined_data_FinalV(:,2:size(Refined_data_FinalV,2)));

% Normalize the data for PCA
for i=1:size(pca_data,2)
    PCA_ave = mean(pca_data(:,i));
    PCA_std = std(pca_data(:,i));
    pca_data(:,i)=(pca_data(:,i) - PCA_ave)/PCA_std;
end



%% PCA
[coeff,score,latent] = pca(pca_data, 'numComponent',5);  

%% Plot
% pos_error = cell2mat(Refined_data(:,4));
% p = scatter3(score(:,1),score(:,2),score(:,3),10,Truth_value(:,1),'filled'); % PCA1; PCA2; PCA3
if whetherToPlot == 0
    p = scatter3(score(:,1),score(:,2),score(:,3),10,Truth_value(:,1),'filled');

    xlabel('PCA1');
    ylabel('PCA2');
    zlabel('PCA3');
    title('Principal Component Analysis');
    c = colorbar;
    c.Label.String = 'Positioning Error (m)';
    axis([-2 6 -10 5 -5 8])

    rPCA1 = [min(score(:,1)), max(score(:,1))];
    rPCA2 = [min(score(:,2)), max(score(:,2))];
    rPCA3 = [min(score(:,3)), max(score(:,3))];
end


%% Output labels and features matrix (OtMx)

test_name = '1234';
fid_out = fopen(['csvFiles\',test_name,'_OtMx.csv'],'w+');
if fid_out<0
	errordlg('File creation failed','Error');
end

fprintf(fid_out,'Label,PCA1,PCA2,PCA3,PCA4,PCA5\n');   %%PCA1,2,3: may change to other size
for i=1:size(Truth_value,1)
	fprintf(fid_out,'%d,%d,%d,%d,%d,%d\n',Truth_value(i),score(i,1),score(i,2),score(i,3),score(i,4),score(i,5)); %%
end
fclose(fid_out);









