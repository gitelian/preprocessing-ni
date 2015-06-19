
%MAKE_REF_FILE Computes common average reference (CAR) for the specified file.
%   Computes CAR and saves it in a cell array that is the same size as the
%   MCdata cell structure of the specified .phy file.
%   See Ludwig et al. 2009 for details.

function make_ref_file(data_filename, varargin)

data_dir = '~/Documents/AdesnikLab/Data';
[~, base_name, ~] = fileparts(data_filename);

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

ntrials = length(MCdata);
nsamples = size(MCdata{1}, 1);
nchannels = size(MCdata{1}, 2);
mcmat = zeros(ntrials*nsamples, nchannels);

%filter raw MCdata into mcmat variable
for k = 1:ntrials
    start_ind = (k-1)*nsamples + 1;
    stop_ind  = k*nsamples;
    mcmat(start_ind:stop_ind, :) = MCdata{k};
end

clear MCdata

for j = 1:nchannels
    mcmat(:, j) = filtfilt( B, A, mcmat(:, j));
end

% rms of all channels
mcrms = rms(mcmat);

% CAR-n (n channel average)
mcmean = mean(mcmat, 2);

% rms of CAR-n (across all channels)
rms_allchan = rms(mcmean);

% find good channel indices
good_channels = find(mcrms <= 2*rms_allchan & mcrms >= 0.3*rms_allchan);

% compute CAR-n with only good channels
mcmean = mean(mcmat(:, good_channels), 2);

clear mcmat

% make CAR_n cell
CAR_n = cell(1, ntrials);
for k = 1:ntrials
    start_ind = (k-1)*nsamples + 1;
    stop_ind  = k*nsamples;
    CAR_n{1, k} = mcmean(start_ind:stop_ind);
end

save([data_dir filesep base_name '.ref'], 'CAR_n', '-v7.3')

