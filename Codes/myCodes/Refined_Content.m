for idt = 1: size(GNSS_data,1)  %number of epoches
    Refined_data {idt,1} = GNSS_data{idt,1};   %index of epoch
    Refined_data {idt,3} = length(GNSS_data{idt,3});  % SV  % need "length()" to plot
    Refined_data {idt,5} = sqrt(GNSS_data{idt,16}(1)^2  + GNSS_data{idt,16}(2)^2); %EPH
    Refined_data {idt,2} = sqrt(GNSS_data{idt,16}(1)^2  + GNSS_data{idt,16}(2)^2 +GNSS_data{idt,16}(3)^2);
end





%%
subplot(5,1,1)
y0 = cell2mat(Refined_data (:,2));
plot(y0,'b')
xlim([0 1.2*size(GNSS_data,1)])
ylim([0 1.2*max(y0)])
ylabel('Error(m)') 
%%
subplot(5,1,2)
y1 = cell2mat(Refined_data (:,3));
plot(y1,'b')
xlim([0 1.2*size(GNSS_data,1)])
ylim([0 1.2*max(y1)])
ylabel('nSat') 
%%
subplot(5,1,5)
y2 = cell2mat(Refined_data (:,5));
plot(y2,'b')
xlim([0 1.2*size(GNSS_data,1)])
ylim([0 1.2*max(y2)])
ylabel('EPH') 
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