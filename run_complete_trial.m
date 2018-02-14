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
  %save data preprocessed.
  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/auto_task')
  if isfield(cfgin,'runblock')
    if strcmp(cfgin.restingfile(3),'_')
      savefile= sprintf('P%s_s%s_b%s_preproc_task%s.mat',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8),num2str(cfgin.runblock));
    else
      savefile= sprintf('P%s_s%s_b%s_preproc_task%s.mat',cfgin.restingfile(2:3),cfgin.restingfile(6),cfgin.restingfile(9),num2str(cfgin.runblock));
    end
  end
  save(savefile,'data')
  %run_dfa(cfgin,data)
end

end
