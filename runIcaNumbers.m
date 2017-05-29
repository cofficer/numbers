function [ output_args ] = runIcaNumbers( input_args )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% =========================================================================
% INDEPENDENT COMPONENT ANALYSIS
% =========================================================================
% pconn_preproc_ica

%restoredefaultpath

%load the preproc data.
load('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P20/preprocS2_P3.mat')

%load the raw data:
%dsfile = '/mnt/homes/home024/ktsetsos/resting/01_S2_P1.mat';

%load(dsfile)
%%
% -----------------------------------------------------
% ICA SETTINGS
% -----------------------------------------------------
cfg = [];


cfg.channel = 'MEG';
%cfg.numcomponent = numOfIC(1);
%cfg.numcomponent = numOfIC(2);
%selec only the MEG channls
dataMEG=ft_selectdata(cfg,data);

%run the ica
comp = ft_componentanalysis(cfg,dataMEG);
save('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P20/comp01S2P1.mat','comp')
%load('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/comp01S2P1.mat')
%Stop the function here and save the output of the ft_componentanalysis
%%

% 
% % here, you might want to plot the topography and timecourse
% cfg = [];
% cfg.viewmode = 'component';
% %cfg.component = compidx(1);
% cfg.layout = 'CTF275.lay';
% cfg.style = 'straight';
% ft_databrowser(cfg, comp);
% 
% %%
% cfg.path            ='/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/';
% cfg.prefix          ='S2_P1';
% 
% ft_icabrowser(cfg,comp)
% 
% % project those out of the data
% cfg = [];
% cfg.component = idx;
% data = ft_rejectcomponent(cfg, comp, data);
% 
% 
% 
% %plot timecourse of component of interest
% cfg3                 =[];
% cfg3.path            ='/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P20';
% cfg3.prefix          ='S2_P1';
% %cfg3.component       = 15;
% cfg3.comment         = 'no';
% cfg3.layout          = 'CTF275.lay';
% cfg3.viewmode        = 'component';
% ft_icabrowser(cfg3,comp)

%save([outdir sprintf('pconn_preproc_ica_s%d_m%d_b%d_v%d.mat',isubj,m,iblock,v_out)],'comp_low','comp_hi','-v7.3')



end

