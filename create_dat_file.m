



function create_dat_file(mcdata_file, varargin)

if nargin == 1
    mcdata_dir = '~/Documents/AdesnikLab/Data';
elseif nargin == 2
    mcdata_dir = varargin{1};
    if exist(mcdata_dir,'dir') == 0
        error('Directory does not exist')
    end 
end
disp([mcdata_dir filesep mcdata_file])
if exist([mcdata_dir filesep mcdata_file],'file') == 0
    error('File does not exist')
end

tic()

disp('loading MCdata file')
load([mcdata_dir filesep mcdata_file],'-mat')

mcdata_temp = cell(size(MCdata));

%% Save Running File
run_data = zeros(length(MCdata{1,1}(:,end)),length(MCdata));
disp('making running file')
for k = 1:length(MCdata);
    run_data(:,k) = MCdata{1,k}(:,end);
end
save([mcdata_dir filesep mcdata_file(1:end-4) '.dat'],'run_data','time','aoFinal','stimsequence','ao_latency','ao_interval',...
    'ao_duration','ao_amplitude','ao_quantity','optosquare','optoramp','-v7.3');
