function run_dfa(cfgin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Run Tom Pfeffer's implementation of DFA analysis, on restin
%and trial based data
%Created 2017-11-28
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%load clean data
if strcmp(cfgin.restingfile(3),'_')
  dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/cleaned/P0%s_s%s_b%s.mat',cfgin.blocktype,cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
  savefile= sprintf('P0%s_s%s_b%s.mat',cfgin.restingfile(2:3),cfgin.restingfile(6),cfgin.restingfile(9));
else
  dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/cleaned/P%s_s%s_b%s.mat',cfgin.blocktype,cfgin.restingfile(2:3),cfgin.restingfile(6),cfgin.restingfile(9));
  savefile= sprintf('P%s_s%s_b%s.mat',cfgin.restingfile(2:3),cfgin.restingfile(6),cfgin.restingfile(9));
end

load(dsfile)

%Define bandpass intervals
intervals = [2 4;4 8;8 12;12 24];

for i_val = 1:length(intervals)

  %bandpass filter signal
  cfg =[];
  cfg.bpfreq = intervals(i_val,:);
  cfg.bpfilttype='but';
  cfg.channel = 'MEG';
  dataBP=ft_preprocessing(cfg,data);

  %compute the amplitude envelope
  dataBP.trial{1}=abs(hilbert(dataBP.trial{1}));
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
  dfa = tp_dfa(dataBP.trial{1}',win,Fs,overlap,binnum)

  dfa_all{i_val}=dfa;

end

cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/DFA')

save(savefile,'dfa_all')


%TODO: Check the number of components removed from each participant.
%TODO: Figure out best way of storage.
%TODO: Decide on loops, need to compute for each freq band. Maybe cluster is
%better after all.





end
