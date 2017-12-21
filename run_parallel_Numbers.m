function run_parallel_Numbers(runcfg, cfgin)
  %Run diffeent kinds of scripts on the torque, defined by runcfg for type
  %and define by cfgin for each job.


  switch runcfg.execute


  case 'preprocTrial'
    %restingPreprocNumbers(cfgin{1})
    %cellfun(@restingPreprocNumbers, cfgin);
    nnodes = 1;%64; % how many licenses?
    stack = 1;%round(length(cfg1)/nnodes);
    qsubcellfun(@taskPreprocNumbers, cfgin, 'compile', 'no', ...
    'memreq', 10*1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');

    case 'dfa'

      nnodes = 1;%64; % how many licenses?
      stack = 1;%round(length(cfg1)/nnodes);
      %cellfun(@run_dfa,cfgin,'UniformOutput',false);
      qsubcellfun(@run_dfa, cfgin, 'compile', 'no', ...
      'memreq', 1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');

  case 'ICA'

    nnodes = 1;%64; % how many licenses?
    stack = 1;%round(length(cfg1)/nnodes);
    %cellfun(@runIcaNumbers,cfgin,'UniformOutput',false)
    qsubcellfun(@runIcaNumbers, cfgin, 'compile', 'no', ...
    'memreq', 16*1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');

  case 'cohICA'


    nnodes = 1;%64; % how many licenses?
    stack = 1;%round(length(cfg1)/nnodes);
    qsubcellfun(@run_coherenceICA, cfgin, 'compile', 'no', ...
    'memreq', 16*1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');



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

  case 'findsquid'
    nnodes = 1;%64; % how many licenses?
    stack = 1;%round(length(cfg1)/nnodes);
    qsubcellfun(@findSquidJumps, cfgin, 'compile', 'no', ...
    'memreq', 1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');


  case 'check_nSensors'
    nnodes = 1;%64; % how many licenses?
    stack = 1;%round(length(cfg1)/nnodes);
    qsubcellfun(@check_nSensors, cfgin, 'compile', 'no', ...
    'memreq', 1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');

  case 'complete_trial'
    nnodes = 1;%64; % how many licenses?
    stack = 1;%round(length(cfg1)/nnodes);
    qsubcellfun(@run_complete_trial, cfgin, 'compile', 'no', ...
    'memreq', 1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');

  case 'complete_rest'
    nnodes = 1;%64; % how many licenses?
    stack = 1;%round(length(cfg1)/nnodes);
    qsubcellfun(@run_complete_rest, cfgin, 'compile', 'no', ...
    'memreq', 1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');



  end



end
