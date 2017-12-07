function T_dfa = plot_dfa(~)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot DFA results
%Created 7/12-2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

%load csv of session info.
cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos')
drug_order=xlsread('Drug_Placebo.xlsx');

%load all the trial-based DFA
cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/DFA')
trl_dfa = dir('P*.mat');
trl_dfa={trl_dfa.name};

%load all the rest-based DFA
cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/DFA')
rest_dfa = dir('P*.mat');
rest_dfa={rest_dfa.name};

%Variable of DFA exponent
nocebo_trl      =NaN(1,45)';
nocebo_rest     =NaN(1,45)';
lora_trl        =NaN(1,45)';
lora_rest       =NaN(1,45)';
placebo_trl     =NaN(1,45)';
placebo_rest    =NaN(1,45)';

%Loop and store trial-based dfa exponent. Important to correctly average.
for idfa = 1:length(trl_dfa)
  load(trl_dfa{idfa})

  %Identify the current participant.
  if strcmp(trl_dfa{idfa}(3),'_')
    numP        = str2num(trl_dfa{idfa}(2));
    curr_sess   = str2num(trl_dfa{idfa}(5));
    curr_block  = str2num(trl_dfa{idfa}(8));
  else
    numP = str2num(trl_dfa{idfa}(2:3));
    curr_sess   = str2num(trl_dfa{idfa}(6));
    curr_block  = str2num(trl_dfa{idfa}(9));
  end

  curr_order = drug_order(numP,2:3);
  sess_pla   = curr_order(1)==curr_sess;
  sess_drug  = curr_order(2)==curr_sess;

  %Crete case of nocebo, trl
  if curr_sess==1
    if ~isnan(nocebo_trl(numP))
      nocebo_trl(numP)=mean([mean(dfa_all{3}.exp),nocebo_trl(numP)]);
    else
      nocebo_trl(numP)  = mean(dfa_all{3}.exp);
    end
  %Crete case of placebo, trl
  elseif sess_pla
    if ~isnan(placebo_trl(numP))
      placebo_trl(numP)=mean([mean(dfa_all{3}.exp),placebo_trl(numP)]);
    else
      placebo_trl(numP)  = mean(dfa_all{3}.exp);
    end
  elseif sess_drug
    if ~isnan(lora_trl(numP))
      lora_trl(numP)=mean([mean(dfa_all{3}.exp),lora_trl(numP)]);
    else
      lora_trl(numP)  = mean(dfa_all{3}.exp);
    end
  end
end

%store the resting dfa exponent.
for i2dfa = 1:length(rest_dfa)
  load(rest_dfa{i2dfa})

  %Identify the current participant.
  numP        = str2num(rest_dfa{i2dfa}(2:3));
  curr_sess   = str2num(rest_dfa{i2dfa}(6));
  curr_block  = str2num(rest_dfa{i2dfa}(9));


  curr_order = drug_order(numP,2:3);
  sess_pla   = curr_order(1)==curr_sess;
  sess_drug  = curr_order(2)==curr_sess;

  %Crete case of nocebo, trl
  if curr_sess==1
    if ~isnan(nocebo_rest(numP))
      nocebo_rest(numP)=mean([mean(dfa_all{3}.exp),nocebo_rest(numP)]);
    else
      nocebo_rest(numP)  = mean(dfa_all{3}.exp);
    end
  %Crete case of placebo, rest
  elseif sess_pla
    if ~isnan(placebo_rest(numP))
      placebo_rest(numP)=mean([mean(dfa_all{3}.exp),placebo_rest(numP)]);
    else
      placebo_rest(numP)  = mean(dfa_all{3}.exp);
    end
  elseif sess_drug
    if ~isnan(lora_rest(numP))
      lora_rest(numP)=mean([mean(dfa_all{3}.exp),lora_rest(numP)]);
    else
      lora_rest(numP)  = mean(dfa_all{3}.exp);
    end
  end
end

%Create table

T_dfa = table(nocebo_trl,nocebo_rest,lora_trl,lora_rest,placebo_trl,placebo_rest);
sum_dfa = summary(T_dfa);

idx_complete=isnan(T_dfa{:,{'nocebo_trl','nocebo_rest','lora_trl','lora_rest','placebo_trl','placebo_rest'}});

%The ones are complete participants.
idx_complete=sum(idx_complete,2)==0;

clean_T_dfa = T_dfa(idx_complete,:);


  clear g;close all
  g=gramm('x',clean_dat,'color',ind_RT);
  % g.geom_jitter();
  g.stat_bin('nbins',200,'dodge',0,'fill','transparent');
  % g.stat_density()
  % g.geom_abline()
  g.set_names('column','Origin','x','Time (s)','color','Dists');
  % g.set_text_options('base_size',20);
  % g.set_color_options('chroma',0,'lightness',20)
  % g(2,1)=gramm('x',RT_stimoff);
  % % g.geom_jitter();
  % g(2,1).stat_density();
  % % g.geom_abline()
  % g(2,1).set_names('column','Origin','x','Reaction time, stim');
  g.set_text_options('base_size',20);
  % g(2,1).set_color_options('chroma',0,'lightness',20)
  g.set_title('Time (s) since rotation stop');
  %g.facet_grid('space','free')
  figure('Position',[100 100 800 600]);
  g.draw();
  g.facet_grid('scale','free')

  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/plots/')
  %Name of figure
  filetyp='svg';
  %name filess
  formatOut = 'yyyy-mm-dd';
  todaystr = datestr(now,formatOut);
  namefigure = sprintf('DFA_exponents');%fractionTrialsRemaining
  filetype    = 'svg';
  figurename = sprintf('%s_%s.%s',todaystr,namefigure,filetype);
  g.export('file_name',figurename,'file_type',filetype);


%load all the resting-state DFA

%Create a table and insert DFA information/session.

%Create bar plots of the 6 categories:
%Pla_trial, Pla_rest, Drug1_trial, Drug1_rest, Drug2_trial, Drug2_rest

%Analysis 1: Is there an effect of drug?
%Average the DFA across trial/resting, and only check drug/placebo.

%Analysis 2: Is there an effect of trial/resting-state? In placebo, individually
%in each drug condition, and across all condition types.

%Analysis 3: Repeat 1 and 2 for all frequency bands.

%Do we have any predictions at all? How certain are we on the hypotheses?
%





end
