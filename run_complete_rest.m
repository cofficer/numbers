function run_complete_rest(cfgin)
%Call preprocessing, ICA, cohICA and lastly DFA, at the same time.

restingPreprocNumbers(cfgin)
runIcaNumbers(cfgin)
run_coherenceICA(cfgin)
run_dfa(cfgin)


end
