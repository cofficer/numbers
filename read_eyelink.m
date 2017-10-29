function asc = read_eyelink(ascFile)
% Purpose to read in asc files and output .mat files in a format downsampled to 500Hz
% Following http://www.fieldtriptoolbox.org/getting_started/eyelink#converting_the_edf_file_to_an_asc_file

%Get the require asc as datastructure
cfg         = [];
cfg.dataset = ascFile;
data_eye    = ft_preprocessing(cfg);

% event_eye = ft_read_event(ascFile);
%
% disp(unique({event_eye.type}))


%Downsample the eyelink data
cfg         = [];
cfg.resamplefs = 1200;
[asc] = ft_resampledata(cfg, data_eye);

end
