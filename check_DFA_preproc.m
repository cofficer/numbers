
function check_DFA_preproc(~)
%Load all the names of preproc and all the names of DFA
%Output the names of preproc that have not been analyzed.

clear all

%resting-state blocks.
blocktype = 'resting'; %trial or resting
cfgin_rest=names_cfgin_data(blocktype);

cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/DFA')

dfa_rest = dir('*.mat');

missing_rest = length(cfgin_rest)-length(dfa_rest); % 10

dfa_rest = strrep({dfa_rest.name},'B','P');

dfa_rest = cellfun(@(x) x(2:end),dfa_rest,'UniformOutput',false)

%Do a lazy Loop
for ic = 1:length(cfgin_rest)

  cfg_rest{ic}=cfgin_rest{ic}.restingfile;

end

idx_rest_miss = ismember(cfg_rest,dfa_rest);

name_rest_miss = cfg_rest(~idx_rest_miss)



%trial blocks preproc
blocktype = 'trial'; %trial or resting
cfgin_trial=names_cfgin_data(blocktype);

%Do a lazy Loop
for ic = 1:length(cfgin_trial)

  cfg_trial{ic}=cfgin_trial{ic}.restingfile;

end

%trial blocks dfa
cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/DFA')
dfa_trial = dir('*.mat');
dfa_trial = {dfa_trial.name};
dfa_trial = strrep(dfa_trial,'P','p');


missing_trial = length(cfgin_trial)-length(dfa_trial); % 3

idx_trial_miss = ismember(cfg_trial,dfa_trial);

name_trial_miss = cfg_trial(~idx_trial_miss);

%
name_trial_miss
name_rest_miss


'04_S1_P3.mat' %comp 9      % 9 66 39 210
'04_S2_P3.mat' %comp 11
'08_S2_P3.mat' %comp 34
'08_S3_P3.mat' %comp 36
'15_S3_P3.mat' %DFA 66
'39_S3_P2.mat' %DFA 196
'43_S1_P1.mat' %DFA 208
'43_S1_P3.mat' %DFA 209



end
