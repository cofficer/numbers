function [channelJump,trialnum]=findSquidJumps( data,pathname )
  %UNTITLED Summary of this function goes here
  %   Detailed explanation goes here

  %clear all

  %%
  %Change the folder to where MEG data is contained
  %cd('/mnt/homes/home024/ktsetsos/resting')

  %Store all the seperate data files
  %restingpaths = dir('*.mat');

  %Loop all data files into seperate jobs

  %for icfg = 1:length(restingpaths)

  % cfgin{icfg}.restingfile             = restingpaths(icfg).name;%128 works.

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


  % detrend and demean
  cfg             = [];
  cfg.detrend     = 'yes';
  cfg.demean      = 'yes';
  %cfg1.trials     = cfg1.trial{1}
  %cfg.hpfilter = 'yes';
  %cfg.channel  = {'MEG'};
  %cfg.hpfreq   = 60;
  data            = ft_preprocessing(cfg, data);

  %====================================================
  %Find and plot the trials where the block changes.
  %Each trial is now 7s long. 212 trls, 1484s, 24min.
  %fsample 500hz. dataold.oldtrl(3)/3500 is which trial?
  %how to get at the sample of each trial. each trial 3500samples. 308938
  %====================================================

  dat_lab1st = cellfun(@(x) x(1),data.label);
  ind_meg = (ismember(dat_lab1st,'M'));
  trl_ind_blockch = round(dataold.oldtrl(1)/3500)+1;

  % figure(1),clf
  % hold on
  % dat_plot=data.trial{trl_ind_blockch}(ind_meg,:);
  trl_rem(1)=trl_ind_blockch;
  % plot(dat_plot(10,:),'g')

  if dataold.oldtrl>2
    trl_ind_blockch = trl_ind_blockch+round(dataold.oldtrl(2)/3500);
    trl_rem(2)=trl_ind_blockch;
    % dat_plot=data.trial{trl_ind_blockch}(ind_meg,:);
    % plot(dat_plot(10,:),'k')
  end

  % saveas(gca,'test_fig_trl_blockchange.png','png')

  %remove trials with blockchange   saveas(gca,'test_jumps_blockchange.png','png')
  cfg = [];
  cfg.trials=ones(1,length(data.trial))
  cfg.trials(trl_rem)=0;
  cfg.trials=logical(cfg.trials);
  data = ft_selectdata(cfg,data);

  %====================================================

  %====================================================


  % compute the intercept of the loglog fourier spectrum on each trial
  disp('searching for trials with squid jumps...');


  % get the fourier spectrum per trial and sensor
  cfgfreq             = [];
  cfgfreq.method      = 'mtmfft';
  cfgfreq.output      = 'pow';
  cfgfreq.taper       = 'hanning';
  cfgfreq.channel     = 'MEG';
  cfgfreq.foi         = 1:130;
  cfgfreq.keeptrials  = 'yes';
  freq                = ft_freqanalysis(cfgfreq, data);

  % compute the intercept of the loglog fourier spectrum on each trial
  disp('searching for trials with squid jumps...');
  intercept       = nan(size(freq.powspctrm, 1), size(freq.powspctrm, 2));
  x = [ones(size(freq.freq))' log(freq.freq)'];

  for t = 1:size(freq.powspctrm, 1),
    for c = 1:size(freq.powspctrm, 2),
      b = x\log(squeeze(freq.powspctrm(t,c,:)));
      intercept(t,c) = b(1);
    end
  end


  % detect jumps as outliers, actually this returns the channels too...
  [~, idx] = deleteoutliers(intercept(:));

  %subplot(4,4,cnt); cnt = cnt + 1;
  if isempty(idx),
    fprintf('no squid jump trials found \n');
    %title('No jumps'); axis off;
    channelJump=[];
  else

    jumps_total=length(idx);

    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed')
    fid=fopen('logfile_squidJumps','a+');
    c=clock;
    fprintf(fid,sprintf('\n\nNew entry for %s at %i/%i/%i %i:%i\n\n',pathname,fix(c(1)),fix(c(2)),fix(c(3)),fix(c(4)),fix(c(5))))

    fprintf(fid,'Number of squid jumps: %i',jumps_total)

    fclose(fid)

    %For each detected jump, loop and get the name


    %reload data
    %load(pathname.restingfile)

    channelJump = cell(length(idx),1);
    for iout = 1:length(idx)

      %I belive that y is trial and x is channel.
      [y,x] = ind2sub(size(intercept),idx(iout)) ;

      %Store the name of the channel
      channelJump(iout) = freq.label(x);
      trialnum(iout)    = y;
    end
  end
end
