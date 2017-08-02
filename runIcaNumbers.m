function [ output_args ] = runIcaNumbers( cfgin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% =========================================================================
% INDEPENDENT COMPONENT ANALYSIS
% =========================================================================
% pconn_preproc_ica

%restoredefaultpath
try
cd(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/P%s',cfgin.restingfile(2:3)))

%load the preproc data.
if cfgin.restingfile(7)==2
  load(sprintf('preprocS%s_P3.mat',cfgin.restingfile(5)))
  savefile = sprintf('compS%s_P3.mat',cfgin.restingfile(5));
else
  load(sprintf('preprocS%s_P1.mat',cfgin.restingfile(5)))
  savefile = sprintf('compS%s_P1.mat',cfgin.restingfile(5));
end

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
data=ft_selectdata(cfg,data);

%run the ica
comp = ft_componentanalysis(cfg,data);
save(savefile,'comp')

catch err

    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed')
    fid=fopen('logfileICA','a+');
    c=clock;
    fprintf(fid,sprintf('\n\n\n\nNew entry for %s at %i/%i/%i %i:%i\n\n\n\n',cfgin,fix(c(1)),fix(c(2)),fix(c(3)),fix(c(4)),fix(c(5))))

    fprintf(fid,'%s',err.getReport('extended','hyperlinks','off'))

    fclose(fid)

end

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
% cfg3.path            ='/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/preprocessed/';
% cfg3.prefix          ='S2_P1';
% %cfg3.component       = 15;
% cfg3.comment         = 'no';
% cfg3.layout          = 'CTF275.lay';
% cfg3.viewmode        = 'component';
% ft_icabrowser(cfg3,comp)

%save([outdir sprintf('pconn_preproc_ica_s%d_m%d_b%d_v%d.mat',isubj,m,iblock,v_out)],'comp_low','comp_hi','-v7.3')



end
