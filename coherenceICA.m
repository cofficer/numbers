function [val_cor,idx_coh] = coherenceICA( cfgin,channelRej )
  %Using coherence analysis this function will output the channels which
  %should be rejected. cfgin.restingfile='040_3_3.mat'
  %channelRej='4' %'UADC004'; %UADC004, % EEG059 Heart.




  if strcmp(cfgin.blocktype,'resting')
    %define ds file, this is actually from the trial-based data
    dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P%s/preprocS%s_P%s.mat'...
    ,cfgin.restingfile(2:3),cfgin.restingfile(5),cfgin.restingfile(7));
  else

    if strcmp(cfgin.restingfile(3),'_')
      dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed/P0%s/preprocs%s_b%s.mat',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
    else
      dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed/P%s/preprocs%s_b%s.mat',cfgin.restingfile(2:3),cfgin.restingfile(5),cfgin.restingfile(8));
    end
  end

  load(dsfile)

  cd(dsfile(1:end-16))

  cfg=[];
  cfg.channel = channelRej;
  ecg = ft_selectdata(cfg,data);
  ecg.label{:} = channelRej;

  % concatenate component activity, small change, test


  %%%%%%
  %Download 07_3_3. Check the ecg channel for finding the heart beats.
  %Problem seems to be that they are not getting identified.
  % figure(1),clf
  % plot(ecg.trial{1}(end-10000:end))
  % saveas(gca,'test_heartrate_channel.png','png')
  %%%%%%%%%%%%%%%%



  %%
  %select components for heart rate
  cfg                       = [];
  cfg.trl                   = [1 length(data.trial{1})];
  cfg.dataset               = data;
  cfg.continuous            = 'yes';
  if strcmp(channelRej,'3') || strcmp(channelRej,'EEG057') || strcmp(channelRej,'EEG057')
    cfg.artfctdef.ecg.pretim  = 0.1;
    cfg.artfctdef.ecg.psttim  = 0.1-1/500;
  else
    cfg.artfctdef.ecg.pretim  = 0.15;
    cfg.artfctdef.ecg.psttim  = 0.3-1/500;
  end
  cfg.channel            ={channelRej};
  cfg.artfctdef.ecg.channel               = {channelRej};
  cfg.artfctdef.ecg.inspect  = {channelRej};
  cfg.artfctdef.ecg.cutoff   = 2; %Important setting, since its automatic.
  cfg.artfctdef.ecg.feedback = 'no';
  [cfg, artifact]            = ft_artifact_ecg(cfg, ecg);

  %%
  %can the same be done with the preprocessed data... YES!



  %%
  % preproces the data around the QRS-complex, i.e. read the segments of raw data containing the ECG artifact

  %cd('/mnt/homes/home024/ktsetsos/meg_data')

  %this part might be unnecessary
  % cfg            = [];
  % cfg.dataset    = data;
  % cfg.continuous = 'yes';
  % cfg.padding    = 10;
  % cfg.dftfilter  = 'yes';
  % cfg.demean     = 'yes';
  % cfg.trl        = [artifact zeros(size(artifact,1),1)];
  % cfg.channel    = {'MEG'};
  % %data_ecg       = ft_preprocessing(cfg);
  % cfg.channel    = {channelRej};
  % ecg            = ft_preprocessing(cfg);
  % ecg.channel{:} = 'ECG'; % renaming is purely for clarity and consistency

  %Or actually I need to make the continuous data into trials based on the
  %artifacts
  cfg            = [];
  cfg.trl        = [artifact,zeros(size(artifact,1),1)];
  cfg.channel    = {'MEG'};
  cfg.continuous = 'yes';
  data_ecg       = ft_preprocessing(cfg,data);

  data_ecg       = ft_redefinetrial(cfg,data_ecg);
  cfg.channel    = {channelRej};
  ecg            = ft_preprocessing(cfg,data);
  ecg            = ft_redefinetrial(cfg,ecg);
  ecg.channel{:} = 'ECG';%channelRej;

  %load the previously computed ICA components

  if strcmp(cfgin.blocktype,'resting')
    load(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P%s/compS%s_P%s.mat',...
    cfgin.restingfile(2:3),cfgin.restingfile(5),cfgin.restingfile(7)))
  else

    if strcmp(cfgin.restingfile(3),'_')
      load(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed/P0%s/compS%s_B%s.mat',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8)));
    else
      load(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed/P%s/compS%s_B%s.mat',cfgin.restingfile(2:3),cfgin.restingfile(5),cfgin.restingfile(8)));
    end
  end
  % decompose the ECG-locked datasegments into components, using the previously found (un)mixing matrix
  cfg           = [];
  cfg.unmixing  = comp.unmixing;
  cfg.topolabel = comp.topolabel;
  comp_ecg      = ft_componentanalysis(cfg, data_ecg);

  % append the ecg channel to the data structure;
  comp_ecg      = ft_appenddata([], ecg, comp_ecg);

  % average the components timelocked to the QRS-complex
  cfg           = [];
  timelock      = ft_timelockanalysis(cfg, comp_ecg);

  % look at the timelocked/averaged components and compare them with the ECG
  % figure
  % subplot(2,1,1); plot(timelock.time, timelock.avg(1,:))
  % subplot(2,1,2); plot(timelock.time, timelock.avg(2:end,:))
  % figure
  % subplot(2,1,1); plot(timelock.time, timelock.avg(1,:))
  % subplot(2,1,2); imagesc(timelock.avg(2:end,:));


  % compute a frequency decomposition of all components and the ECG
  cfg            = [];
  cfg.method     = 'mtmfft';
  cfg.output     = 'fourier';
  cfg.foilim     = [0 100];
  cfg.taper      = 'hanning';
  cfg.pad        = 'maxperlen';
  freq           = ft_freqanalysis(cfg, comp_ecg);
  % compute coherence between all components and the ECG
  cfg            = [];
  cfg.channelcmb = {'all' channelRej};
  cfg.jackknife  = 'no';
  cfg.method     = 'coh';
  fdcomp         = ft_connectivityanalysis(cfg, freq);

  % look at the coherence spectrum between all components and the ECG
  figure;
  subplot(2,1,1); plot(fdcomp.freq, abs(fdcomp.cohspctrm));
  subplot(2,1,2); imagesc(abs(fdcomp.cohspctrm));
  figurestore=sprintf('cohspctrmComp%s_%s.png',channelRej,cfgin.restingfile(1:end-4));
  saveas(gca,figurestore,'png')
  close
  %Save this figure.

  %calculate to average coherence over all frequencies:
  [val_cor,idx_coh] = sort(mean(fdcomp.cohspctrm,2));

  %Take the  highest correlating component and use as a spatial template to calculate the coherence
  %But only for the eyeblinks!
  if ~strcmp(channelRej,'EEG059')
    rej_components = idx_coh(end);

    %Compute the spatial correlation of artifact and all components
    cor_comp_artifact = corr(comp.topo(:,rej_components),comp.topo(:,:));

    %Sort in order of spatial correlation
    [val_cor,idx_coh] = sort(cor_comp_artifact);



  end

  %%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Bunch of plotting!
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Which figures are important?
  %1. The overall coherence. Done
  %2. Also the variance of the top coherence components.
  %3. Also the first thirty components. And their variances.


  %Plot the comoponent data together with the artifact data, timelocked to
  %the artifact.
  figure('vis','off'),clf
  subplot(2,1,1); plot(timelock.time, timelock.avg(1,:))
  subplot(2,1,2); plot(timelock.time, timelock.avg(2:end,:))
  figurestore=sprintf('TimelockComp%s_%s.png',channelRej,cfgin.restingfile(1:end-4));
  saveas(gca,figurestore,'png')
  close

  %Plot the variance of the components.
  %f=figure('vis','off'),clf
  cfg = [];

  %trick fieldtrip into thinking it has meg and not comp.
  corect_labels = ft_channelselection('meg',data.label);
  comp_labels   = comp.label;
  comp.label    = corect_labels(1:length(comp_labels));
  cfg.channel  = [idx_coh(end-7:end)];
  cfg.path     = '/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed';
  cfg.prefix   = 'cohComp';
  cfg.layout          = 'CTF275.lay';
  cfg.viewmode        = 'component';
  %plot the 8 highest coherence components.
  modded_ft_icabrowser(cfg,comp);
  figurestore=sprintf('highCohComp%s_%s.png',channelRej,cfgin.restingfile(1:end-4));
  saveas(gca,figurestore,'png')

  %Only necessary to plot the first 30 components once.
  if ~strcmp(channelRej,'EEG059')
    %plot the 30 first components.
    cfg.channel  = 1:8;
    modded_ft_icabrowser(cfg,comp);
    figurestore=sprintf('Comp%d-%d_%s.png',cfg.channel(1),cfg.channel(end),cfgin.restingfile(1:end-4));
    saveas(gca,figurestore,'png')

    %plot the 30 first components.
    cfg.channel  = 9:16;
    modded_ft_icabrowser(cfg,comp);
    figurestore=sprintf('Comp%d-%d_%s.png',cfg.channel(1),cfg.channel(end),cfgin.restingfile(1:end-4));
    saveas(gca,figurestore,'png')

    %plot the 30 first components.
    cfg.channel  = 17:24;
    modded_ft_icabrowser(cfg,comp);
    figurestore=sprintf('Comp%d-%d_%s.png',cfg.channel(1),cfg.channel(end),cfgin.restingfile(1:end-4));
    saveas(gca,figurestore,'png')

    %plot the 30 first components.
    cfg.channel  = 25:32;
    modded_ft_icabrowser(cfg,comp);
    figurestore=sprintf('Comp%d-%d_%s.png',cfg.channel(1),cfg.channel(end),cfgin.restingfile(1:end-4));
    saveas(gca,figurestore,'png')
  end

  % decompose the original data as it was prior to downsampling to 150Hz
  % cfg           = [];
  % cfg.unmixing  = comp.unmixing;
  % cfg.topolabel = comp.topolabel;
  % comp_orig     = ft_componentanalysis(cfg, data);
  %
  % % the original data can now be reconstructed, excluding those components
  % cfg           = [];
  % cfg.component = [rej_components];
  % data_clean    = ft_rejectcomponent(cfg, comp_orig,data);

end
