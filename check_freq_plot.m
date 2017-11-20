function check_freq_plot(cfgin,data,cnt)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Needs to plot freq from 1 continuous trial, with min. memreq
  %2017-11-20 created.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  %make data trialbased.

  %load data
  %load(pathname.restingfile)
  doplot=0;
  %calculate squid jumps
  cfg = [] ;
  cfg.length = 7;
  %lengthsec = 7;
  %cfg.toilim =[0 7];
  %cfg.offset = 1:1200*lengthsec:1200*301;
  cfg.overlap =0;

  %Only change the trialstructure if it is continuous
  if length(data.trial) < 2
    data = ft_redefinetrial(cfg,data) ;
  end


  %TODO: Create a function which creates trials and then computes the
  %power spectrum because it is not feasable to do on a continuous time series.
  % plot a quick power spectrum
  % save those cfgs for later plotting
  cfgfreq             = [];
  cfgfreq.method      = 'mtmfft';
  cfgfreq.output      = 'pow';
  cfgfreq.taper       = 'hanning';
  cfgfreq.channel     = 'MEG';
  cfgfreq.foi         = 1:5:130;
  %Due to memory issue, trying to reduce oadding.
  cfgfreq.padtype     = 'zero'
  %cfgfreq.pad         = 100;
  %cfgfreq.padlength   = 1;
  cfgfreq.keeptrials  = 'no';
  %Requires a tonne of memory, 16gb needed.
  %But this analysis is imortant, for quality checking jumps.
  %The questions is if dividing up the data is better/faster.
  freq                = ft_freqanalysis(cfgfreq, data); %Should only be done on MEG channels.

  loglog(freq.freq, freq.powspctrm, 'linewidth', 0.1); hold on;
  loglog(freq.freq, mean(freq.powspctrm), 'k', 'linewidth', 1);
  axis tight; axis square; box off;
  set(gca, 'xtick', [10 50 100], 'tickdir', 'out', 'xticklabel', []);

end
