%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Main script for running preprocessing and independent component analysis.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
clear all
%%
%Change the folder to where eyelink data is contained
cd('/home/chrisgahn/Documents/MATLAB/ktsetsos/resting/eyedat/')

%Store all the seperate data files
restingpaths = dir('*.mat');

%Loop all data files into seperate jobs
idx_cfg = 1;
for icfg = 1:length(restingpaths)

    if restingpaths(icfg).name(7) ~= '1'
        restingpaths(icfg).name(7) = '3';
    end
      cfgin{icfg}.restingfile             = restingpaths(icfg).name;%40 100. test 232, issues.
      %cfgin=cfgin{110}
      %idx_cfg = idx_cfg + 1;

end

%Define script to run and whether to run on the torque
runcfg.execute = 'preproc'; %preproc, parallel, findsquid, check_nSensors, ICA
runcfg.timreq          = 2000; % number of minutes.
runcfg.parallel         ='torque'; %local or torque

cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting')

%84 - manual rest fully autom. 108 crash
%150, preproc missing.
%157, preproc missing
% for icfg2 = 1:length(restingpaths)
% %Execute jobs on the torque
% run_parallel_Numbers(runcfg, cfgin{icfg2})
% end


run_parallel_Numbers(runcfg, cfgin)


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Cell for execuing ICA analysis and saving all the resulting components.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%read all the names of resting datasets
%cd('/mnt/homes/home024/ktsetsos/resting')

%Store all the seperate data files
%restingpaths = dir('*.mat');


%Read csv of all paticipants to avoid
%cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed')
%fid = fopen('participantsNoEyelink.csv');
%C = textscan(fid, '%s');
%fclose(fid);

%define the script to run.
%runcfg.execute = 'ICA';
%runcfg.timreq          = 2000; % number of minutes.
%runcfg.parallel         ='torque';


%Datasets which contain eyelink ata and has been properly preprocessed
%dataEyelink = setdiff({restingpaths.name},C{1});

%for icfg = 1:length(dataEyelink)
%    cfgin{icfg}             = dataEyelink{icfg};%40 100. test 232, issues.
%end


%Execute jobs on the torque
%run_parallel_Numbers(runcfg, cfgin)


%%
%Run the script coherenceICA to compute the components which are the most
%likely to contain both heart rate and blinks.


%read all the names of resting datasets
%cd('/mnt/homes/home024/ktsetsos/resting')

%Store all the seperate data files
%restingpaths = dir('*.mat');


%Read csv of all paticipants to avoid
%cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed')
%fid = fopen('participantsNoEyelink.csv');
%C = textscan(fid, '%s');
%fclose(fid);

%define the script to run.
%runcfg.execute = 'cohICA';
%runcfg.timreq          = 2000; % number of minutes.
%runcfg.parallel         ='torque';


%Datasets which contain eyelink ata and has been properly preprocessed
%dataEyelink = setdiff({restingpaths.name},C{1});

%for icfg = 1:1%length(dataEyelink)
%    cfgin{icfg}             = dataEyelink{100};%40 100. test 232, issues.
%end


%Execute jobs on the torque
%run_parallel_Numbers(runcfg, cfgin)





%%
%Remove the components
