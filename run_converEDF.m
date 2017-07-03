%Script wrapped around running EDF file conversion. Could be implemented into parallel exec.
addpath('/home/chrisgahn/Documents/MATLAB/ktsetsos/code/numbers/')
subjAll = 5:45;

removeSubj = [8,9,15,21,25,30,31,42,43];

subjAll=subjAll(~ismember(subjAll,removeSubj));


for isub = 1:length(subjAll)

  if subjAll(isub)>9
    subj = sprintf('0%d',subjAll(isub))
  else
    subj = sprintf('00%d',subjAll(isub))
  end

  %Run the funciton of edf conversion
  convertEDF(subj)

end
