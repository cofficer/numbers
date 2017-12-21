
function check_ICA_components(cfgin)
%Load each cleaned dataset and check the number of components chosen.
%If the number is unreasonable, go in manually.


clear all

cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/cleaned')


files = dir('*.mat');


%Store all the comp_idx in a struct
for ifile = 1:length(files)
  disp(ifile)
  load(files(ifile).name)
  store_comps{ifile}.comps = comp_idx;
  store_comps{ifile}.ID    = files(ifile).name;

end

for icomps = 1:length(store_comps)

  num_comps(icomps)=length(store_comps{icomps}.comps);

end

end
