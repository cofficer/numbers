function taskPreprocNumbers( cfgin )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %The current code is copied from restingPreprocNumbers
  %Needs to output 1 continuous trial, from 3 trial input.
  %TODO: remove all eyelink-related analysis, and replace w/ eog.
  %Only remove jumps and muscle.
  %2017-10-29 created.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  try
    %Folder with the resting data
    rawpath = '/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/raw/';
    cd(rawpath)

    %The key here is to use the already defined tables for samples when calling
    %trialfun function which I should define next.

    %define ds file, this is actually from the trial-based data
    %So the ending of P2 does not exist and needs to be P3...
    % if cfgin.restingfile(7)=='2'
    %   cfgin.restingfile(7) ='3';
    % endp 23_s3_b3

    dsfile =sprintf('%sp%s_s%s_b%s.mat',rawpath,cfgin.restingfile(2:3),cfgin.restingfile(5),cfgin.restingfile(7));
    load(dsfile);

    % resample the data
    cfg3 = [];
    cfg3.resample = 'yes';
    cfg3.fsample = 1200;
    cfg3.resamplefs = 500;
    cfg3.detrend = 'no';

    data = ft_resampledata(cfg3,data);

    %Fuse the trial seperation. Not sure this is a good approach.
    %First of all it is slower. I would rather split the data in the trials.
    %I could loop over the trl nr. Do some ft_selectdata.
    %Change data.time, so to be unique all the way.
    %TODO: remove unneccessary channels.
    dat_trl = [data.trial{:}];
    data.trial=[];
    data.trial{1}=dat_trl;
    clear dat_trl

    dat_tme = [data.time{:}];
    data.time=[];
    data.time{1}=[0:length(dat_tme)-1]./1200;

    %data.sampleinfo=[data.sampleinfo(1) data.sampleinfo(end)];

    % plot a quick power spectrum
    % save those cfgs for later plotting
    cfgfreq             = [];
    cfgfreq.method      = 'mtmfft';
    cfgfreq.output      = 'pow';
    cfgfreq.taper       = 'hanning';
    cfgfreq.channel     = 'MEG';
    cfgfreq.foi         = 1:130;
    cfgfreq.keeptrials  = 'no';
    %Requires a tonne of memory, 16gb needed.
    %But this analysis is imortant, for quality checking jumps.
    %The questions is if dividing up the data is better/faster.
    freq                = ft_freqanalysis(cfgfreq, data); %Should only be done on MEG channels.

    %plot those data and save for visual inspection
    figure('vis','off'),clf
    cnt                   = 1;
    subplot(2,3,cnt); cnt = cnt + 1;

    loglog(freq.freq, freq.powspctrm, 'linewidth', 0.1); hold on;
    loglog(freq.freq, mean(freq.powspctrm), 'k', 'linewidth', 1);
    axis tight; axis square; box off;
    set(gca, 'xtick', [10 50 100], 'tickdir', 'out', 'xticklabel', []);

    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed')

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
    cfg.artfctdef.zvalue.channel     = {'EEG058'}; %UADC004 UADC003

    % 001, 006, 0012 and 0018 are the vertical and horizontal eog chans
    cfg.artfctdef.zvalue.trlpadding  = 0; % avoid filter edge artefacts by setting to negative
    cfg.artfctdef.zvalue.fltpadding  = 0;
    cfg.artfctdef.zvalue.artpadding  = 0.05; % go a bit to the sides of blinks

    % algorithmic parameters
    cfg.artfctdef.zvalue.bpfilter   = 'yes';
    cfg.artfctdef.zvalue.bpfilttype = 'but';
    cfg.artfctdef.zvalue.bpfreq     = [1 15];
    cfg.artfctdef.zvalue.bpfiltord  = 2;
    cfg.artfctdef.zvalue.hilbert    = 'yes';

    % set cutoff
    cfg.artfctdef.zvalue.cutoff     = 2; % to detect all blinks, be strict
    cfg.artfctdef.zvalue.interactive = 'no';
    [~, artifact_eog]               = ft_artifact_zvalue(cfg, data);
    artifact_eogVertical = artifact_eog;



    cfg                             = [];
    cfg.artfctdef.reject            = 'partial';
    cfg.artfctdef.eog.artifact      = artifact_eogVertical;

    %plot the blink rate vertical??
    cfg=[];
    cfg.channel = 'EEG058'; % UADC004 if eyelink is present
    blinks = ft_selectdata(cfg,data);



    %If there is no variance in the data then it is probably because the
    %eyelink was not working for that session.
    % if var(blinks.trial{:})<0.01 %No eyelink
    %   %raise error
    %   msg='There is no Eylink data';
    %   error(msg);
    % end
    subplot(2,3,cnt); cnt = cnt + 1;
    plot([blinks.trial{:}])
    axis tight; axis square; box off;
    title('Blink rate eog58')

    % reject blinks only when they occur between fix and stim offset
    %crittoilim = [ data.trialinfo(:,2) - data.trialinfo(:,1) - 0.4*data.fsample ...
    %    data.trialinfo(:,5) - data.trialinfo(:,1) + 0.8*data.fsample]  / data.fsample;
    %cfg.artfctdef.crittoilim        = crittoilim;
    %data                            = ft_rejectartifact(cfg, data);
    %%

    %%
    % ==================================================================
    % 4. REMOVE TRIALS WITH JUMPS
    % Compute the power spectrum of all trials and a linear line on the loglog-
    % transformed power spectrum. Jumps cause broad range increase in the power
    % spectrum so trials containing jumps can be selected by detecting outliers
    % in the intercepts of the fitted lines (using Grubb?s test for outliers).
    % ==================================================================


    %save figure
    % cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/plots')
    % %New naming file standard. Apply to all projects.
    % formatOut = 'yyyy-mm-dd';
    % todaystr = datestr(now,formatOut);
    % namefigure='testplots_preproc_task'
    % figurefreqname = sprintf('%s_%s_2P%s_T%d.png',todaystr,namefigure)%
    % saveas(gca,figurefreqname,'png')

    %TODO: Join the findSquidJumps with the first freq analysis...
    channelJump=findSquidJumps(data,cfgin.restingfile);
    artifact_Jump = channelJump;
    subplot(2,3,cnt); cnt = cnt + 1;

    %If there are jumps, plot them.
    if ~isempty(channelJump)
      %I will do the channelrepair from here on
      cfg = [];
      cfg.method = 'spline';
      cfg.badchannel = artifact_Jump%ismember(data.label,artifact_Jump);
      cfg2=[];
      cfg2.method = 'template';
      cfg2.template = 'CTF275_neighb.mat';
      cfg2.channel = 'MEG';
      cfg.neighbours = ft_prepare_neighbours(cfg2,data);
      cfg.senstype = 'meg';
      data=ft_channelrepair(cfg,data);
      %subplot...
      for ijump = 1:length(channelJump)
        plot(data.trial{1}( ismember(data.label,channelJump{ijump}),:))
        hold on
      end
    else
      title('No jumps')
    end


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
    %TODO:inconsistent number of samples. Needs to be fixed.
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
    data.sampleinfo=[1 length(data.time{1})];




    %%
    %Do a highpass filter go get rid of all frequencies below 2Hz
    cfg          = [];
    cfg.hpfilter = 'yes';
    cfg.hpfreq   = 2;
    data = ft_preprocessing(cfg,data);

    %%
    %Change folder and save approapriate data + figures
    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed/')

    name = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed/P%s',cfgin.restingfile(2:3));

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

    save(artstore,'artifact_eogVertical','artifact_Muscle','artifact_Jump') %Jumpos?

    %save the invisible figure
    figurestore=sprintf('Overview%s.png',dsfile(end-8:end-4));
    saveas(gca,figurestore,'png')

    %Catch any error and write into file
  catch err

    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed')
    fid=fopen('logfile','a+');
    c=clock;
    fprintf(fid,sprintf('\n\n\n\nNew entry for %s at %i/%i/%i %i:%i\n\n\n\n',cfgin.restingfile,fix(c(1)),fix(c(2)),fix(c(3)),fix(c(4)),fix(c(5))))

    fprintf(fid,'%s',err.getReport('extended','hyperlinks','off'))

    fclose(fid)


  end

  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting')
end
