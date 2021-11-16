clear Refined_data

for idt = 1: size(GNSS_data,1)  %number of epoches
    Refined_data {idt,1} = GNSS_data{idt,1};   %index of epoch##
    Refined_data {idt,2} = length(GNSS_data{idt,3});  % number of SV ##
    Refined_data {idt,3} = GNSS_data{idt,16}(3)^2; % EPV
    Refined_data {idt,4} = sqrt(GNSS_data{idt,16}(1)^2  +...
                                                    GNSS_data{idt,16}(2)^2); %EPH

    Refined_data {idt,5} = mean(GNSS_data{idt,4}); % mean elevation angle
    Refined_data {idt,6} = var(GNSS_data{idt,4}); % variance elevation angle
    
    Refined_data {idt,7} = mean(GNSS_data{idt,9}(:,4),'all'); % C/N0end
    
    Refined_data {idt,8} = mean(GNSS_data{idt,9}(:,9),'all'); % Pr residual RSS_e
    Refined_data {idt,9} = mean(GNSS_data{idt,9}(:,6),'all'); % mean Pr residual
    Refined_data {idt,10} = var(GNSS_data{idt,9}(:,6)); % variance Pr residual
    
    if size(Pr_rate{idt,1},2)~=0
        Refined_data {idt,11} = mean (Pr_rate{idt,1}(:,3));   % mean Pr rate consistency
        Refined_data {idt,12} = var(Pr_rate{idt,1}(:,3));       %variance Pr rate consistency
    else
        Refined_data {idt,11} = 0;
        Refined_data {idt,12} = 0;
    end
end

%% Further Process
idt2Delete = [];
for idt = 1: size(GNSS_data,1)  %number of epoches
    if (size(Refined_data {idt,3},1)==0) ||(size(Refined_data {idt,4},1)==0)|| ...
        (Refined_data {idt,11} ==0) || (Refined_data {idt,11} ==9999)||....
        (Refined_data {idt,12} ==0)
        idt2Delete = [idt2Delete,idt];
    end

end
Refined_data(idt2Delete,:)=[]; % To delete the invalid sample data


%% First Plot 
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




% subplot(5,1,2)

% subplot(5,1,3)
% 
% subplot(5,1,4)

% subplot(5,1,5)


%                     GNSS_data{idt,14}(idm,2),...%Pr_Error
%                     GNSS_data{idt,16}(1),...%Error_east
%                     GNSS_data{idt,16}(2),...%Error_north
%                     GNSS_data{idt,16}(3),...%Error_up

% GNSS_data{idt,3}(idm),...%PRN