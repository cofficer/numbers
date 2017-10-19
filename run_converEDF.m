function run_converEDF(subj,block_type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Script wrapped around running EDF file conversion. Could be implemented into parallel exec.
%Edit to accomodate task data as well as resting. Moreover, change to run in
%parallel torque.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%addpath('/home/chrisgahn/Documents/MATLAB/ktsetsos/code/numbers/')
subjAll = 5:45;

removeSubj = [10,15,21,25,42,43]; %Check-up removals... 9 error

subjAll=subjAll(~ismember(subjAll,removeSubj));

%Remove before torque.
block_type = 'task';

%Remove loop before torque
for isub = 1:length(subjAll)
  disp(isub)
  if subjAll(isub)>9
    subj = sprintf('0%d',subjAll(isub))
  else
    subj = sprintf('00%d',subjAll(isub))
  end

  %Run the funciton of edf conversion
  convertEDF(subj,block_type)

end
% errors
% Subj 015, session 3, block 1
% Insufficient number of outputs from right hand side of equal sign to satisfy assignment
% Subj 021, session 3, block 1
% Insufficient number of outputs from right hand side of equal sign to satisfy assignment.
% Error in convertEDF (line 48)
% Subj 025, session 2, block 1
% Insufficient number of outputs from right hand side of equal sign to satisfy assignment.
% Error in convertEDF (line 48)
%         edf_name = edf_name.name;
% Subj 042, session 1, block 1
% Error using cd
% Cannot CD to /home/ktsetsos/eyelink/// (Name is nonexistent or not a directory).
% Subj 043, session 1, block 1
% Insufficient number of outputs from right hand side of equal sign to satisfy assignment.
