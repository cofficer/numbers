
function [ channels ] = check_nSensors(pathfile)
%Load the data and store the number of sensors available.
%Make it possible to run in parallel on the torque

%for testing purposes go into ks directory and grab first dataset
cd('/mnt/homes/home024/ktsetsos/resting')

%
load(pathfile.restingfile)

%Get all the MEG sensors
channels = ft_channelselection({'MEG'}, data.label);

%Create a logfile containing the number of channels per session
cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed')
fid=fopen('logfile_channels','a+');
c=clock;
fprintf(fid,sprintf('\n\nNew entry for %s at %i/%i/%i %i:%i\n\n',data.cfg.dataset,fix(c(1)),fix(c(2)),fix(c(3)),fix(c(4)),fix(c(5))))

fprintf(fid,'Number of channels: %i',length(channels))

fclose(fid)


end
