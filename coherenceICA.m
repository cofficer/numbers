function [val_cor,idx_cor] = coherenceICA( dataset,channelRej )
%Using coherence analysis this function will output the channels which
%should be rejected.
%channelRej='UADC004'; %UADC004, % EEG059 Heart.

%define ds file, this is actually from the trial-based data
dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P%s/preproc%s'...
    ,dataset(1:2),dataset(4:end));

load(dsfile)

cfg=[];
cfg.channel = channelRej;
ecg = ft_selectdata(cfg,data);
ecg.label{:} = 'ECG';

% concatenate component activity, small change, test

%%
%select components for heart rate
cfg                       = [];
cfg.trl                   = [1 length(data.trial{1})];
cfg.dataset               = data;
cfg.continuous            = 'yes';
if strcmp(channelRej,'UADC004') || strcmp(channelRej,'EEG057')
    cfg.artfctdef.ecg.pretim  = 0.05;
    cfg.artfctdef.ecg.psttim  = 0.1-1/500;
else
    cfg.artfctdef.ecg.pretim  = 0.15;
    cfg.artfctdef.ecg.psttim  = 0.07-1/500;
end
cfg.channel               = {channelRej};
cfg.artfctdef.ecg.inspect = {channelRej};
cfg.artfctdef.ecg.cutoff  = 1;
cfg.artfctdef.ecg.interactive = 'yes';
[cfg, artifact]           = ft_artifact_ecg(cfg, ecg);

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
ecg.channel{:} = channelRej;

%load the previously computed ICA components
load('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/comp01S2P1.mat')

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

%calculate to average coherence over all frequencies:
[~,idx_coh] = sort(mean(fdcomp.cohspctrm,2));

%Take the  highest correlating component and use as a spatial template to calculate the coherence.
rej_components = idx_coh(end);

%Compute the spatial correlation of artifact and all components
cor_comp_artifact = corr(comp.topo(:,rej_components),comp.topo(:,:));

%Sort in order of spatial correlation
[val_cor,idx_cor] = sort(cor_comp_artifact);



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
