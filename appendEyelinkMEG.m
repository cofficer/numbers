function [aa]=appendEyelinkMEG(eyelink)
%Input save .mat files at 500Hz
%There is an important consideraration about the length of each eyelinkfile
%So lets have a look.


%General paths
eyelinkpath = '/home/chrisgahn/Documents/MATLAB/ktsetsos/resting/eyedat/';
megpath     = '/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/raw/';

%Store filenames
cd(eyelinkpath)
alleyes     = dir('03*.mat');

%loop all eyelink files
for ieye = 1:length(alleyes)

  %load the eyelink file
  dat_eye         = load(alleyes(ieye).name);
  fprintf('Eyelink asc %s\n',alleyes(ieye).name)

  %Upsample from 500Hz to 1200Hz
  cfg             = [];
  cfg.resamplefs  = 1200;
  dat_eye         = ft_resampledata(cfg,dat_eye);

  %load the MEG data
  dat_megname      = sprintf('%s%s_S%s_P%s.mat',megpath,alleyes(ieye).name(2:3),alleyes(ieye).name(5),alleyes(ieye).name(7))
  dat_meg          = load(dat_megname)

  %Insert the eyelink channels in the MEG data

  %Save the new MEG files


end

%figure(1),clf
%for ip = 1:5
%  subplot(3,2,ip)
%  plot(dat.asc.trial{1}(ip,:))
%end
%saveas(gca,'testin.png','png')

end
