function results = AdaptiveR (GnssT, floatClass, fixed_uct, receiver)

% RM_value = 21.275*floatClass(epoch) - 29.7; % need to add the "float class list" for each dataset
                                  % adjust a,b
%                        21.275*floatClass(epoch)-29.7    TST  
%                        11.65*floatClass(epoch) - 12.221  WP
% if size(floatClass,1) ==1
% %     results = floatClass./35;
%     results = floatClass(1,1);
% else 
%     this_epo_id = epoch - 1;
%     results = floatClass(this_epo_id, 1);
%     results = floatClass(this_epo_id, 1) + 35; % klb ublox akf (10/15/20/25/30/35/40; 25ok)
%     results = floatClass(this_epo_id, 1) + 60; % klb xiaomi akf (40 okay)
%     results = floatClass(this_epo_id, 1) + 15; % klb novatel akf

% results starting from 04.11 afternoon...
%     results = floatClass(this_epo_id, 1) + 12; % klb novatel akf (5/8/10/15/20 not good)
%     results = floatClass(this_epo_id, 1) + 45; % klb ublox akf (35/40 not okay; )
%     results = floatClass(this_epo_id, 1) + 55; % klb xiaomi akf (45 confirmed very good)


%     first_GnssT = GNSS_Data(1,1);
%     this_GnssT = cell2mat(first_GnssT) + GNSS_epoch - 1;
    this_uct = floatClass(find(floatClass(:,1)==GnssT), 3);


    % has ml results %
    if ~isempty(this_uct)
%         results = this_uct + 45; % klb xiaomi akf (45 confirmed very good)
        results = this_uct * 10 + fixed_uct - 10/2; % klb ublox akf (35)

    % no ml results; has gnss solution %
%     elseif lack_gnss_data == 0
%         results = fixed_uct;
%     % no ml results; no gnss solution %
%     elseif lack_gnss_data == 1
    else
        if receiver == "novatel"
        % 100 is relatively very large %
            results = 0.5e2; % for novatel data only
        elseif receiver == "xiaomi"
            results = 1.3e2; % for novatel data only
        elseif receiver == "ublox"
            results = 1e2; % for novatel data only
        end
    end




    % % === Linear regression model(RM) ===
%     RM_value = (14.957*floatClass(epoch) - 16.787)/15; % wp ublox FGO
%     RM_value = (14.957*floatClass(epoch) - 16.787); % wp ublox KF
    % RM_value = (5.0606*floatClass(epoch) - 4.9184)/15; % wp novatel FGO
    % RM_value = 5.0606*floatClass(epoch) - 4.9184; % wp novatel KF
    % RM_value = (44.058*floatClass(epoch) - 49.27)/15; % wp xiaomi FGO
    % RM_value = 44.058*floatClass(epoch) - 49.27; % wp xiaomi KF

    % % === Power regression model(RM) ===
%     RM_value = 1.3832*(floatClass(epoch))^2.892 ; % wp ublox KF
%     RM_value = 1.3832*(floatClass(epoch))^2.892 /15; % wp ublox FGO
%     RM_value = 0.9407*(floatClass(epoch))^2.2703 ; % wp novatel KF
%     RM_value = 0.9407*(floatClass(epoch))^2.2703/15 ; % wp novatel FGO
%     RM_value = 4.393*(floatClass(epoch))^2.8377 ; % wp xiaomi KF
%     RM_value = 4.393*(floatClass(epoch))^2.8377/15 ; % wp xiaomi FGO


%       RM_value = 2.541*(floatClass(epoch))^1.8108 + 10 ; % wp ublox KF (out)
%       RM_value = 2.541*(floatClass(epoch))^1.8108/15 ; % wp ublox FGO (out)
%       RM_value = 1.7142*(floatClass(epoch))^0.9491-1 ; % wp novatel KF (out)
%       RM_value = 1.7142*(floatClass(epoch))^0.9491/15 ; % wp novatel FGO (out)

%       RM_value = 13.321*(floatClass(epoch))^1.1399 + 20  ; % wp smartphone KF (out)
%         RM_value = (13.321*(floatClass(epoch))^1.1399)/12 ; % wp smartphone FGO (out)
%     if RM_value <0
%         results  = 1e-5;
%     else
% %         if RM_value > 20       %@ Set a threshold for large uncertainty
% %             results = 100;
% %         else
%         results = RM_value;
% %         end
%     end
end




