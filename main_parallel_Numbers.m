%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Main script for running preprocessing and independent component analysis.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
clear all
%%
%Change the folder to where eyelink data is contained
% cd('/home/chrisgahn/Documents/MATLAB/ktsetsos/resting/eyedat/')

blocktype = 'resting'; %trial or resting

if strcmp(blocktype,'resting')
  cd('/home/ktsetsos/resting')
elseif strcmp(blocktype,'trial')
  cd('/home/ktsetsos/preproc3')
end

%Sort the sessions and id in correct order.
restingpaths  = dir('*.mat');
restingpaths  = {restingpaths.name};
if strcmp(blocktype,'resting')
  sort_sessions = cellfun(@(x) x(1:2),restingpaths,'UniformOutput',false)

elseif strcmp(blocktype,'trial')
  sort_sessions = cellfun(@(x) x(2:3),restingpaths,'UniformOutput',false)
  sort_sessions = strtok( sort_sessions, '_' );

end

sort_sessions = cellfun(@str2num,sort_sessions);
[sid,idx_sort]  = sort(sort_sessions);
restingpaths  = restingpaths(idx_sort);


%Loop all data files into seperate jobs
dfa_append = 0; %TODO: append the separate trial blocks.
idx_cfg    = 1;
for icfg = 1:length(restingpaths)%20%84 %beein pre 16/11-17.%21:104 Running.

  %If append all of the same session data restingpaths(1:4)
  %Then reduce number of cfgin to one per session.
  if dfa_append

    ib=diff(sid)

    cfgin{sid}.blocks{ib}=restingpaths{icfg};

  else
    cfgin{idx_cfg}.restingfile             = restingpaths{icfg};%40 100. test 232, issues.
    namecfg{idx_cfg} = restingpaths{icfg};
    %cfgin=cfgin{120}
    cfgin{idx_cfg}.blocktype                = blocktype; %trial or resting
    idx_cfg = idx_cfg + 1;

  end
  % if restingpaths(icfg).name(7) ~= '1' P01_S2_P3.mat
  %     restingpaths(icfg).name(7) = '3';
  % end
  %idxn=[9,11,34,36,66,196,209,210]
  %cfgin={cfgin{idxn}}
  %idxna=1:length(cfgin)
  %idxna(idxn)=[];


end
%
% %Select cfgin of interest.
% cfgin_sel = {'p13_s2_b1'} % {'p43_s1','p19_s3','p15_s3'}
% cfgin_sel={'p16_s2'}
% namecfg = cellfun(@(x) x(1:6),namecfg,'UniformOutput',false)
%
%
% for icfgin =1:length(cfgin)
%
%   idx_name(icfgin) = ismember(namecfg(icfgin),cfgin_sel);
%
% end
%cfgin={cfgin{idx_name}}; % cfgin={cfgin{logical(sit)}}

%sit=zeros(1,length(cfgin));sit([2,12,65,66,67])=1;
%cfgin={cfgin{logical(sit)}}

%1 and 6 error ICA

%Define script to run and whether to run on the torque
runcfg.execute          = 'dfa'; %dfa preproc, preprocTrial, parallel, findsquid, check_nSensors, ICA, cohICA
%dfa
runcfg.timreq           =  2000; % number of minutes.
runcfg.parallel         = 'torque'; %local or torque


cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial')

run_parallel_Numbers(runcfg, cfgin)



%84 - manual rest fully autom. 108 crash
%150, preproc missing.
%157, preproc missing '43_S1_P1.mat'    '43_S1_P3.mat'
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
