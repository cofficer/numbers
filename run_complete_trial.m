function run_complete_trial(cfgin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Modified 6th Feb 2018.
%Specialized to running automatic preprocessing without saving any data.
%Call preprocessing, ICA, cohICA and lastly DFA, at the same time.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iblock = 1:3
  cfgin.runblock = iblock;
  data=taskPreprocNumbers(cfgin);
  comp=runIcaNumbers(cfgin,data);
  data=run_coherenceICA(cfgin,data,comp)
  run_dfa(cfgin,data)
end

end
