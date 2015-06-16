

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

function sort_spikes(data_filename, varargin)

data_dir = '~/Documents/AdesnikLab/Data';

% Set sampling rate
if nargin == 1
    Fs = 30000;
elseif nargin == 2
    Fs = varargin{1};
end

if ischar(Fs)
    Fs = str2double(Fs);
end

% Verify directory and MCdata (.phy) file exists
if ~exist(data_dir,'dir')
    error('directory does not exist')
elseif ~exist([data_dir filesep data_filename],'file')
    error('MCdata file does not exist')
end

% Load MCdata file
disp('loading MCdata file')
load([data_dir filesep data_filename],'MCdata','-mat')

% Construct parameters for filter
disp('filtering data')
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













