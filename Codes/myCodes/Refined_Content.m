clear Refined_data Truth_value temp_refined R pca_data RMFV 
clear ExtremeToDelete ExtremeToDeleteEpoInd ExtremeToDeleteFeaInd
%%
% Co-drafted by Zhengdao LI, Pin Hsun LEE
% updated on 17/12/2021
%%

% Refined_data_FinalV: contains all the feature values
% Refined_data: contains both features and truth values before refinement

whetherToPlot = 1;
%% Extract the data
for idt = 1: size(GNSS_data,1)  %number of epoches
    Refined_data {idt,1} = GNSS_data{idt,1};   %index of epoch
    Refined_data {idt,2} = length(GNSS_data{idt,3})/length(GNSS_data{idt,6});  % number of SV/ total nbr SV #
    Refined_data {idt,3} = sqrt(GNSS_data{idt,16}(3)^2); % EPV
    Refined_data {idt,4} = sqrt(GNSS_data{idt,16}(1)^2  + GNSS_data{idt,16}(2)^2); %EPH

    Refined_data {idt,5} = mean(GNSS_data{idt,4}); % mean elevation angle #
    Refined_data {idt,6} = std(GNSS_data{idt,4}); % std elevation angle #
    
    Refined_data {idt,7} = mean(GNSS_data{idt,9}(:,4)); % mean C/N0 #
    Refined_data {idt,8} = std(GNSS_data{idt,9}(:,4)); % std C/N0 #
    
    Refined_data {idt,9} = mean(GNSS_data{idt,9}(:,9)); % Pr residual RSS_e #
   
%     ToCheck = GNSS_data{idt,9}(:,6);
    Refined_data {idt,10} = mean(abs(GNSS_data{idt,9}(:,6))); % mean Pr residual #
    Refined_data {idt,11} = std(abs(GNSS_data{idt,9}(:,6))); % std Pr residual #
    
    if size(Pr_rate{idt,1},2)~=0
        Refined_data {idt,12} = mean (abs(GNSS_data{idt,9}(:,7)));   % mean Pr rate consistency #
        Refined_data {idt,13} = std(abs(GNSS_data{idt,9}(:,7)));       %std Pr rate consistency #
    else
        Refined_data {idt,12} = 0;
        Refined_data {idt,13} = 0;
    end
end

%% Further Process 1 (delete the invalid values in feature matrix)
idt2Delete = [];
for idt = 1: size(GNSS_data,1)  %number of epoches
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


if whetherToPlot == 1
    %% First Plot 
    figure;
    subplot(3,1,1)
    y0 = Refined_data (:,2);
    plot(y0,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y0)])
    ylabel({'Feature 1:'; 'nSat / total nSat'}) 
%     %%
%     subplot(3,1,2)
%     y1 = cell2mat(Refined_data (:,3));
%     plot(y1,'b')
%     xlim([0 1.2*size(Refined_data,1)])
%     ylim([0 1.2*max(y1)])
%     ylabel('EPV') 
%     %%
%     subplot(3,1,3)
%     y2 = cell2mat(Refined_data (:,4));
%     plot(y2,'b')
%     xlim([0 1.2*size(Refined_data,1)])
%     ylim([0 1.2*max(y2)])
%     ylabel('EPH') 

%     figure; 
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


