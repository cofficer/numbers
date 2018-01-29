
function check_ICA_components(cfgin)
%Load each cleaned dataset and check the number of components chosen.
%If the number is unreasonable, go in manually.


clear all

%do resting or trial, change cd path
cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/cleaned')


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


files_name={files(num_comps>7).name}

    % trial sessions with way too many components selected.
    % 'P17_s3_b3.mat','P20_s2_b3.mat','P33_s2_b3.mat','P33_s3_b1.mat',...
    % 'P40_s2_b1.mat','P5_s3_b2.mat','P7_s2_b2.mat', 'P7_s2_b3.mat'

end
