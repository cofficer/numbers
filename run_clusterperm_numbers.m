function [value]=run_clusterperm_numbers(~)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Created 2018-03-11.
%Run cluster-based permutation test on power spectrum
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  clear all
  blocktype = 'trial';
  cd(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/freq',blocktype))

  freq_files = dir('*.mat')
  load(freq_files(1).name)
  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/')
  % save('2018-03-09_resting_freqs.mat','nocebo_rest','placebo_rest','lora_rest')
  % save('2018-03-09_trial_freqs.mat','nocebo_trl','placebo_trl','lora_trl')
  load('2018-03-09_resting_freqs.mat')
  load('2018-03-09_trial_freqs.mat')
  %Implement a gramm plot for resting.
  %The values of
  % nocebo_rest     = nanmean(nocebo_rest,1);
  % placebo_rest    = nanmean(nocebo_rest,1);
  % lora_rest       = nanmean(nocebo_rest,1);


  idxn          = isnan(nocebo_rest(:,1));
  idxp          = isnan(placebo_rest(:,1));
  idxl          = isnan(lora_rest(:,1));

  idxnt          = isnan(nocebo_trl(:,1));
  idxpt          = isnan(placebo_trl(:,1));
  idxlt          = isnan(lora_trl(:,1));

  idx_nant = idxnt+idxpt+idxlt;
  idx_nant = idx_nant==0;

  nocebo_trl    = nocebo_trl(idx_nant,:);
  placebo_trl   = placebo_trl(idx_nant,:);
  lora_trl      = lora_trl(idx_nant,:);

  idx_nan = idxn+idxp+idxl;
  idx_nan = idx_nan==0;

  nocebo_rest   = nocebo_rest(idx_nan,:);
  placebo_rest  = placebo_rest(idx_nan,:);
  lora_rest     = lora_rest(idx_nan,:);

  %Looks like the best way to use gramm, is using converting the data
  %into long vectors....
  % dat.nocebo_rest = nocebo_rest';
  ist = 1
  ien = 641
  for ipart = 1:38

    dat.nocebo_rest(ist:ien) = nocebo_rest(ipart,1:641);
    dat.placebo_rest(ist:ien) = placebo_rest(ipart,1:641);
    dat.lora_rest(ist:ien) = lora_rest(ipart,1:641);

    ist = ist+641;
    ien = ien+641;
  end

  ist = 1
  ien = 641
  for ipart = 1:36
    dat.nocebo_trl(ist:ien) = nocebo_trl(ipart,1:641);
    dat.placebo_trl(ist:ien) = placebo_trl(ipart,1:641);
    dat.lora_trl(ist:ien) = lora_trl(ipart,1:641);
    ist = ist+641;
    ien = ien+641;
  end

  dat.nocebo_trl = dat.nocebo_trl';
  dat.placebo_trl = dat.placebo_trl';
  dat.lora_trl = dat.lora_trl';

  dat.nocebo_rest = dat.nocebo_rest';
  dat.placebo_rest = dat.placebo_rest';
  dat.lora_rest = dat.lora_rest';

  dat.parts_rest       = [1:38]'*repmat(1,1,641);
  dat.parts_rest       = dat.parts_rest';
  dat.parts_rest       = dat.parts_rest(:);

  dat.parts_trl       = [1:36]'*repmat(1,1,641);
  dat.parts_trl       = dat.parts_trl';
  dat.parts_trl       = dat.parts_trl(:);

  dat.xfreq_rest       = repmat(freq.freq,1,38)';
  dat.xfreq_rest       = dat.xfreq_rest';
  dat.xfreq_rest       = dat.xfreq_rest(:);

  dat.xfreq_trl       = repmat(freq.freq,1,36)';
  dat.xfreq_trl       = dat.xfreq_trl';
  dat.xfreq_trl       = dat.xfreq_trl(:);



  %
  %Maybe it would be possible to simply load in the
  %Cluster-based permutation test on timecourses from Matching project.


    %%
    %I will compare for each participant, within Unit of observation...
    cfg_freq =[];
    cfg_freq.avgoverchan = 'yes';
    freq2 = ft_selectdata(cfg_freq,freq);
    cfg_freq =[];
    cfg.avgovertime = 'yes';
    freq2 = ft_selectdata(cfg_freq,freq2);
    %Reconfigure the frequency structure which is normally required.
    resp.freq = freq2;
    resp.freq.label = {'custompooling'};

    lorazepam = resp.freq;
    placebo = resp.freq;

    %add the times to the frequency, try to treat frequencies as times.
    lorazepam.freq = freq.freq;
    placebo.freq = freq.freq;

    lorazepam.powspctrm = zeros(36,1,641);
    placebo.powspctrm = zeros(36,1,641);

    lorazepam.powspctrm(:,1,:) = lora_trl;
    placebo.powspctrm(:,1,:) = placebo_trl;

    lorazepam.dimord = 'subj_chan_freq'; %ask thomas
    placebo.dimord = 'subj_chan_freq';


  cfg = [];
  cfg.correctm = 'cluster';% Ask thoms.
  cfg.statistic = 'ft_statfun_depsamplesT'; %ask thomas
  cfg.clusteralpha = 0.05;
  cfg.clusterstatistic = 'maxsum'; %default
  cfg.method = 'montecarlo';
  cfg.numrandomization = 10000;

  %What is necessary to include in the design...
  design(1,:) = [1:36 1:36];
  design(2,:) = [ones(1,36) ones(1,36)*2];
  %design = [ ones(1,size(low,2)) ones(1,size(low,2))*2; 1:size(low,2) 1:size(low,2)]';

  cfg.design = design;
  cfg.ivar = 2;
  cfg.uvar = 1;
  cfg.tail = 0;
  cfg.clustertail = 0;
  %cfg.correcttail = 'prob';
  cfg.alpha = 0.05;
  cfg.frequency = 'all';

  cfg_neigh.method = 'distance';
  cfg.neighours = ft_prepare_neighbours(cfg_neigh,freq);
  % cfg.neighbours = [];

  statR = ft_freqstatistics(cfg,lorazepam,placebo);


  idx_mask=statR.negclusterslabelmat>0;


  %Cluster-based permutation test from Lissajous project
  cfg = [];
  if strcmp(topo_or_tfr,'topo')
    cfg.latency          = 'all';%[0.3 0.7];
  else
    cfg.channel          =  {'MEG'}; % visual_sensors; %
  end

  cfg.method           = 'montecarlo';
  % cfg.frequency        = 75;
  cfg.statistic        = 'ft_statfun_depsamplesT';
  cfg.correctm         = 'cluster';
  cfg.clusteralpha     = 0.05; %Normal 0.05
  cfg.clusterstatistic = 'maxsum';
  cfg.minnbchan        = 2;
  cfg.tail             = 0;
  cfg.clustertail      = 0;
  cfg.alpha            = 0.05;
  cfg.numrandomization = 500;
  % prepare_neighbours determines what sensors may form clusters
  cfg_neighb.method    = 'distance';
  cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, freq);
  cfg.channel           = dat_time0.label;

  subj = size(dat_time0.powspctrm,1);
  design = zeros(2,2*subj);
  for i = 1:subj
    design(1,i) = i;
  end
  for i = 1:subj
    design(1,subj+i) = i;
  end
  design(2,1:subj)        = 1;
  design(2,subj+1:2*subj) = 2;

  cfg.design   = design;
  cfg.uvar     = 1;
  cfg.ivar     = 2;
  [stat] = ft_freqstatistics(cfg, dat_time0, dat_time1);
  sum(stat.mask)


end
