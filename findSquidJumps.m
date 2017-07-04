function idx=findSquidJumps( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%clear all

%%
%Change the folder to where MEG data is contained
cd('/mnt/homes/home024/ktsetsos/resting')

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

    data = ft_redefinetrial(cfg,data) ;



    % detrend and demean
    cfg             = [];
    cfg.detrend     = 'yes';
    cfg.demean      = 'yes';
    %cfg1.trials     = cfg1.trial{1}
    data            = ft_preprocessing(cfg, data);

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
else

    jumps_total=length(idx);

    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed')
    fid=fopen('logfile_squidJumps','a+');
    c=clock;
    fprintf(fid,sprintf('\n\nNew entry for %s at %i/%i/%i %i:%i\n\n',pathname.restingfile,fix(c(1)),fix(c(2)),fix(c(3)),fix(c(4)),fix(c(5))))

    fprintf(fid,'Number of squid jumps: %i',jumps_total)

    fclose(fid)

    %For each detected jump, loop and get the name
    if doplot

        %reload data
        load(pathname.restingfile)

        for iout = 1:length(idx)

            %I belive that y is trial and x is channel.
            [y,x] = ind2sub(size(intercept),idx(iout)) ;

            %Store the name of the channel
            channelJump{iout} = freq.label(x);

            %subplot...
            plot(data.trial{1}( ismember(data.label,channelJump{iout}),:))
            hold on

        end
    end
    %error('Finally a jump')
%     fprintf('removing %d squid jump trials \n', length(unique(t)));
%     [t,~] = ind2sub(size(intercept),idx);
%
%     % remove those trials
%     cfg                 = [];
%     cfg.trials          = true(1, length(data.trial));
%     cfg.trials(unique(t)) = false; % remove these trials
%     data                = ft_selectdata(cfg, data);
%
%     % plot the spectrum again
%     cfgfreq.keeptrials = 'no';
%     freq            = ft_freqanalysis(cfgfreq, data);
%     loglog(freq.freq, freq.powspctrm, 'linewidth', 0.1); hold on;
%     loglog(freq.freq, mean(freq.powspctrm), 'k', 'linewidth', 1);
%     axis tight; axis square; box off;
%     set(gca, 'xtick', [10 50 100], 'tickdir', 'out', 'xticklabel', []);
%     title(sprintf('%d jumps removed', length(unique(t))));
end


%    % detect jumps as outliers
%     cfg                    = [];
%     %cfg.trl = trl;
%     %cfg.datafile   = 'ArtifactMEG.ds';
%     %cfg.headerfile = 'ArtifactMEG.ds';
%     cfg.continuous = 'yes';
%
%     % channel selection, cutoff and padding
%     cfg.artfctdef.zvalue.channel    = 'MEG';
%     cfg.artfctdef.zvalue.cutoff     = 20;
%     cfg.artfctdef.zvalue.trlpadding = 0;
%     cfg.artfctdef.zvalue.artpadding = 0;
%     cfg.artfctdef.zvalue.fltpadding = 0;
%
%     % algorithmic parameters
%     cfg.artfctdef.zvalue.cumulative    = 'yes';
%     cfg.artfctdef.zvalue.medianfilter  = 'yes';
%     cfg.artfctdef.zvalue.medianfiltord = 9;
%     cfg.artfctdef.zvalue.absdiff       = 'yes';
%
%     % make the process interactive
%     cfg.artfctdef.zvalue.interactive = 'yes';
%
%     [cfg, artifact_Jump] = ft_artifact_zvalue(cfg,data);
%
    %subplot(2,3,cnt); cnt = cnt + 1;
%     if isempty(artifact_Jump),
%         fprintf('no squid jump trials found \n');
%         title('No jumps'); axis off;
%     else
%
%         %Figure out the actual number of jumps.
%         baselineSample = artifact_Jump(:,1)-artifact_Jump(1,1);
%
%         %first jump
%         it_jump = 1;
%
%         %set distance between jumps threshold in samples
%         thresh_jumps = 1200;
%
%         %Iteratively find the number of jumps
%         while sum(baselineSample(:)>thresh_jumps)>0
%             %then there are more than 1 jumps
%
%             %total number of iterations
%             it_jump = it_jump + 1;
%
%
%
%             %find the next one further away than threshold
%             if  (baselineSample(it_jump)-baselineSample(it_jump-1))>thresh_jumps
%                 baselineSample(it_jump:end)=baselineSample(it_jump:end)-baselineSample(it_jump,1);
%             end
%         end
%
%
%
%         %I need to get the start and end samples and then add some samples to
%         %remove.
%         jumpPadding = 1200*0.2;
%
%         %index the startsamples of the jumps
%         jumpStart = artifact_Jump(baselineSample(:,1)==0)-jumpPadding;
%         jumpEnd   = artifact_Jump(baselineSample(:,1)==0)+jumpPadding;
%         artifact_Jump=[jumpStart jumpEnd];
%
%         %delete jump data artifact
%         %[ data ] = delete_artifact_Numbers(artifact_Jump, data, sampleinfo);
%
%
%         plot(artifact_Jump, 'k', 'linewidth', 1);
%         axis tight; axis square; box off;
%         %set(gca, 'xtick', [10 50 100], 'tickdir', 'out', 'xticklabel', []);
%         title(sprintf('jump removed'));
%     end
%

    %cfgin=cfgin{1}
%end







end
