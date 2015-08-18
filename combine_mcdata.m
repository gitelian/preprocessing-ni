
%%COMBINE_MCDATA.M combines MCdata .phy files.
% Can only combine two whisker trimming files and CORRECTLY change the stim
% indices for the second file.
%
% Can combine any number of non-whisker trimming MCdata files.
%
% example: combine_mcdata(0) (this is for NO whisker trimming

function combine_mcdata(whisker_trim)

disp('Only 2 files can be combined for a WHISKER TRIMMING EXPERIMENT!!!')

if nargin > 1
    error('Whisker Trimming Argument Not Specified!!!')
end

[file_names, path_name] = uigetfile(...
                                    {'*.phy', 'Phys Files';...
                                    '*.*', 'All Files (*.*)'},...
                                    'Select .phy files to combine',...
                                    'MultiSelect', 'on',...
                                    '/media/greg/Data/Neuro/');

num_files = length(file_names);

fname_head = [];

for k = 1:num_files

    if k == 1
        current_file = [path_name file_names{k}];
        disp(['loading: ' current_file])
        x = load(current_file, '-mat'); % memory explodes on second load have no idea why
        trial_length = length(x.MCdata{1,1}(:,1));
        disp('Done loading')
        fname_head = [fname_head,file_names{k}(1:4)];
    elseif k > 1
        current_file = [path_name file_names{k}];
        disp(['loading: ' current_file])
        y = load(current_file, '-mat'); % memory explodes on second load have no idea why
        disp('Done loading')
        %fname_head = dir_strct.name(1:4);
        fname_head = [fname_head '-' file_names{k}(1:4)];
       if trial_length ~= length(x.MCdata{1,1}(:,1));
           warning('Trial lengths are not the same length')
       end

       x.MCdata = [x.MCdata,y.MCdata];
       if whisker_trim == 0
           x.stimsequence = [x.stimsequence,y.stimsequence];
       elseif whisker_trim == 1
           disp('changing stimsequence for whisker trimming')
           x.stimsequence = [x.stimsequence,y.stimsequence+(length(unique(y.stimsequence)))];
       end

    end
end

disp(['Saving: ' fname_head file_names{k}(5:end)])
save([path_name filesep fname_head file_names{k}(5:end)],'-struct','x','-v7.3')



