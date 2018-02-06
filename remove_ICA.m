function data=remove_ICA(varargin)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %2017-09-27. Input: the identified components to reject.
  %
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  cfgin=varargin{1};
  comp_idx=varargin{2};

  % remove the bad components and backproject the data
  cfg = [];
  cfg.component = comp_idx;%[9 10 14 24]; % to be removed component(s)
  cfg.channel= {'MEG'};

  %define ds file, this is actually from the trial-based data
  if strcmp(cfgin.blocktype,'trial')

    if strcmp(cfgin.restingfile(3),'_')
      dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed/P0%s/preprocs%s_b%s.mat',...
      cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
    else
      dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed/P%s/preprocs%s_b%s.mat',...
      cfgin.restingfile(2:3),cfgin.restingfile(6),cfgin.restingfile(9));
    end

  elseif strcmp(cfgin.blocktype,'resting')
    if strcmp(cfgin.restingfile(1),'0')
      dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P0%s/preprocS%s_P%s.mat',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
    else
      dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P%s/preprocS%s_P%s.mat',cfgin.restingfile(1:2),cfgin.restingfile(5),cfgin.restingfile(8));
    end
  end

  if isfield(cfgin,'runblock')
    data=varargin{3};
  else
    load(dsfile)
  end
  %load the previously computed ICA components

  %define ds file, this is actually from the trial-based data
  if isfield(cfgin,'runblock')
    comp=varargin{4};
  else
    if strcmp(cfgin.blocktype,'trial')

      if strcmp(cfgin.restingfile(3),'_')
        load(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed/P0%s/compS%s_B%s.mat',...
        cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8)));

      else
        load(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/preprocessed/P%s/compS%s_B%s.mat',...
        cfgin.restingfile(2:3),cfgin.restingfile(6),cfgin.restingfile(9)));
      end
    elseif strcmp(cfgin.blocktype,'resting')
      if strcmp(cfgin.restingfile(1),'0')
        load(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P0%s/compS%s_P%s.mat',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8)));
      else
        load(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P%s/compS%s_P%s.mat',cfgin.restingfile(1:2),cfgin.restingfile(5),cfgin.restingfile(8)));
      end
    end
  end


  %clean and save
  cfg=[];
  cfg.channel='MEG';
  data=ft_selectdata(cfg,data);
  
  data = ft_rejectcomponent(cfg, comp, data)
  if ~isfield(cfgin,'runblock')
    if strcmp(cfgin.blocktype,'trial')
      dataname=sprintf('P%s',cfgin.restingfile(2:end))
    else
      dataname=sprintf('P%s',cfgin.restingfile(1:end))
    end
    cd(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/cleaned/',cfgin.blocktype))
    save(dataname,'data','comp_idx')
  end



end
