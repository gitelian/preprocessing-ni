

%SortSpikes
%   SortSpikes takes four arguments: data_directory, data_filename, Fs, and
%   channels. Data_directory is a string that contains the path to the
%   directory containing the MCdata file to be analyzed by
%   UltraMegaSort. Data_filename is a string that contains the MCdata file
%   name. Fs is the sampling rate of the recorded session and channels is a
%   vector that contains the channel numbers to be grouped and sorted.

% G.Telian
% Adesnik Lab
% UC Berkeley
% 20140123

function sort_spikes(data_filename, channels, varargin)

if nargin == 1
    error('Not enough input arguments')

elseif nargin == 2
    data_dir = '~/Documents/AdesnikLab/Data';
    Fs = 30000;

elseif nargin == 3
    data_dir = varargin{1};
    Fs = 30000;

    if exist(data_dir,'dir') == 0
        error('Directory does not exist')
    end
elseif nargin == 4

    data_dir = varargin{1};
    Fs = varargin{2};

    if exist(data_dir,'dir') == 0
        error('Directory does not exist')
    end
end

if exist([data_dir filesep data_filename],'file') == 0
    disp([data_dir filesep data_filename])
    error('File does not exist')
end

if ischar(Fs)
    Fs = str2double(Fs);
end

if ischar(channels)
    channels = str2double(channels);
end

if length(channels) < 2
    error('channels must contain at least 2 values')
elseif length(channels) > 4
    error('channels must not contain more than 4 values')
end

if ~exist(data_dir,'dir')
    error('directory does not exist')
elseif ~exist([data_dir filesep data_filename],'file')
    error('MCdata file does not exist')
end

disp('loading MCdata file')
load([data_dir filesep data_filename],'MCdata','-mat')

disp('filtering data')
%construct parameters for filter
Wp = [ 800  8000] * 2 / Fs;
Ws = [ 600 10000] * 2 / Fs;
[N,Wn] = buttord( Wp, Ws, 3, 20);
[B,A] = butter(N,Wn);

MCdata2 = [];

%filter raw MCdata into MCdata2 variable
for j = 1:length(MCdata)
   MCdata2{j}(:,1) = filtfilt( B, A, MCdata{j}(:,channels(1)));
   MCdata2{j}(:,2) = filtfilt( B, A, MCdata{j}(:,channels(2)));
   if length(channels) > 2
       MCdata2{j}(:,3) = filtfilt( B, A, MCdata{j}(:,channels(3)));
   end
   if length(channels) > 3
       MCdata2{j}(:,4) = filtfilt( B, A, MCdata{j}(:,channels(4)));
   end
end

disp('preparing UltraMegaSort2000!')
% run algorithm
spikes = ss_default_params(Fs);
spikes = ss_detect(MCdata2,spikes);
spikes = ss_align(spikes);
spikes = ss_kmeans(spikes);
spikes = ss_energy(spikes);
spikes = ss_aggregate(spikes);

% main tool
splitmerge_tool(spikes)













