function freq_numbers(cfgin)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Created 2018-02-14
  %Run spectral decomposition on all numbers data.
  %load each cfgin
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



  if strcmp(cfgin.blocktype,'trial')
    cd(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/auto_task',cfgin.blocktype))
    if strcmp(cfgin.restingfile(3),'_')
      dataset=sprintf('P%s_s%s_b%s.mat',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
    else
      dataset=sprintf('P%s_s%s_b%s.mat',cfgin.restingfile(2:3),cfgin.restingfile(6),cfgin.restingfile(9));
    end
  elseif strcmp(cfgin.blocktype,'resting')
    if strcmp(cfgin.restingfile(1),'0')
      dataset=sprintf('P%s_%s_%s',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
    else
      dataset=sprintf('P%s_%s_%s',cfgin.restingfile(1:2),cfgin.restingfile(5),cfgin.restingfile(8));
    end
  end

  load(dataset)
  

  %Seperate the data into orthogonal sensors
  cfg_pn = [];
  cfg_pn.method = 'distance';
  cfg_pn.template = 'C:\Users\Thomas Meindertsma\Documents\MATLAB\CTF275_neighb.mat';
  cfg_pn.template = 'CTF275_neighb';
  cfg_pn.channel = 'MEG';

  cfg_mp.planarmethod = 'sincos';
  cfg_mp.trials = 'all';
  cfg_mp.channel = 'MEG';
  cfg_mp.neighbours = ft_prepare_neighbours(cfg_pn, data);
  data = ft_megplanar(cfg_mp, data);


  % plot a quick power spectrum
  % save those cfgs for later plotting
  cfgfreq             = [];
  cfgfreq.method      = 'mtmfft';
  cfgfreq.output      = 'pow';
  cfgfreq.taper       = 'dpss';
  cfgfreq.channel     = 'MEG';
  cfgfreq.foi         = 2:130;
  cfgfreq.t_ftimwin   = (4./cfgfreq.foi)
  cfgfreq.tapsmofrq   =  0.1 *cfg.foi
  cfgfreq.keeptrials  = 'yes';
  freq                = ft_freqanalysis(cfgfreq, data); %Should only be done on MEG channels.


  %Combine planar
  cfgC=[];
  cfgC.trials='all';
  cfgC.combinemethod='sum';
  freq=ft_combineplanar(cfgC,freq);




end
