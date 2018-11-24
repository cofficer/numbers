function plot_jump_sensors(artifact_Jump)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Created 2018-11-22
  %Load spectral decomposition of all numbers data.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed')

  % initialise the artifact vector
  artifact_JumpAll=[];
  %loop over all the participants
  ndat=dir();
  ndat_flags=[ndat.isdir];
  ndat_flags_pos=find(ndat_flags);

  curr_dir=pwd;

  for ipart = 3:length(ndat_flags_pos)

    % change directory to participant directory

    cd(sprintf('%s/%s',curr_dir,ndat(ndat_flags_pos(ipart)).name))

    dat_files=dir('*.mat');

    for idat = 1:length(dat_files)

      load(dat_files(idat).name)

      artifact_JumpAll=vertcat(artifact_JumpAll,artifact_Jump);


    end
  end

  sensors_affected = unique(artifact_JumpAll);

  %it might be preferable to get the jump sensors as an index 1:275 instead of
  %the sensor name
  find(artifact_JumpAll,data.label)


  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/plots')
  [uni,~,idx] = unique(artifact_JumpAll);
  figure(1),clf
  hist(idx,unique(idx))
  set(gca,'xtick',[1:251],'xticklabel',uni)
  set(gca,'FontSize',6)
  xtickangle(80)
  namefigure='jumping_sensors_trial'
  formatOut = 'yyyy-mm-dd';
  todaystr = datestr(now,formatOut);
  figurefreqname = sprintf('%s_%s.png',todaystr,namefigure)%2012-06-28 idyllwild library - sd - exterior massing model 04.skp
  saveas(gca,figurefreqname,'png')


  % plot only specific sensors. or label only specific sensors.
  % load some random dat just to have the it for plotting.
  load('/home/chrisgahn/Documents/MATLAB/Lissajous/continuous/freq/self/25freq_low_selfocclBlock3.mat')

  % freq.powspctrm=zeros(size(freq.powspctrm));


  cfg=[];
  cfg.trials='all';
  cfg.avgoverrpt='yes';
  cfg.latency='all';
  cfg.avgovertime='yes';
  cfg.frequency='all';
  cfg.avgoverfreq='yes';
  freq=ft_selectdata(cfg,freq);


  %insert weighted averages as a percentage of all jumps detected
  freq.powspctrm=zeros(size(freq.powspctrm))

  denom_weight=length(artifact_JumpAll);

  for iidx = 1:length(idx)
    freq.powspctrm(idx(iidx))=1+freq.powspctrm(idx(iidx));
  end

  freq.powspctrm=freq.powspctrm./denom_weight;
  freq.powspctrm=freq.powspctrm';

    hf=figure(1),clf
    cfg=[];
    cfg.zlim         = [0 0];
    cfg.layout       = 'CTF275_helmet.lay';
    cfg.interactive = 'no';
    cfg.title='Cluster Channels';
    cfg.colorbar           = 'yes'
    % cfg.highlight='labels';
    % cfg.highlightchannel=uni;
    cfg.highlightcolor =[0 0 0];
    cfg.highlightsize=12;
    ft_topoplotTFR(cfg,freq)

  namefigure='jumping_sensors_trial_topoplot2';
  figurefreqname = sprintf('%s_%s.png',todaystr,namefigure)%2012-06-28 idyllwild library - sd - exterior massing model 04.skp
  saveas(gca,figurefreqname,'png')


end
