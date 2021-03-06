function convertEDF(subj,block_type)
  % Convert from Eyelink .edf files to .asc files using edf2asc converter
  % Subj input need to be a number between 001 and 045.
  loadpath = '/home/chrisgahn/Documents/MATLAB/ktsetsos/code/numbers/';
  savepath = '/home/chrisgahn/Documents/MATLAB/ktsetsos/trial/eyedat/';

  edfpath = '/home/chrisgahn/Documents/MATLAB/ktsetsos/eye_chris/';

  %addpath D:\Experiments\Surprise_accumulation\Analysis\Pupil
  % addpath('/home/chrisgahn/Documents/MATLAB/fieldtrip-20170528/')  % tell Matlab where FieldTrip is
  % ft_defaults

  %subj = 'DHB';
  sess = [1 2 3];

  % Loop through individual files
  for s = 1:length(sess);

    if strcmp(block_type,'task')
      b_length = 3;
    else
      b_length = 2; % 10 and 20 represent the first and last resting block
    end

    %b iterates over the block recording.
    for b = 1:b_length;

      %Define the edf behavioral block per recording
      if strcmp(block_type,'task')
        switch b
        case 1
          nblocks = [1 7 2];
        case 2
          nblocks = [3 8 4];
        case 3
          nblocks = [5 9 6];
        end
      else
        nblocks = [10 20]; % 10 and 20 represent the first and last resting block
      end

      fprintf('Subj %s, session %d, block %d \n',subj,s,b)

      % Change to folder containing all edfs
      cd(edfpath)

      % Find folder name with subj number and session
      folder_subj = dir(sprintf('%s*',subj));
      folder_subj = sprintf('%s/%d/',folder_subj.name,sess(s));

      % Change to edf file folder to identify correct file
      cd([edfpath,'/',folder_subj])

      % Find edf file for current behavioral block.
      % TODO: iterate over nblocks. belonging to current recording b.
      for i_behav = 1:length(nblocks)
        edf_name = dir(sprintf('*%d.edf',nblocks(i_behav)));
        edf_name = edf_name.name

        % Define file names
        edfFile = [edfpath,folder_subj ,edf_name];
        ascFile = [edfpath,folder_subj ,edf_name(1:end-4),'.asc'];
        %             edfFile = [loadpath,subj,'\Training\Eyetracking\',subj,'_',num2str(s),'_',num2str(b),'.edf'];
        %             ascFile = [loadpath,subj,'\Training\Eyetracking\',subj,'_',num2str(s),'_',num2str(b),'.asc'];
        matFile = [savepath,subj,'_',num2str(sess(s)),'_',num2str(b),'.mat'];

        % edf2asc
        if ~exist(ascFile)
          system(sprintf('%s %s -failsafe -input', [loadpath,'edf2asc-linux'], edfFile));
          assert(exist(ascFile, 'file') > 1, 'Edf not properly converted...');  % check that asc has actually been created
          % else
          % delete(ascFile)
          % system(sprintf('%s %s -failsafe -input', [loadpath,'edf2asc-linux'], edfFile));
          % assert(exist(ascFile, 'file') > 1, 'Edf not properly converted...');  % check that asc has actually been created
        end
        %Fairly sure that only 1/three blocks are being saved currently.
        %Need too loop append somehow to create the same three trial
        %structure.
        %

        % Read the asc file into matlab & save
        %if ~exist(matFile
        asc = read_eyelink(ascFile);

        ascTotalTrials.trial{i_behav} = asc.trial{1};
        ascTotalTrials.time{i_behav} = asc.time{1};
      end
      asc=ascTotalTrials;
      save(matFile,'asc')
      %end
    end
  end
end
