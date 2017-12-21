
function check_ICA_components(cfgin)
%Load each cleaned dataset and check the number of components chosen.
%If the number is unreasonable, go in manually.

cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/cleaned')


files = dir('*.mat');

load(files(1).name)

%Store all the comp_idx in a struct
for ifile = 1:length(files)
  load(files(ifile).name)
  store_comps{ifile}.comps = comp_idx;
  store_comps{ifile}.ID    = files(ifile).name;

end

end
