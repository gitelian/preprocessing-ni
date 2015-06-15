

% example: combine_mcdata({'0980', '0981'}, '/media/greg/data/Neuro/')

function combine_mcdata(fids,varargin)

if nargin > 1
   data_path = varargin{1};
   if exist(data_path,'dir') == 0
       error('path doesn''t exist')
   end
else
    data_path = '~/Documents/AdesnikLab/Data';
end

num_fids = length(fids);

for k = 1:num_fids
    dir_strct = dir([data_path filesep '*' fids{k} '*.phy']);
    if isempty(dir_strct)
        error(['file not found (fid: ' num2str(fids{k}) ')'])
    end
end

fname_head = [];

for k = 1:num_fids
    
    if k == 1
        dir_strct = dir([data_path filesep '*' fids{k} '*.phy']);
        disp(['loading: ' dir_strct.name])
        x = load([data_path filesep dir_strct.name],'-mat'); % memory explodes on second load have no idea why
        trial_length = length(x.MCdata{1,1}(:,1));
        disp('Done loading')
        fname_head = [fname_head,dir_strct.name(1:4)];
    elseif k > 1
        dir_strct = dir([data_path filesep '*' fids{k} '*.phy']);
        disp(['loading: ' dir_strct.name])
        y = load([data_path filesep dir_strct.name],'-mat'); % memory explodes on second load have no idea why
        disp('Done loading')
        %fname_head = dir_strct.name(1:4);        
        fname_head = [fname_head '-' dir_strct.name(1:4)];
       if trial_length ~= length(x.MCdata{1,1}(:,1));
           warning('Trial lengths are not the same length')
       end
       
       x.MCdata = [x.MCdata,y.MCdata];
       x.stimsequence = [x.stimsequence,y.stimsequence];
       
    end   
end

disp(['Saving: ' fname_head dir_strct.name(5:end)])
save([data_path filesep fname_head dir_strct.name(5:end)],'-struct','x','-v7.3')



