%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Main script for running preprocessing and independent component analysis.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
clear all
%%
%Change the folder to where eyelink data is contained
% cd('/home/chrisgahn/Documents/MATLAB/ktsetsos/resting/eyedat/')
cd('/home/ktsetsos/preproc3')

%Sort the sessions and id in correct order.
restingpaths  = dir('*.mat');
restingpaths  = {restingpaths.name};
sort_sessions = cellfun(@(x) x(2:3),restingpaths,'UniformOutput',false)
sort_sessions = strtok( sort_sessions, '_' );
sort_sessions = cellfun(@str2num,sort_sessions);
[~,idx_sort]  = sort(sort_sessions);
restingpaths  = restingpaths(idx_sort);


%Loop all data files into seperate jobs
idx_cfg = 1;
for icfg = 1:20%84 %beein pre 16/11-17. length(restingpaths)

    % if restingpaths(icfg).name(7) ~= '1'
    %     restingpaths(icfg).name(7) = '3';
    % end
      cfgin{idx_cfg}.restingfile             = restingpaths{icfg};%40 100. test 232, issues.
      %cfgin=cfgin{6}
      cfgin{idx_cfg}.blocktype                = 'trial'; %trial or resting
      idx_cfg = idx_cfg + 1;

end

%Define script to run and whether to run on the torque
runcfg.execute          = 'ICA'; %preproc, parallel, findsquid, check_nSensors, ICA
runcfg.timreq           =  2000; % number of minutes.
runcfg.parallel         = 'torque'; %local or torque


cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial')

run_parallel_Numbers(runcfg, cfgin)



%84 - manual rest fully autom. 108 crash
%150, preproc missing.
%157, preproc missing
% for icfg2 = 1:length(restingpaths)
% %Execute jobs on the torque
% run_parallel_Numbers(runcfg, cfgin{icfg2})
% end



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
