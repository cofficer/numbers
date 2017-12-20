function cfgin=names_cfgin_data(blocktype)



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
  idx_cfg    = 1;
  for icfg = 1:length(restingpaths)%20%84 %beein pre 16/11-17.%21:104 Running.

      cfgin{idx_cfg}.restingfile             = restingpaths{icfg};%40 100. test 232, issues.
      namecfg{idx_cfg} = restingpaths{icfg};

      cfgin{idx_cfg}.blocktype                = blocktype; %trial or resting
      idx_cfg = idx_cfg + 1;

  end




end
