function restingPreprocNumbers( cfgin )
  %The current code is copied as a first step from lissajous_preproc.m
  %This script removes muscle artifacts and jumps from the MEG data and saves
  %the remainder, as well as all of the timestamps of all artifacts.

  try
    %Folder with the resting data
    rawpath = '/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/raw/';
    cd(rawpath)

    %The key here is to use the already defined tables for samples when calling
    %trialfun function which I should define next.

    %define ds file, this is actually from the trial-based data
    %So the ending of P2 does not exist and needs to be P3...
    if cfgin.restingfile(7)=='2'
      cfgin.restingfile(7) ='3';
    end

    dsfile =sprintf('%s%s_S%s_P%s.mat',rawpath,cfgin.restingfile(2:3),cfgin.restingfile(5),cfgin.restingfile(7));
    dat = load(dsfile);
    data = dat.combined_dat;
    clear dat
    %%
    %From Anne, Donner git example
    %Skipping head motion calculation...

    %It appears sampleinfo no longer is there in the data struct...
    %sampleinfo = data.sampleinfo;

    % plot a quick power spectrum
    % save those cfgs for later plotting
    cfgfreq             = [];
    cfgfreq.method      = 'mtmfft';
    cfgfreq.output      = 'pow';
    cfgfreq.taper       = 'hanning';
    cfgfreq.channel     = 'MEG';
    cfgfreq.foi         = 1:130;
    cfgfreq.keeptrials  = 'no';
    freq                = ft_freqanalysis(cfgfreq, data); %Should only be done on MEG channels.

    %plot those data and save for visual inspection
    figure('vis','off'),clf
    cnt                   = 1;
    subplot(2,3,cnt); cnt = cnt + 1;

    loglog(freq.freq, freq.powspctrm, 'linewidth', 0.1); hold on;
    loglog(freq.freq, mean(freq.powspctrm), 'k', 'linewidth', 1);
    axis tight; axis square; box off;
    set(gca, 'xtick', [10 50 100], 'tickdir', 'out', 'xticklabel', []);

    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed')

    %%


    % compute head rotation wrt first trial
    cc_rel = computeHeadRotation(data);
    % plot the rotation of the head
    subplot(2,3,cnt); cnt = cnt + 1;
    plot(cc_rel); ylabel('HeadM');
    axis tight; box off;

    %%
    % ==================================================================
    % 2. REMOVE TRIALS WITH EYEBLINKS (only during beginning of trial)
    % Bandpass filter the vertical EOG channel between 1-15 Hz and z-transform
    % this filtered time course. Select complete trials that exceed a threshold of
    % z =4 (alternatively you can set the z-threshold per data file or per subject
    % with the ?interactive? mode in ft_artifact_zvalue function). Reject trials
    % that contain blink artifacts before going on to the next step. For monitoring
    % purposes, plot the time courses of your trials before and after blink rejection.
    % ==================================================================

    cfg                              = [];
    cfg.continuous                   = 'yes'; % data has been epoched

    % channel selection, cutoff and padding
    %The channel '4' is the appended eyelink.
    cfg.artfctdef.zvalue.channel     = {'4'}; %UADC004 UADC003

    % 001, 006, 0012 and 0018 are the vertical and horizontal eog chans
    cfg.artfctdef.zvalue.trlpadding  = 0; % avoid filter edge artefacts by setting to negative
    cfg.artfctdef.zvalue.fltpadding  = 0;
    cfg.artfctdef.zvalue.artpadding  = 0.05; % go a bit to the sides of blinks

    % algorithmic parameters
    cfg.artfctdef.zvalue.bpfilter   = 'no';
    % cfg.artfctdef.zvalue.bpfilttype = 'but';
    % cfg.artfctdef.zvalue.bpfreq     = [1 15];
    % cfg.artfctdef.zvalue.bpfiltord  = 2;
    % cfg.artfctdef.zvalue.hilbert    = 'yes';

    % set cutoff
    cfg.artfctdef.zvalue.cutoff     = 4; % to detect all blinks, be strict
    cfg.artfctdef.zvalue.interactive = 'no';
    [~, artifact_eog]               = ft_artifact_zvalue(cfg, data);
    artifact_eogVertical = artifact_eog;



    cfg                             = [];
    cfg.artfctdef.reject            = 'partial';
    cfg.artfctdef.eog.artifact      = artifact_eogVertical;

    %plot the blink rate vertical??
    cfg=[];
    cfg.channel = '4'; % UADC004 if eyelink is present
    blinks = ft_selectdata(cfg,data);



    %If there is no variance in the data then it is probably because the
    %eyelink was not working for that session.
    if var(blinks.trial{:})<0.01 %No eyelink
      %raise error
      msg='There is no Eylink data';
      error(msg);
    end
    subplot(2,3,cnt); cnt = cnt + 1;
    plot(blinks.trial{:})
    axis tight; axis square; box off;
    title('Blink rate 4')
    % reject blinks only when they occur between fix and stim offset
    %crittoilim = [ data.trialinfo(:,2) - data.trialinfo(:,1) - 0.4*data.fsample ...
    %    data.trialinfo(:,5) - data.trialinfo(:,1) + 0.8*data.fsample]  / data.fsample;
    %cfg.artfctdef.crittoilim        = crittoilim;
    %data                            = ft_rejectartifact(cfg, data);
    %%
    % ==================================================================
    % 3. REMOVE TRIALS WITH SACCADES (only during beginning of trial)
    % Remove trials with (horizontal) saccades (EOGH). Use the same settings as
    % for the EOGV-based blinks detection. The z-threshold can be set a bit higher
    % (z = [4 6]). Reject all trials that contain saccades before going further.
    % ==================================================================

    cfg                              = [];
    cfg.continuous                   = 'yes'; % data has been epoched

    % channel selection, cutoff and padding
    cfg.artfctdef.zvalue.channel     = {'3'}; %UADC003 UADC004s

    % 001, 006, 0012 and 0018 are the vertical and horizontal eog chans
    cfg.artfctdef.zvalue.trlpadding  = 0; % padding doesnt work for data thats already on disk
    cfg.artfctdef.zvalue.fltpadding  = 0; % 0.2; this crashes the artifact func!
    cfg.artfctdef.zvalue.artpadding  = 0.05; % go a bit to the sides of blinks

    % algorithmic parameters
    cfg.artfctdef.zvalue.bpfilter   = 'no';
    % cfg.artfctdef.zvalue.bpfilttype = 'but';
    % cfg.artfctdef.zvalue.bpfreq     = [1 15];
    % cfg.artfctdef.zvalue.bpfiltord  = 2;
    % cfg.artfctdef.zvalue.hilbert    = 'yes';

    % set cutoff
    cfg.artfctdef.zvalue.cutoff     = 4;
    cfg.artfctdef.zvalue.interactive = 'no';
    [~, artifact_eog]               = ft_artifact_zvalue(cfg, data);

    artifact_eogHorizontal = artifact_eog;

    cfg                             = [];
    cfg.artfctdef.reject            = 'partial';
    cfg.artfctdef.eog.artifact      = artifact_eogHorizontal;

    % reject blinks when they occur between ref and the offset of the stim
    %crittoilim = [data.trialinfo(:,2) - data.trialinfo(:,1) - 0.4*data.fsample ...
    %    data.trialinfo(:,5) - data.trialinfo(:,1) + 0.8*data.fsample] / data.fsample;
    %cfg.artfctdef.crittoilim        = crittoilim;
    %data                            = ft_rejectartifact(cfg, data);

    %plot the blink rate horizontal??
    cfg=[];
    cfg.channel = '3'; %UADC003 UADC004 if eyelink is present
    blinks = ft_selectdata(cfg,data);

    %If there is no variance in the data then it is probably because the
    %eyelink was not working for that session
    % if var(blinks.trial{:})<0.01 %No eyelink
    % 	cfg=[];
    %     cfg.channel = 'EEG057';
    %     blinks = ft_selectdata(cfg,data);
    % end
    subplot(2,3,cnt); cnt = cnt + 1;
    plot(blinks.trial{:})
    axis tight; axis square; box off;
    title('Blink rate 3')

    %%
    % ==================================================================
    % 4. REMOVE TRIALS WITH JUMPS
    % Compute the power spectrum of all trials and a linear line on the loglog-
    % transformed power spectrum. Jumps cause broad range increase in the power
    % spectrum so trials containing jumps can be selected by detecting outliers
    % in the intercepts of the fitted lines (using Grubb?s test for outliers).
    % ==================================================================

    %call function which calculates all jumps
    idx_jump=findSquidJumps(data,cfgin);
    artifact_Jump = idx_jump;
    % subplot(2,3,cnt); cnt = cnt + 1;
    %If there are jumps
    % if ~isempty(idx_jump)

      % for iout = 1:length(idx_jump)

        %I belive that y is trial and x is channel.
        % [y,x] = ind2sub(size(intercept),idx_jump(iout)) ;

        %Store the name of the channel
        % channelJump{iout} = freq.label(x);

        %Plot each channel containing a jump.
        % plot(data.trial{1}( ismember(data.label,channelJump{iout}),:))
        % hold on

      % end
      % axis tight; axis square; box off;
      %set(gca, 'xtick', [10 50 100], 'tickdir', 'out', 'xticklabel', []);
      % title(sprintf('Jumps found'));
    % else
      % title(sprintf('No jumps'));
    % end
    %%
    % ==================================================================
    % 5. REMOVE LINE NOISE
    % ==================================================================

    cfg             = [];
    cfg.bsfilter    = 'yes';
    cfg.bsfreq      = [49 51; 99 101; 149 151];
    data            = ft_preprocessing(cfg, data);


    % ==================================================================
    % 7. REMOVE TRIALS WITH MUSCLE BURSTS BEFORE RESPONSE
    % Remove muscle using the same z-value-based approach as for the eye
    % channels. Filter the data between 110-140 Hz and use a z-value threshold of 10.
    % ==================================================================

    cfg                              = [];
    cfg.continuous                   = 'yes'; % data has been epoched

    % channel selection, cutoff and padding
    cfg.artfctdef.zvalue.channel     = {'MEG'}; % make sure there are no NaNs
    cfg.artfctdef.zvalue.trlpadding  = 0;
    cfg.artfctdef.zvalue.fltpadding  = 0; % 0.2; - this crashes ft_artifact_zvalue!
    cfg.artfctdef.zvalue.artpadding  = 0.1;
    cfg.artfctdef.zvalue.interactive = 'no';

    % algorithmic parameters
    cfg.artfctdef.zvalue.bpfilter    = 'yes';
    cfg.artfctdef.zvalue.bpfreq      = [110 140];
    cfg.artfctdef.zvalue.bpfiltord   = 9;
    cfg.artfctdef.zvalue.bpfilttype  = 'but';
    cfg.artfctdef.zvalue.hilbert     = 'yes';
    cfg.artfctdef.zvalue.boxcar      = 0.2;

    % set cutoff
    cfg.artfctdef.zvalue.cutoff      = 30;
    [~, artifact_Muscle]             = ft_artifact_zvalue(cfg, data);

    cfg                              = [];
    cfg.artfctdef.reject             = 'partial';
    cfg.artfctdef.muscle.artifact    = artifact_Muscle;

    %
    % % plot final power spectrum
    freq            = ft_freqanalysis(cfgfreq, data);
    subplot(2,3,cnt);
    %loglog(freq.freq, freq.powspctrm, 'linewidth', 0.5); hold on;
    loglog(freq.freq, squeeze(mean(freq.powspctrm)), 'k', 'linewidth', 1);
    axis tight; axis square; box off; %ylim(ylims);
    set(gca, 'xtick', [10 50 100], 'tickdir', 'out');

    %%

    %Run a function which removes the artifacts we want. So far only muscle,
    %also needs to include jumps

    %Make sampleinfo 0 because then artifacts are no longer added by the
    %sampleinfo from before
    %sampleinfo=sampleinfo-sampleinfo;
    sampleinfo = data.sampleinfo
    [ data ] = delete_artifact_Numbers(artifact_Muscle, data, sampleinfo);


    %%
    %Finally resample the data
    cfg3.resample = 'yes';
    cfg3.fsample = 1200;
    cfg3.resamplefs = 500;
    cfg3.detrend = 'no';

    data = ft_resampledata(cfg3,data);


    %%
    %Do a highpass filter go get rid of all frequencies below 2Hz
    cfg          = [];
    cfg.hpfilter = 'yes';
    cfg.hpfreq   = 2;
    data = ft_preprocessing(cfg,data);

    %%
    %Change folder and save approapriate data + figures
    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/')

    name = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P%s',cfgin.restingfile(2:3));

    if 7==exist(name,'dir')

      cd(name)
    else
      mkdir(name)
      cd(name)
    end

    %the problem is that some of the artifacts are based on the sampleinfo and
    %some are not.
    data.sampleinfoOld = sampleinfo;
    %Save the data
    filestore=sprintf('preproc%s.mat',dsfile(end-8:end-4));
    save(filestore,'data')

    %Save the artifacts
    artstore=sprintf('artifacts%s.mat',dsfile(end-8:end-4));

    save(artstore,'artifact_eogVertical','artifact_eogHorizontal','artifact_Muscle','artifact_Jump') %Jumpos?

    %save the invisible figure
    figurestore=sprintf('Overview%s.png',dsfile(end-8:end-4));
    saveas(gca,figurestore,'png')

    %Catch any error and write into file
  catch err

    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed')
    fid=fopen('logfile','a+');
    c=clock;
    fprintf(fid,sprintf('\n\n\n\nNew entry for %s at %i/%i/%i %i:%i\n\n\n\n',cfgin.restingfile,fix(c(1)),fix(c(2)),fix(c(3)),fix(c(4)),fix(c(5))))

    fprintf(fid,'%s',err.getReport('extended','hyperlinks','off'))

    fclose(fid)


  end

  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting')
end
