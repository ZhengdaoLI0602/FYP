clear Refined_data
%%
% Co-drafted by Zhengdao LI, Pin Hsun LEE
% Updated by Zhengdao LI on 2021.11.17
%%

% Refined_data_FinalV: contains all the feature values
% Refined_data: contains both features and truth values before refinement

whetherToPlot = 0;
%%
for idt = 1: size(GNSS_data,1)  %number of epoches
    Refined_data {idt,1} = GNSS_data{idt,1};   %index of epoch##
    Refined_data {idt,2} = length(GNSS_data{idt,3});  % number of SV ##
    Refined_data {idt,3} = sqrt(GNSS_data{idt,16}(3)^2); % EPV
    Refined_data {idt,4} = sqrt(GNSS_data{idt,16}(1)^2  +...
                                                    GNSS_data{idt,16}(2)^2); %EPH

    Refined_data {idt,5} = mean(GNSS_data{idt,4}); % mean elevation angle
    Refined_data {idt,6} = var(GNSS_data{idt,4}); % variance elevation angle
    
    Refined_data {idt,7} = mean(GNSS_data{idt,9}(:,4)); % mean C/N0
    Refined_data {idt,8} = mean(GNSS_data{idt,9}(:,4)); % var C/N0
    
    Refined_data {idt,9} = mean(GNSS_data{idt,9}(:,9)); % Pr residual RSS_e
    Refined_data {idt,10} = mean(GNSS_data{idt,9}(:,6)); % mean Pr residual
    Refined_data {idt,11} = var(GNSS_data{idt,9}(:,6)); % variance Pr residual
    
    if size(Pr_rate{idt,1},2)~=0
        Refined_data {idt,12} = mean (Pr_rate{idt,1}(:,3));   % mean Pr rate consistency
        Refined_data {idt,13} = var(Pr_rate{idt,1}(:,3));       %variance Pr rate consistency
    else
        Refined_data {idt,12} = 0;
        Refined_data {idt,13} = 0;
    end
end

%% Further Process
idt2Delete = [];
for idt = 1: size(GNSS_data,1)  %number of epoches
    if (size(Refined_data {idt,3},1)==0) ||(size(Refined_data {idt,4},1)==0)|| ...
        (Refined_data {idt,12} ==0) || (Refined_data {idt,12} ==9999)||....
        (Refined_data {idt,13} ==0)
        idt2Delete = [idt2Delete,idt];
    end

end
Refined_data(idt2Delete,:)=[]; % To delete the invalid sample data
%% Final Refinement
Truth_value(:,1) = sqrt(cell2mat(Refined_data (:,3)).^2 + cell2mat(Refined_data (:,4)).^2 ); % truth value for positioing error

Refined_data_FinalV = Refined_data;
Refined_data_FinalV(:,3)=[];
Refined_data_FinalV(:,3)=[];


%% First Plot 
if whetherToPlot == 1
    figure;
    subplot(3,1,1)
    y0 = cell2mat(Refined_data (:,2));
    plot(y0,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y0)])
    ylabel('nSat') 
    %%
    subplot(3,1,2)
    y1 = cell2mat(Refined_data (:,3));
    plot(y1,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y1)])
    ylabel('EPV') 
    %%
    subplot(3,1,3)
    y2 = cell2mat(Refined_data (:,4));
    plot(y2,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y2)])
    ylabel('EPH') 
    %% Second Plot
    figure; 
    subplot(3,1,1)
    y3 = cell2mat(Refined_data (:,5));
    plot(y3,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y3)])
    ylabel('mean Elevation Angle') 
    %%
    subplot(3,1,2)
    y4 = cell2mat(Refined_data (:,6));
    plot(y4,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y4)])
    ylabel('var Elevation Angle') 
    %%
    subplot(3,1,3)
    y5 = cell2mat(Refined_data (:,7));
    plot(y5,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y5)])
    ylabel('C/N0') 
    %% Third Plot
    figure;
    subplot(3,1,1)
    y3 = cell2mat(Refined_data (:,8));
    plot(y3,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y3)])
    ylabel('Pr residual RSS_e') 
    %%
    subplot(3,1,2)
    y4 = cell2mat(Refined_data (:,9));
    plot(y4,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y4)])
    ylabel('mean Pr residual') 
    %%
    subplot(3,1,3)
    y5 = cell2mat(Refined_data (:,10));
    plot(y5,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y5)])
    ylabel('var Pr residual') 
    %% Fourth Plot
    figure;
    subplot(3,1,1)
    y3 = cell2mat(Refined_data (:,11));
    plot(y3,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y3)])
    ylabel('mean consistency checking') 
    %%
    subplot(3,1,2)
    y4 = cell2mat(Refined_data (:,12));
    plot(y4,'b')
    xlim([0 1.2*size(Refined_data,1)])
    ylim([0 1.2*max(y4)])
    ylabel('var consistency checking') 

    %%
    xlabel('Epoch') 
end

