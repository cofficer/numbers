function data=taskPreprocNumbers( cfgin )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %The current code is copied from restingPreprocNumbers
  %Needs to output 1 continuous trial, from 3 trial input.
  %TODO: remove all eyelink-related analysis, and replace w/ eog.
  %Only remove jumps and muscle.
  %2017-10-29 created.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  try
    %Folder with the resting data
    rawpath = '/mnt/homes/home024/ktsetsos/preproc3/' %'/home/chrisgahn/Documents/MATLAB/ktsetsos/trial/raw/';
    cd(rawpath)

    %load datafile
    dsfile=cfgin.restingfile
    load(dsfile)



    %only keep relevant sensors.
    cfg3 = [];
    cfg3.detrend = 'no';
    cfg3.demean = 'yes';
    idx_1str = cellfun(@(x) x(1),data.label);
    idx_1str = ismember(idx_1str,'M');
    idx_channels = [242,100];
    cfg3.channel = data.label(idx_1str)
    more_channels = {'EYE01',...
    'EYE02','EYE03','UADC003',...
    'UADC004','EEG058','EEG059',...
    'HLC0011','HLC0012','HLC0013', ...
    'HLC0021','HLC0022','HLC0023', ...
    'HLC0031','HLC0032','HLC0033'};

    cfg3.channel = [cfg3.channel;more_channels'];
    data = ft_preprocessing(cfg3,data);

    %===========================================================
    %Fuse the trial seperation.
    %Change data.time, so to be unique all the way.
    %===========================================================
    if isfield(cfgin,'runblock')
      cfg4 =[];
      cfg4.trials=zeros(1,3);
      cfg4.trials(cfgin.runblock)=1;
      cfg4.trials=logical(cfg4.trials')
      data=ft_selectdata(cfg4,data);
    else
      %Save the size of each trial
      for itrl = 1:length(data.trial)
        oldtrl(itrl) = length(data.trial{itrl});
      end

      dat_trl = [data.trial{:}];
      data.trial=[];
      data.trial{1}=dat_trl;
      clear dat_trl

      dat_tme = [data.time{:}];
      data.time=[];
      %Before 2017-11-18. 500
      data.time{1}=[0:length(dat_tme)-1]./500;

      data.sampleinfo = [1 length(data.trial{1})]

    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %plot freq Overview
    %plot those data and save for visual inspection
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure('vis','off'),clf
    cnt                   = 1;
    subplot(2,3,cnt); cnt = cnt + 1;

    %plot freq analysis
    check_freq_plot(cfgin,data,cnt);
    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed')



    %data.sampleinfo=[data.sampleinfo(1) data.sampleinfo(end)];

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
    channelJump=findSquidJumps(data,cfgin,oldtrl);
    artifact_Jump = channelJump;
    subplot(2,3,cnt); cnt = cnt + 1;

    %If there are jumps, plot them.
    if ~isempty(channelJump)
      %I will do the channelrepair from here on
      %Need to save the EOG058 and eyelink channels.
      cfg   = [];
      cfg.channel = {'EEG058','EEG059','UADC003','UADC004','EYE01','EYE02','EYE03'};
      eyeData = ft_selectdata(cfg,data);
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
      cfg =[];
      data = ft_appenddata(cfg,data,eyeData);
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
    %plot freq analysis
    subplot(2,3,cnt);
    check_freq_plot(cfgin,data,cnt);

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

    if strcmp(cfgin.restingfile(3),'_')
      name = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed/P0%s',cfgin.restingfile(2));
    else
      name = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed/P%s',cfgin.restingfile(2:3));
    end
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
    if isfield(cfgin,'runblock')
      cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/auto_task')

      if strcmp(cfgin.restingfile(3),'_')
        figurestore=sprintf('P0%s_Overview%s_task%s.png',cfgin.restingfile(2),dsfile(end-8:end-4),num2str(cfgin.runblock));
      else
        figurestore=sprintf('P%s_Overview%s_task%s.png',cfgin.restingfile(2:3),dsfile(end-8:end-4),num2str(cfgin.runblock));
      end

      saveas(gca,figurestore,'png')
    else
      filestore=sprintf('preproc%s.mat',dsfile(end-8:end-4));
      save(filestore,'data')

      %Save the artifacts
      artstore=sprintf('artifacts%s.mat',dsfile(end-8:end-4));

      save(artstore,'artifact_eogVertical','artifact_Muscle','artifact_Jump') %Jumpos?

      %save the invisible figure
      figurestore=sprintf('Overview%s.png',dsfile(end-8:end-4));
      saveas(gca,figurestore,'png')
    end
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
