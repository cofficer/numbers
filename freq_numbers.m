function freq_numbers(cfgin,block)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Created 2018-02-14
  %Run spectral decomposition on all numbers data.
  %load each cfgin
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



  if strcmp(cfgin.blocktype,'trial')
    cd(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/auto_task',cfgin.blocktype))
    if strcmp(cfgin.restingfile(3),'_')
      dataset=sprintf('P%s_s%s_b%s_preproc_task%d.mat',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8),block);
    else
      dataset=sprintf('P%s_s%s_b%s_preproc_task%d.mat',cfgin.restingfile(2:3),cfgin.restingfile(6),cfgin.restingfile(9),block);
    end
    load(dataset)
  elseif strcmp(cfgin.blocktype,'resting')
    cd(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/cleaned',cfgin.blocktype))
    if strcmp(cfgin.restingfile(1),'0')
      dataset=sprintf('P0%s_S%s_P%s.mat',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
    else
      dataset=sprintf('P%s_S%s_P%s.mat',cfgin.restingfile(1:2),cfgin.restingfile(5),cfgin.restingfile(8));
    end

    %Missing elec and grad during resting so add these from trial-based.
    dat=load('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/auto_task/P8_s3_b2_preproc_task3.mat');
    load(dataset)
    data.elec=dat.data.elec;
    data.grad=dat.data.grad;
    cfg = [];
    cfg.channel='MEG';
    data=ft_selectdata(cfg,data);
  end


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

  %Redefine the trials to make them 5s long.
  cfg = [];
  cfg.length=20;
  data_trl = ft_redefinetrial(cfg,data);

  %cut the continuous data into 5s sections before running freq analysis.
  % plot a quick power spectrum
  % save those cfgs for later plotting
  cfgfreq             = [];
  cfgfreq.method      = 'mtmfft';
  cfgfreq.output      = 'pow';
  cfgfreq.taper       = 'dpss';
  cfgfreq.channel     = 'MEG';
  cfgfreq.foi         = 2:0.2:130;
  cfgfreq.t_ftimwin   = ones(1,length(cfgfreq.foi))*5;
  cfgfreq.tapsmofrq   = 0.12;%
  % cfgfreq.keeptrials  = 'yes';
  freq                = ft_freqanalysis(cfgfreq, data_trl); %Should only be done on MEG channels.


  %Combine planar
  cfgC=[];
  cfgC.trials='all';
  cfgC.combinemethod='sum';
  freq=ft_combineplanar(cfgC,freq);

  cd(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/freq/',cfgin.blocktype))
  if strcmp(cfgin.blocktype,'trial')
    if strcmp(cfgin.restingfile(3),'_')
      outputfile=sprintf('P%s_s%s_b%s_freq_task%d,.mat',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8),block);
    else
      outputfile=sprintf('P%s_s%s_b%s_freq_task%d.mat',cfgin.restingfile(2:3),cfgin.restingfile(6),cfgin.restingfile(9),block);
    end
  elseif strcmp(cfgin.blocktype,'resting')
    if strcmp(cfgin.restingfile(1),'0')
      outputfile=sprintf('P0%s_S%s_freq_P%s.mat',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
    else
      outputfile=sprintf('P%s_S%s_freq_P%s.mat',cfgin.restingfile(1:2),cfgin.restingfile(5),cfgin.restingfile(8));
    end
  end

  %
  % figure(1),clf
  %
  % loglog(freq.freq, freq.powspctrm, 'linewidth', 0.1); hold on;
  % loglog(freq.freq, mean(freq.powspctrm), 'k', 'linewidth', 1);
  % % axis tight; axis square; box off;
  %   % set(gca, 'xtick', [10 50 100], 'tickdir', 'out', 'xticklabel', []);
  % saveas(gca,'figure.png')
  save(outputfile, 'freq','-v7.3');

end
