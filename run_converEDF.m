function run_converEDF(subj,block_type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Script wrapped around running EDF file conversion. Could be implemented into parallel exec.
%Edit to accomodate task data as well as resting. Moreover, change to run in
%parallel torque.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%addpath('/home/chrisgahn/Documents/MATLAB/ktsetsos/code/numbers/')
subjAll = 5:45;

removeSubj = [8,9,15,21,25,30,31,42,43]; %Check-up removals...

subjAll=subjAll(~ismember(subjAll,removeSubj));

%Remove before torque.
block_typ = 'task';

%Remove loop before torque
for isub = 1:length(subjAll)

  if subjAll(isub)>9
    subj = sprintf('0%d',subjAll(isub))
  else
    subj = sprintf('00%d',subjAll(isub))
  end

  %Run the funciton of edf conversion
  convertEDF(subj,block_type)

end
