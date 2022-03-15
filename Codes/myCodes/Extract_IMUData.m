clc
clear

load('IMU_TST.mat');
for idt=1:size(imu_data,1)
    if idt == 1
        imu_data(1,2) = imu_data(1,1);
    else
        imu_data(idt,2) = imu_data(idt,1)-imu_data(idt-1,1);
    end
end
imu_data(:,9:12)=[];
writematrix(imu_data);

clc
clear

load('TST_ublox');
% ls_xyz = [RMFV(:,2) ls_xyz]
for idt=1:size(ls_xyz,1)
    ls_enu(idt,:) = xyz2enu(ls_xyz(idt,:),ls_xyz(1,:));
end
ls_enu = [RMFV(:,2) ls_enu]
writematrix(ls_enu);