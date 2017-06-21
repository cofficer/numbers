function [ output_args ] = compEogEylink( nparts )
%compare the accuracy of identified components using eog channels or using
%eyelink channels. Should call the function coherenceICA

clear all

%%
%Change the folder to where MEG data is contained
cd('/mnt/homes/home024/ktsetsos/resting')

%Store all the seperate data files
restingpaths = dir('*.mat');

%Loop all data files into seperate jobs

for icfg = 1:length(restingpaths)

    cfgin{icfg}.restingfile             = restingpaths(icfg).name;%128 works.
    %cfgin=cfgin{1}
end
    

%%
%Compute the variance in the UADC004 channels.
for icfg = 222:length(restingpaths)
    
    dataset = cfgin{icfg}.restingfile;
    %define ds file, this is actually from the trial-based data
    dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P%s/preproc%s'...
        ,dataset(1:2),dataset(4:end));
    
    load(dsfile)
    idx= find(ismember(data.label,'UADC004')==1);

    if var(data.trial{1}(idx,:))<0.01 
    
        restpath_eyelink(icfg) = 0;
    else
        restpath_eyelink(icfg) = 1;
    end
    restpath_eyelinkVar(icfg)=var(data.trial{1}(idx,:));
end

%%
%save workingeyelinkpaths

workingpaths = restingpaths(logical(restpath_eyelink));

%save('workingEyelinkpaths.mat','restpath_eyelink','restpath_eyelinkVar','workingpaths')
load('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/code/numbers/workingEyelinkpaths.mat')

%Non-working paths

idx_nonworking = ~ismember({restingpaths.name},{workingpaths.name});

nonworking = {restingpaths(idx_nonworking).name};


%%
%Check the data of nonworking:

for icfg = 1:length(nonworking)
    
    dataset = nonworking{icfg};
    %define ds file, this is actually from the trial-based data
    dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P%s/preproc%s'...
        ,dataset(1:2),dataset(4:end));
    
    load(dsfile)
    idx= find(ismember(data.label,'UADC004')==1);

    if var(data.trial{1}(idx,:))<0.01 
    
        errorpath_eyelink(icfg) = 0;
    else
        errorpath_eyelink(icfg) = 1;
    end
    errorpath_eyelinkVar(icfg)=var(data.trial{1}(idx,:));
end




%%
%Plot the differences in one plot... 

eye_labels = {'EEG057','EEG058','UADC004','UADC003','UADC002'};

dataset = workingpaths(10).name;

%define ds file, this is actually from the trial-based data
dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P%s/preproc%s'...
    ,dataset(1:2),dataset(4:end));

load(dsfile)

for ilabel = 1:length(eye_labels)
   
    %find the index of current eog or eyelink channel
    idx_eyes(ilabel) = find(ismember(data.label,eye_labels{ilabel})==1);
    
    
end

%plot the blink and saccade data
figure(1),clf
hold on
for iplot = 1:length(eye_labels)
    subplot(3,2,iplot)
    plot(zscore(data.trial{1}(idx_eyes(iplot),:)))
    title(eye_labels{iplot})
end

%saveas(gca,'/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/code/figures/datasetweyelink.png','png')
%%
%Calculate the corelations
%component for blinks, with eog
[val_corBlinkEOG57,idx_corBlinkEOG57] = coherenceICA(cfgin{1}.restingfile,'EEG057');
[val_corBlinkEOG58,idx_corBlinkEOG58] = coherenceICA(cfgin{1}.restingfile,'EEG058');


%component for blinks, with eyelink
[val_corBlinkEylink4,idx_corBlinkEylink4] = coherenceICA(cfgin{1}.restingfile,'UADC004');
[val_corBlinkEylink3,idx_corBlinkEylink3] = coherenceICA(cfgin{1}.restingfile,'UADC003');
[val_corBlinkEylink2,idx_corBlinkEylink2] = coherenceICA(cfgin{1}.restingfile,'UADC002');


%component for heart rate
[val_corHR,idx_corHR] = coherenceICA(cfgin{1},'EEG059');
%cellfun(@createFullMatrix, cfg1, outputfile);






end

