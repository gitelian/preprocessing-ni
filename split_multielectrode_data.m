%SPLIT_MULTIELECTRODE_DATA Takes MCdata file created from a 32 channel 2x16
%   channel electrode experiment and creates two .phy files where the first
%   file 'e1' contains data from channels 1-16 (or electrode 1) File 'e2' is
%   organized in the same way with data from channels 17-32 (or electrode 2).
%   This will allow the user to properly sort spikes from different recording
%   sites.
%
% G.Telian
% Adesnik Lab
% UC Berkeley
% 20140121


function split_multielectrode_data()

disp('ONLY A FILE FROM 2 16 CHANNEL RECORDINGS CAN BE SPLIT!!!')
[file_name, path_name] = uigetfile(...
                                    '*.phy',...
                                    'Select .phy file to split',...
                                    '/media/greg/Data/Neuro/');

tic()

disp('loading MCdata file')
load([path_name file_name],'-mat')

disp(['MCdata size:' num2str(size(MCdata,1)) ' by ' num2str(size(MCdata),2)]);
disp(['MCdata trial size:' num2str(size(MCdata{1},1)) ' by ' num2str(size(MCdata{1},2))]);
mcdata_temp = cell(size(MCdata));

disp('checking size of MCdata file')
if size(MCdata{1},2) ~= 33
    error('Original MCdata file is not the expected size')
end

%% Save Running File
run_data = zeros(length(MCdata{1,1}(:,end)),length(MCdata));
disp('making running file')
for k = 1:length(MCdata);
    run_data(:,k) = MCdata{1,k}(:,end);
end

save([path_name file_name(1:end-4) '.dat'],'run_data','time',...
    'aoFinal','stimsequence','ao_latency','ao_interval','ao_duration',...
    'ao_amplitude','ao_quantity','optosquare','optoramp','-v7.3');

%% Save First 16 Channels to e1.phy file
disp('adding first 16 channels to temp cell')
for k = 1:length(MCdata);
    mcdata_temp{1,k} = MCdata{1,k}(:,1:16);
end

disp('clearing MCdata variables and saving electrode 1 file')
clear MCdata
MCdata = mcdata_temp;
clear mcdata_temp;

save([path_name file_name(1:end-4) '_e1.phy'],'MCdata','time',...
    'aoFinal','stimsequence','ao_latency','ao_interval','ao_duration',...
    'ao_amplitude','ao_quantity','optosquare','optoramp','-v7.3');
save([tempdir filesep 'temp_usr.mat'],'file_name','path_name','-v7.3');

disp('clearing memory')
clear all

disp(' ')

%% Save Last 16 Channels to e2.phy file
disp('loading MCdata file')
load([tempdir filesep 'temp_usr.mat'])
load([path_name file_name ],'-mat')

mcdata_temp = cell(size(MCdata));

disp('adding last 16 channels to temp cell')
for k = 1:length(MCdata);
    mcdata_temp{1,k} = MCdata{1,k}(:,17:end-1);
end

disp('clearing MCdata variables and saving electrode 2 file')
clear MCdata
MCdata = mcdata_temp;
clear mcdata_temp

save([path_name filesep file_name(1:end-4) '_e2.phy'],'MCdata','time',...
    'aoFinal','stimsequence','ao_latency','ao_interval','ao_duration',...
    'ao_amplitude','ao_quantity','optosquare','optoramp','-v7.3');

disp('clearing memory')
clear all

delete([tempdir filesep 'temp_usr.mat'])

toc()
