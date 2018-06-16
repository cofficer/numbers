%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Main script for running preprocessing and independent component analysis.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% clear all
%%
%Change the folder to where eyelink data is contained
% cd('/home/chrisgahn/Documents/MATLAB/ktsetsos/resting/eyedat/')
mainDir = '/mnt/homes/home024/chrisgahn/Documents/MATLAB/Lissajous/code';
cd(mainDir)
startup_liss

blocktype = 'trial'; %trial or resting

if strcmp(blocktype,'resting')
  cd('/home/ktsetsos/resting')
  restingpaths  = dir('*S*.mat');
elseif strcmp(blocktype,'trial')
  cd('/home/ktsetsos/preproc3')
  restingpaths  = dir('*.mat');
end

%Sort the sessions and id in correct order.

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
for icfg = 101:length(restingpaths)%20%84 %beein pre 16/11-17.%21:104 Running.

  %If append all of the same session data restingpaths(1:4)
  %Then reduce number of cfgin to one per session.
  % restingpaths(167)
  if dfa_append

    ib=diff(sid)

    cfgin{sid}.blocks{ib}=restingpaths{icfg};

  else
    cfgin{idx_cfg}.restingfile             = restingpaths{icfg};%40 100. test 232, issues.
    cfgin{idx_cfg}.comp                    ='auto'; %decide load manual components or auto = manual/automatic
    namecfg{idx_cfg} = restingpaths{icfg};
    %cfgin=cfgin{1}
    cfgin{idx_cfg}.blocktype                = blocktype; %trial or resting
    idx_cfg = idx_cfg + 1;

  end
  % if restingpaths(icfg).name(7) ~= '1' P01_S2_P3.mat
  %     restingpaths(icfg).name(7) = '3';
  % end
  %idxn=[167,170]
  %cfgin={cfgin{idxn}}
  %idxna=1:length(cfgin)
  %idxna(idxn)=[];


end
%Define script to run and whether to run on the torque
runcfg.execute          = 'freq'; %dfa , preprocTrial, parallel, findsquid, check_nSensors, ICA, cohICA
                                 %complete_trial,complete_rest
%dfa
runcfg.timreq           =  2000; % number of minutes.
runcfg.parallel         = 'torque'; %local or torque

%parallel, ICA, cohICA, dfa.

cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial')

run_parallel_Numbers(runcfg, cfgin)
