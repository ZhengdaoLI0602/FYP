clearvars
%% ===> Training data <===
%% Novatel train
novatel = [];
% load(['.\LocalCopy\Refined_Content_','MK_novatel.mat']);
% novatel = [novatel; Refined_data_normalized(:, 2:13)];
load(['.\LocalCopy\Refined_Content_','TST_novatel.mat']);
novatel = [novatel; Refined_data_normalized(:, 2:13)];
load(['.\LocalCopy\Refined_Content_','WP_novatel.mat']);
novatel = [novatel; Refined_data_normalized(:, 2:13)];
fid_out = fopen(['csvFiles for ML\','novatel.csv'],'w+');
if fid_out < 0
    errordlg('File creation failed','Error');
end
fprintf(fid_out,'Err2D,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10\n');   
for i=1:size(novatel,1)
    fprintf(fid_out,'%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n',novatel(i,1), ...
        novatel(i,3),novatel(i,4),novatel(i,5),novatel(i,6),novatel(i,7),...
        novatel(i,8),novatel(i,9),novatel(i,10),novatel(i,11),novatel(i,12)); %%
end
fclose(fid_out);

%% Ublox train
ublox = [];
% load(['.\LocalCopy\Refined_Content_','MK_ublox.mat']);
% ublox = [ublox; Refined_data_normalized(:, 2:13)];
load(['.\LocalCopy\Refined_Content_','TST_ublox.mat']);
ublox = [ublox; Refined_data_normalized(:, 2:13)];
load(['.\LocalCopy\Refined_Content_','WP_ublox.mat']);
ublox = [ublox; Refined_data_normalized(:, 2:13)];

fid_out = fopen(['csvFiles for ML\','ublox.csv'],'w+');
if fid_out<0
    errordlg('File creation failed','Error');
end
fprintf(fid_out,'Err2D,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10\n');   
for i=1:size(ublox,1)
    fprintf(fid_out,'%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n',ublox(i,1), ...
        ublox(i,3),ublox(i,4),ublox(i,5),ublox(i,6),ublox(i,7),...
        ublox(i,8),ublox(i,9),ublox(i,10),ublox(i,11),ublox(i,12)); %%
end
fclose(fid_out);

% create_csv(ublox);
% varInfo = whos('ublox').name;


%% Xiaomi train
xiaomi = [];
% load(['.\LocalCopy\Refined_Content_','MK_xiaomi.mat']);
% xiaomi = [xiaomi; Refined_data_normalized(:, 2:13)];
load(['.\LocalCopy\Refined_Content_','TST_xiaomi.mat']);
xiaomi = [xiaomi; Refined_data_normalized(:, 2:13)];
load(['.\LocalCopy\Refined_Content_','WP_xiaomi.mat']);
xiaomi = [xiaomi; Refined_data_normalized(:, 2:13)];
fid_out = fopen(['csvFiles for ML\','xiaomi.csv'],'w+');
if fid_out<0
    errordlg('File creation failed','Error');
end
fprintf(fid_out,'Err2D,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10\n');   
for i=1:size(xiaomi,1)
    fprintf(fid_out,'%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n',xiaomi(i,1), ...
        xiaomi(i,3),xiaomi(i,4),xiaomi(i,5),xiaomi(i,6),xiaomi(i,7),...
        xiaomi(i,8),xiaomi(i,9),xiaomi(i,10),xiaomi(i,11),xiaomi(i,12)); %%
end
fclose(fid_out);
disp('===> Training data Combination finished <===');



%% ===> Testing data <===
clearvars

%% novatel test
novatel = [];
load(['.\LocalCopy\Refined_Content_','KLB_novatel.mat']);
novatel = [novatel; Refined_data_normalized(:, 2:13)];
fid_out = fopen(['csvFiles for ML\','novatel_test.csv'],'w+');
if fid_out<0
    errordlg('File creation failed','Error');
end
fprintf(fid_out,'Err2D,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10\n');   
for i=1:size(novatel,1)
    fprintf(fid_out,'%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n',novatel(i,1), ...
        novatel(i,3),novatel(i,4),novatel(i,5),novatel(i,6),novatel(i,7),...
        novatel(i,8),novatel(i,9),novatel(i,10),novatel(i,11),novatel(i,12)); %%
end
fclose(fid_out);

%% ublox test
ublox = [];
load(['.\LocalCopy\Refined_Content_','KLB_ublox.mat']);
ublox = [ublox; Refined_data_normalized(:, 2:13)];
fid_out = fopen(['csvFiles for ML\','ublox_test.csv'],'w+');
if fid_out<0
    errordlg('File creation failed','Error');
end
fprintf(fid_out,'Err2D,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10\n');   
for i=1:size(ublox,1)
    fprintf(fid_out,'%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n',ublox(i,1), ...
        ublox(i,3),ublox(i,4),ublox(i,5),ublox(i,6),ublox(i,7),...
        ublox(i,8),ublox(i,9),ublox(i,10),ublox(i,11),ublox(i,12)); %%
end
fclose(fid_out);


%% xiaomi test
xiaomi = [];
load(['.\LocalCopy\Refined_Content_','KLB_xiaomi.mat']);
xiaomi = [xiaomi; Refined_data_normalized(:, 2:13)];
fid_out = fopen(['csvFiles for ML\','xiaomi_test.csv'],'w+');
if fid_out<0
    errordlg('File creation failed','Error');
end
fprintf(fid_out,'Err2D,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10\n');   
for i=1:size(xiaomi,1)
    fprintf(fid_out,'%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n',xiaomi(i,1), ...
        xiaomi(i,3),xiaomi(i,4),xiaomi(i,5),xiaomi(i,6),xiaomi(i,7),...
        xiaomi(i,8),xiaomi(i,9),xiaomi(i,10),xiaomi(i,11),xiaomi(i,12)); %%
end
fclose(fid_out);


disp('===> Testing data Combination finished <===');

