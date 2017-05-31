function run_parallel_Numbers(runcfg, cfgin)
%Run diffeent kinds of scripts on the torque, defined by runcfg for type
%and define by cfgin for each job.


switch runcfg.execute
   
    
    case 'preproc'
        %restingPreprocNumbers(cfgin{1})
        cellfun(@restingPreprocNumbers, cfgin);
        
        
    case 'ICA'
        
        nnodes = 1;%64; % how many licenses?
        stack = 1;%round(length(cfg1)/nnodes);
        qsubcellfun(@runIcaNumbers, cfgin, 'compile', 'no', ...
            'memreq', 1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');
        
    case 'cohICA'
        
        %component for blinks
        [val_corBlink,idx_corBlink] = coherenceICA(cfgin{1},'UADC004');
        %component for heart rate
        [val_corHR,idx_corHR] = coherenceICA(cfgin{1},'EEG059');
        %cellfun(@createFullMatrix, cfg1, outputfile);    
        
        %Decide where to save the component to reject information, 
        %or remove them directly and finish the preprocessing.
    case 'parallel'
        nnodes = 1;%64; % how many licenses?
        stack = 1;%round(length(cfg1)/nnodes);
        qsubcellfun(@restingPreprocNumbers, cfgin, 'compile', 'no', ...
            'memreq', 1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');
%         jobidarray = {};
%         for ic=1:length(cfgin)
%             jobidarray{ic} = qsubfeval(@restingPreprocNumbers, cfgin{ic},...
%                 'compile','no','memreq', 1024^3, 'timreq', runcfg.timreq*60, 'stack',...
%             stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab85', 'UniformOutput', false);
%         end
       % cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting')
        %save jobidarray.mat jobidarray
        %exit

end



end

