
%Startup settings:

%Set paths
warning off

whichFieldtrip = 'git';%'2017-2';


if strcmp(whichFieldtrip,'git')


      % addpath(genpath('/mnt/homes/home024/chrisgahn/Documents/MATLAB/code/'))
      addpath('/Users/Christoffer/Documents/MATLAB/')
      addpath('/Users/Christoffer/Documents/MATLAB/fieldtrip')
      addpath('/Users/Christoffer/Documents/MATLAB/gramm')
      addpath('/Users/Christoffer/Documents/MATLAB/cbrewer/cbrewer/cbrewer')

      ft_defaults


end
ft_hastoolbox('brewermap', 1);

%Set graphs:
set(0,'DefaultAxesColorOrder',cbrewer('qual','Set2',8))
set(0,'DefaultLineLineWidth',1.2)
set(0,'DefaultFigureColormap',cbrewer('div','PuOr',64))
