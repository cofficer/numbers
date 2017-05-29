%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Main script for running preprocessing and independent component analysis.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
clear all
%%
%Change the folder to where MEG data is contained
cd('/mnt/homes/home024/ktsetsos/resting')

%Store all the seperate data files
restingpaths = dir('*.mat');

%Loop all data files into seperate jobs

for icfg = 1:1%length(restingpaths)

    cfgin{icfg}.restingfile             = restingpaths(20).name;%40 100
    %cfgin=cfgin{1}
end
    

%Define script to run and whether to run on the torque
runcfg.execute = 'parallel'; %preproc, parallel
runcfg.timreq          = 2000; % number of minutes. 
runcfg.parallel         ='torque';

cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting')

switch runcfg.execute
   
    
    case 'preproc'
        %restingPreprocNumbers(cfgin{1})
        cellfun(@restingPreprocNumbers, cfgin);
        
        
    case 'ICA'
        restingPreprocNumbers(cfgin{1})
        %cellfun(@createFullMatrix, cfg1, outputfile);    
        
    case 'cohICA'
        
        [rej_components]=coherenceICA(cfgin{1}.restingfile,'EEG059');
        %cellfun(@createFullMatrix, cfg1, outputfile);    

    case 'parallel'
        nnodes = 1;%64; % how many licenses?
        stack = 1;%round(length(cfg1)/nnodes);
        qsubcellfun(@restingPreprocNumbers, cfgin, 'compile', 'no', ...
            'memreq', 1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');
end





%%



