%CREATE_DAT_FILE creates a .dat file that contains a matrix with running
%    encoder values, stimulus sequence info, and other basic values saved in
%    the MCdata .phy file with the exception of the actual neural data. This
%    information will be used by the whisker tracking software for identifying
%    running trials and the stimulus presented during those trials.
%
%    Syntax: create_dat_file('path/to/directory', 'data file name')

function create_dat_file(mcdata_dir, mcdata_file)

    if exist(mcdata_dir,'dir') == 0
        error('Directory does not exist')
    end

    if exist([mcdata_dir filesep mcdata_file],'file') == 0
        error('File does not exist')
    end

    disp('loading MCdata file')
    load([mcdata_dir filesep mcdata_file],'-mat')

    %% Save Running File
    run_data = zeros(length(MCdata{1,1}(:,end)),length(MCdata));
    disp('making running file')
    for k = 1:length(MCdata);
        run_data(:,k) = MCdata{1,k}(:,end);
    end

    save([mcdata_dir filesep mcdata_file(1:end-4) '.dat'],'run_data','time',...
        'aoFinal','stimsequence','ao_latency','ao_interval','ao_duration',...
        'ao_amplitude','ao_quantity','optosquare','optoramp','-v7.3');

    disp(['Saved: ' mcdata_dir filesep mcdata_file(1:end-4) '.dat'])

end
