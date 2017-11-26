function remove_ICA(cfgin,comp_idx)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2017-09-27. Input: the identified components to reject.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% remove the bad components and backproject the data
cfg = [];
cfg.component = comp_idx;%[9 10 14 24]; % to be removed component(s)


%define ds file, this is actually from the trial-based data
dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/preprocessed/P%s/preprocS%s_P%s.mat'...
    ,cfgin.blocktype,cfgin.restingfile(2:3),cfgin.restingfile(5),cfgin.restingfile(7));

load(dsfile)

%load the previously computed ICA components
load(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/preprocessed/P%s/compS%s_P%s.mat',...
cfgin.blocktype,cfgin.restingfile(2:3),cfgin.restingfile(5),cfgin.restingfile(7)))

%clean and save

data = ft_rejectcomponent(cfg, comp, data)

dataname=sprintf('P%s',cfgin.restingfile(2:end))

cd(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/cleaned/',cfgin.blocktype))

save(dataname,'data','comp_idx')




end
