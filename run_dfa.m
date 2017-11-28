function run_dfa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Run Tom Pfeffer's implementation of DFA analysis, on restin
%and trial based data
%Created 2017-11-28
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%test case
%load clean data
load('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/cleaned/P21_s1_b2.mat')

%bandpass filter signal
cfg =[]
cfg.bpfreq = [8 12];
cfg.bpfilttype='but';
data=ft_preprocessing(cfg,data);

%compute the amplitude envelope
data.trial{1}=abs(hilbert(data.trial{1}));
%Compute DFA
% Uses the following inputs:
% x:        signal to be analyzed
% win:      length of fitting window in seconds (default: [1 50])
% Fs:       sampling rate
% overlap:  overlap of windows (default: 0.5)
% binnum:   number of time bins for fitting (default: 10)
win = [1 50];
Fs  = 500;
overlap = 0.5;
binnum = 10;
dfa = tp_dfa(data.trial{1},win,Fs,overlap,binnum)








end
