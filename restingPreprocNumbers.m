function restingPreprocNumbers( cfgin )
%The current code is copied as a first step from lissajous_preproc.m
%This script removes muscle artifacts and jumps from the MEG data and saves
%the remainder, as well as all of the timestamps of all artifacts.

try
%Folder with the resting data
cd('/mnt/homes/home024/ktsetsos/resting')

%The key here is to use the already defined tables for samples when calling
%trialfun function which I should define next. 

%define ds file, this is actually from the trial-based data
dsfile = sprintf('/mnt/homes/home024/ktsetsos/resting/%s',cfgin.restingfile);

load(dsfile)

    addpath(genpath('/mnt/homes/home024/chrisgahn/Documents/MATLAB/code/analysis'))
    addpath('/mnt/homes/home024/chrisgahn/Documents/MATLAB/fieldtrip-20151020/')
    addpath('/mnt/homes/home024/chrisgahn/Documents/MATLAB/fieldtrip-20151020/qsub')
    addpath(genpath('/mnt/homes/home024/chrisgahn/Documents/MATLAB/Lissajous'))
     addpath(genpath('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos'))
    ft_defaults
%%
%From Anne, Donner git example
%Skipping head motion calculation...




% plot a quick power spectrum
% save those cfgs for later plotting
cfgfreq             = [];
cfgfreq.method      = 'mtmfft';
cfgfreq.output      = 'pow';
cfgfreq.taper       = 'hanning';
cfgfreq.channel     = 'MEG';
cfgfreq.foi         = 1:130;
cfgfreq.keeptrials  = 'no';
freq                = ft_freqanalysis(cfgfreq, data);

%plot those data and save for visual inspection
figure('vis','off'),clf
cnt                   = 1;
subplot(2,3,cnt); cnt = cnt + 1;

loglog(freq.freq, freq.powspctrm, 'linewidth', 0.1); hold on;
loglog(freq.freq, mean(freq.powspctrm), 'k', 'linewidth', 1);
axis tight; axis square; box off;
set(gca, 'xtick', [10 50 100], 'tickdir', 'out', 'xticklabel', []);

cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed')

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
cfg.artfctdef.zvalue.channel     = {'EEG057'}; %UADC003

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
cfg.artfctdef.zvalue.cutoff     = 4; % to detect all blinks, be strict
cfg.artfctdef.zvalue.interactive = 'no';
[~, artifact_eog]               = ft_artifact_zvalue(cfg, data);
artifact_eogVertical = artifact_eog; 


cfg                             = [];
cfg.artfctdef.reject            = 'partial';
cfg.artfctdef.eog.artifact      = artifact_eogVertical;

%plot the blink rate vertical??
cfg=[];
cfg.channel = 'EEG057'; % UADC004 if eyelink is present
blinks = ft_selectdata(cfg,data);

%If there is no variance in the data then it is probably because the
%eyelink was not working for that session
% if var(blinks.trial{:})<0.01 %No eyelink
% 	cfg=[];
%     cfg.channel = 'EEG057';
%     blinks = ft_selectdata(cfg,data);
% end
subplot(2,3,cnt); cnt = cnt + 1;
plot(blinks.trial{:})
axis tight; axis square; box off;
title('Blink rate EEG057')
% reject blinks only when they occur between fix and stim offset
%crittoilim = [ data.trialinfo(:,2) - data.trialinfo(:,1) - 0.4*data.fsample ...
%    data.trialinfo(:,5) - data.trialinfo(:,1) + 0.8*data.fsample]  / data.fsample;
%cfg.artfctdef.crittoilim        = crittoilim;
%data                            = ft_rejectartifact(cfg, data);
%%
% ==================================================================
% 3. REMOVE TRIALS WITH SACCADES (only during beginning of trial)
% Remove trials with (horizontal) saccades (EOGH). Use the same settings as 
% for the EOGV-based blinks detection. The z-threshold can be set a bit higher 
% (z = [4 6]). Reject all trials that contain saccades before going further.
% ==================================================================

cfg                              = [];
cfg.continuous                   = 'yes'; % data has been epoched

% channel selection, cutoff and padding
cfg.artfctdef.zvalue.channel     = {'EEG058'}; %UADC004

% 001, 006, 0012 and 0018 are the vertical and horizontal eog chans
cfg.artfctdef.zvalue.trlpadding  = 0; % padding doesnt work for data thats already on disk
cfg.artfctdef.zvalue.fltpadding  = 0; % 0.2; this crashes the artifact func!
cfg.artfctdef.zvalue.artpadding  = 0.05; % go a bit to the sides of blinks

% algorithmic parameters
cfg.artfctdef.zvalue.bpfilter   = 'yes';
cfg.artfctdef.zvalue.bpfilttype = 'but';
cfg.artfctdef.zvalue.bpfreq     = [1 15];
cfg.artfctdef.zvalue.bpfiltord  = 2;
cfg.artfctdef.zvalue.hilbert    = 'yes';

% set cutoff
cfg.artfctdef.zvalue.cutoff     = 4;
 cfg.artfctdef.zvalue.interactive = 'no';
[~, artifact_eog]               = ft_artifact_zvalue(cfg, data);

artifact_eogHorizontal = artifact_eog;

cfg                             = [];
 cfg.artfctdef.reject            = 'partial';
cfg.artfctdef.eog.artifact      = artifact_eogHorizontal;

% reject blinks when they occur between ref and the offset of the stim
%crittoilim = [data.trialinfo(:,2) - data.trialinfo(:,1) - 0.4*data.fsample ...
%    data.trialinfo(:,5) - data.trialinfo(:,1) + 0.8*data.fsample] / data.fsample;
%cfg.artfctdef.crittoilim        = crittoilim;
%data                            = ft_rejectartifact(cfg, data);

%plot the blink rate horizontal??
cfg=[];
cfg.channel = 'EEG058'; % UADC004 if eyelink is present
blinks = ft_selectdata(cfg,data);

%If there is no variance in the data then it is probably because the
%eyelink was not working for that session
% if var(blinks.trial{:})<0.01 %No eyelink
% 	cfg=[];
%     cfg.channel = 'EEG057';
%     blinks = ft_selectdata(cfg,data);
% end
subplot(2,3,cnt); cnt = cnt + 1;
plot(blinks.trial{:})
axis tight; axis square; box off;
title('Blink rate EEG058')

%%
% ==================================================================
% 4. REMOVE TRIALS WITH JUMPS
% Compute the power spectrum of all trials and a linear line on the loglog-
% transformed power spectrum. Jumps cause broad range increase in the power 
% spectrum so trials containing jumps can be selected by detecting outliers 
% in the intercepts of the fitted lines (using Grubb?s test for outliers).
% ==================================================================

% detrend and demean
cfg             = [];
cfg.detrend     = 'yes';
cfg.demean      = 'yes';
data            = ft_preprocessing(cfg, data);

% get the fourier spectrum per trial and sensor
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

% detect jumps as outliers
[~, idx] = deleteoutliers(intercept(:));
subplot(2,3,cnt); cnt = cnt + 1;
if isempty(idx),
    fprintf('no squid jump trials found \n');
    title('No jumps'); axis off;
else
    fprintf('removing %d squid jump trials \n', length(unique(t)));
    [t,~] = ind2sub(size(intercept),idx);
    
    % remove those trials
    cfg                 = [];
    cfg.trials          = true(1, length(data.trial));
    cfg.trials(unique(t)) = false; % remove these trials
    data                = ft_selectdata(cfg, data);
    
    % plot the spectrum again
    cfgfreq.keeptrials = 'no';
    freq            = ft_freqanalysis(cfgfreq, data);
    loglog(freq.freq, freq.powspctrm, 'linewidth', 0.1); hold on;
    loglog(freq.freq, mean(freq.powspctrm), 'k', 'linewidth', 1);
    axis tight; axis square; box off;
    set(gca, 'xtick', [10 50 100], 'tickdir', 'out', 'xticklabel', []);
    title(sprintf('%d jumps removed', length(unique(t))));
end
%%
% ==================================================================
% 5. REMOVE LINE NOISE
% ==================================================================

cfg             = [];
cfg.bsfilter    = 'yes';
cfg.bsfreq      = [49 51; 99 101; 149 151];
data            = ft_preprocessing(cfg, data);

% plot power spectrum
% freq            = ft_freqanalysis(cfgfreq, data);
% subplot(2,3,cnt); cnt = cnt + 1;
% %loglog(freq.freq, freq.powspctrm, 'linewidth', 0.5); hold on;
% loglog(freq.freq, (squeeze(mean(freq.powspctrm))), 'k', 'linewidth', 1);
% axis tight;  axis square; box off;%ylim(ylims);
% title('After bandstop');
% set(gca, 'xtick', [10 50 100], 'tickdir', 'out', 'xticklabel', []);

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

% algorithmic parameters
cfg.artfctdef.zvalue.bpfilter    = 'yes';
cfg.artfctdef.zvalue.bpfreq      = [110 140];
cfg.artfctdef.zvalue.bpfiltord   = 9;
cfg.artfctdef.zvalue.bpfilttype  = 'but';
cfg.artfctdef.zvalue.hilbert     = 'yes';
cfg.artfctdef.zvalue.boxcar      = 0.2;

% set cutoff
cfg.artfctdef.zvalue.cutoff      = 20;
[~, artifact_Muscle]             = ft_artifact_zvalue(cfg, data);

cfg                              = [];
cfg.artfctdef.reject             = 'partial';
cfg.artfctdef.muscle.artifact    = artifact_Muscle;

% only remove muscle bursts before the response
%crittoilim = [data.trialinfo(:,1) - data.trialinfo(:,1) ...
%    data.trialinfo(:,9) - data.trialinfo(:,1)]  ./ data.fsample;
%cfg.artfctdef.crittoilim        = crittoilim;
%data                            = ft_rejectartifact(cfg, data);
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


[ data ] = delete_artifact_Numbers( artifact_Muscle,data );


%%
%Finally resample the data
cfg3.resample = 'yes';
cfg3.fsample = 1200;
cfg3.resamplefs = 500;
cfg3.detrend = 'no';

data = ft_resampledata(cfg3,data);


%%
%Do a highpass filter go get rid of all frequencies below 2Hz
cfg          = [];
cfg.hpfilter = 'yes';
cfg.hpfreq   = 2;
data = ft_preprocessing(cfg,data);

%%
%Change folder and save approapriate data + figures
cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/')

name = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P%s',cfgin.restingfile(1:2));

if 7==exist(name,'dir')
    
    cd(name)
else
    mkdir(name)
    cd(name)
end
%Save the data
filestore=sprintf('preproc%s.mat',dsfile(end-8:end-4));
save(filestore,'data')

%Save the artifacts
artstore=sprintf('artifacts%s.mat',dsfile(end-8:end-4));

save(artstore,'artifact_eogVertical','artifact_eogHorizontal','artifact_Muscle') %Jumpos?

%save the invisible figure
figurestore=sprintf('Overview%s.png',dsfile(end-8:end-4));
saveas(gca,figurestore,'png')

%Catch any error and write into file
catch err
    
    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed')
    fid=fopen('logfile','a+');
    c=clock;
    fprintf(fid,sprintf('\n\n\n\nNew entry for %s at %i/%i/%i %i:%i\n\n\n\n',cfgin.restingfile,fix(c(1)),fix(c(2)),fix(c(3)),fix(c(4)),fix(c(5))))
    
    fprintf(fid,'%s',err.getReport('extended','hyperlinks','off'))
    
    fclose(fid)
    
    
end

cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting')
end

