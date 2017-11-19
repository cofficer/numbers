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
    'memreq', 1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');

  case 'ICA'

    nnodes = 1;%64; % how many licenses?
    stack = 1;%round(length(cfg1)/nnodes);
    qsubcellfun(@runIcaNumbers, cfgin, 'compile', 'no', ...
    'memreq', 1024^3, 'timreq', runcfg.timreq*60, 'stack', stack, 'StopOnError', false, 'backend', runcfg.parallel,'matlabcmd','matlab91');

  case 'cohICA'

    %component for blinks
    [val_corBlink,idx_corBlink] = coherenceICA(cfgin,'EEG058');
    %component for heart rate
    [val_corHR,idx_corHR] = coherenceICA(cfgin,'EEG059');
    %cellfun(@createFullMatrix, cfg1, outputfile);
    %get the comp_idx for all correlation >0.52. TODO: decide on threshold.
    comp_idx1= idx_corBlink(val_corBlink>0.52)';
    comp_idx2= idx_corHR(val_corHR>0.52);

    if isempty(comp_idx1) & ~isempty(comp_idx2)
      comp_idx=comp_idx2;
    elseif isempty(comp_idx2) & ~isempty(comp_idx1)
      comp_idx=comp_idx2;
    elseif isempty(comp_idx2) && isempty(comp_idx1)
      comp_idx = [];
    else
      comp_idx = [comp_idx1;comp_idx2]';

    end
    comp_idx=unique(comp_idx);

    disp(sprintf('\n\nIdentified components: %s',num2str(comp_idx)))
    add_comps=1
    if add_comps
      resp_add = input('\nChange components? 1-add, 2-remove 3-same \n\n ','s')

      switch resp_add
      case '1'
        while strcmp(resp_add,'1')
          disp(sprintf('\n\nIdentified components: %s',num2str(comp_idx)))
          comp_idx(end+1) = input('Extra components: ')
          resp_add = input('\nChange components? 1-add, 2-remove 3-same \n\n ','s')
        end
      case '2'
        while strcmp(resp_add,'2')
          disp(sprintf('\n\nIdentified components: %s',num2str(comp_idx)))
          comp_idx_rem = input('Index remove: ');
          comp_idx(comp_idx_rem)=[];
          resp_add = input('\nChange components? 1-add, 2-remove 3-same \n\n ','s')
        end
      end
    end
    remove_ICA(cfgin,comp_idx)
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



  end



end
