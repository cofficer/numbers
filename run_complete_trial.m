function run_complete_trial(cfgin)
%Call preprocessing, ICA, cohICA and lastly DFA, at the same time.

for iblock = 1:3
  cfgin.runblock = iblock;
  data=taskPreprocNumbers(cfgin);
  comp=runIcaNumbers(cfgin,data);
  data=run_coherenceICA(cfgin,data,comp)
  run_dfa(cfgin,data)
end

end
