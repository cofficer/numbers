%Script wrapped around running EDF file conversion. Could be implemented into parallel exec.

subjAll = 44:45;

for isub = 1:length(subjAll)

  if subjAll(isub)>9
    subj = sprintf('0%d',subjAll(isub))
  else
    subj = sprintf('00%d',subjAll(isub))
  end

%Run the funciton of edf conversion
convertEDF(subj)

end
