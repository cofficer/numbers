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

  %load the MEG data
  dat_megname      = sprintf('%s%s_S%s_P%s.mat',megpath,alleyes(ieye).name(2:3),alleyes(ieye).name(5),alleyes(ieye).name(7));
  dat_meg          = load(dat_megname)

  %Insert the eyelink channels in the MEG data
  %Consideration: Need to figure out the most appropriate way to combine the two datasets.
  %Naming: UADC004 already excists, so I will extend the convention to UADC009, but this is not possible unless the lengths are identical. The only solution might be to interpolate the eyelink data. This can be checked against the eyelink data which has been simulaneously collected.

  method = 'linear' %Unsure of the most appropriate interp method.
  %x, is the sample index. v, are the corresponding values. xq, is the queried points.
  x = dat_eye.asc.time{1}-301;%Is this reasonable? I can either stretch the existing or ignore the last part...
  vq = interp1(x,v,xq,method)


  %Plot the overlap between the MEG eyelink and the upsampled data.
  %Save the new MEG files


end

%figure(1),clf
%for ip = 1:5
%  subplot(3,2,ip)
%  plot(dat.asc.trial{1}(ip,:))
%end
%saveas(gca,'testin.png','png')

end
