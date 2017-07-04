function appendEyelinkMEG(~)
%Input save .mat files at 1200Hz
%There is an important consideraration about the length of each eyelinkfile
%So lets have a look.


%General paths
eyelinkpath = '/home/chrisgahn/Documents/MATLAB/ktsetsos/resting/eyedat/';
megpath     = '/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/raw/';
currpath    = '/home/chrisgahn/Documents/MATLAB/ktsetsos/code/numbers/';

%Fieldtrip paths
%addpath '/home/chrisgahn/Documents/MATLAB/fieldtrip-20170528/'  % tell Matlab where FieldTrip is
%ft_defaults

%Store filenames
cd(eyelinkpath)
alleyes     = dir('*.mat');
%remove the 30's because they have already had the eyelink channels added.
%[allNeweyes]=setdiff({alleyes.name},{eyes_30s.name})

%figure(1),clf
%loop all eyelink files
for ieye = 110:length(alleyes)

  %load the eyelink file
  dat_eye         = load(alleyes(ieye).name);
  fprintf('Eyelink asc %s\n',alleyes(ieye).name)

  %save the variance for comparison
  %eyelink_var(ieye) = var(dat_eye.asc.trial{1}(4,:));
  if alleyes(ieye).name(7)=='1'
    continue
  else
    alleyes(ieye).name(7) ='3';
  end

  %load the MEG data
  dat_megname      = sprintf('%s%s_S%s_P%s.mat',megpath,alleyes(ieye).name(2:3),alleyes(ieye).name(5),alleyes(ieye).name(7));

  %Need to understand why this is sometimes the case...
  %if ~exist(dat_megname)
  %  continue
  %end


  %I really need to know which files have the combined_dat and which only have data...

  %Load the meg data.
  dat_meg          = load(dat_megname);


  %Insert the eyelink channels in the MEG data
  %Consideration: Need to figure out the most appropriate way to combine the two datasets.
  %Naming: UADC004 already excists, so I will extend the convention to UADC009, but this is not possible unless the lengths are identical. The only solution might be to interpolate the eyelink data. This can be checked against the eyelink data which has been simulaneously collected.

  % method = 'linear' %Unsure of the most appropriate interp method.
  %x, is the sample index. v, are the corresponding values. xq, is the queried points.
  % x = dat_eye.asc.time{1}-301;%Is this reasonable? I can either stretch the existing or ignore the last part...
  % vq = interp1(x,v,xq,method)


  %Plot the overlap between the MEG eyelink and the upsampled data. Actually difficult.
  %Looks like all the eyelink files are identical
  %cfg         = [];
  %cfg.channel = {'UADC004','UADC003'};
  %channel     = ft_channelselection(cfg.channel, dat_meg.data.label)
  %meg_eyelink = ft_selectdata(cfg, dat_meg.data)

  %Function to compute covariance between edf eyelink and meg eyelink
  %[UADChan,]=identify_MegEyelinkChan(meg_eyelink,dat_eye);
  %UADChan = cfg.channel(UADChan);


  %Pupil dilation
  %Store each label as its own variable
  for it_eye = 1:5

    %Extract and equalize the length of data.
    eye_Chans                    = dat_eye.asc.trial{1}(it_eye,:);
    eyelink_Scale{1}(it_eye,:)     = [ones(1,length(dat_meg.data.time{1})-length(eye_Chans)),eye_Chans];

  end

  %change the eyelink dataset to the new trial and time
  dat_eye.asc.time               = dat_meg.data.time;
  dat_eye.asc.trial = eyelink_Scale;

  %Save the new MEG files
  cfg = [];
  combined_dat=ft_appenddata(cfg,dat_meg.data,dat_eye.asc);
  save(dat_megname,'combined_dat')

end

%figure(1),clf
%for ip = 1:5
%  subplot(3,2,ip)
%  plot(dat.asc.trial{1}(ip,:))
%end
%saveas(gca,'testin.png','png')


end
