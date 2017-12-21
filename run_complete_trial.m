function run_complete_trial(cfgin)
%Call preprocessing, ICA, cohICA and lastly DFA, at the same time.

taskPreprocNumbers(cfgin)
runIcaNumbers(cfgin)
run_coherenceICA(cfgin)
run_dfa(cfgin)


end
