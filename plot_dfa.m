function T_dfa = plot_dfa(~)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Plot DFA results
  %Created 7/12-2017
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  clear all

  intervals = [2 4;4 8;8 12;12 24; NaN NaN]; %Nan = <12
  which_freq = 2;%Alpha 3
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
        nocebo_trl(numP)=mean([mean(dfa_all{which_freq}.exp),nocebo_trl(numP)]);
      else
        nocebo_trl(numP)  = mean(dfa_all{which_freq}.exp);
      end
      %Crete case of placebo, trl
    elseif sess_pla
      if ~isnan(placebo_trl(numP))
        placebo_trl(numP)=mean([mean(dfa_all{which_freq}.exp),placebo_trl(numP)]);
      else
        placebo_trl(numP)  = mean(dfa_all{which_freq}.exp);
      end
    elseif sess_drug
      if ~isnan(lora_trl(numP))
        lora_trl(numP)=mean([mean(dfa_all{which_freq}.exp),lora_trl(numP)]);
      else
        lora_trl(numP)  = mean(dfa_all{which_freq}.exp);
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
        nocebo_rest(numP)=mean([mean(dfa_all{which_freq}.exp),nocebo_rest(numP)]);
      else
        nocebo_rest(numP)  = mean(dfa_all{which_freq}.exp);
      end
      %Crete case of placebo, rest
    elseif sess_pla
      if ~isnan(placebo_rest(numP))
        placebo_rest(numP)=mean([mean(dfa_all{which_freq}.exp),placebo_rest(numP)]);
      else
        placebo_rest(numP)  = mean(dfa_all{which_freq}.exp);
      end
    elseif sess_drug
      if ~isnan(lora_rest(numP))
        lora_rest(numP)=mean([mean(dfa_all{which_freq}.exp),lora_rest(numP)]);
      else
        lora_rest(numP)  = mean(dfa_all{which_freq}.exp);
      end
    end
  end

  %Create table
  part_id = (1:length(nocebo_trl))';
  T_dfa = table(nocebo_trl,nocebo_rest,lora_trl,lora_rest,placebo_trl,placebo_rest,part_id);
  sum_dfa = summary(T_dfa);

  idx_complete=isnan(T_dfa{:,{'nocebo_trl','nocebo_rest','lora_trl','lora_rest','placebo_trl','placebo_rest','part_id'}});

  %The ones are complete participants.
  idx_complete=sum(idx_complete,2)==0;

  clean_T_dfa = T_dfa(idx_complete,:);

  clean_T_dfa{:,{'nocebo_trl'}}

  %cd('')
  %save('DFA_exponents_-12Hz.mat','T_dfa')
  %load('DFA_exponents.mat')


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Plot the DFA exponent in boxplots
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  x_labels ={'placebo task','placebo rest','nocebo task','nocebo rest','lorazepam task','lorazepam rest'};


  o29 =ones(1,36);
  idx_group = ones(1,74);
  idx_group(36:end)=2;
  clear g;close all
  % g=gramm('x',idx_group,'y',[clean_T_dfa.placebo_trl',clean_T_dfa.lora_trl'],'color',idx_group);
  g=gramm('x',[o29,o29*2,o29*3,o29*4,o29*5,o29*6],'y',[clean_T_dfa.placebo_trl',...
  clean_T_dfa.placebo_rest',clean_T_dfa.nocebo_trl',clean_T_dfa.nocebo_rest',clean_T_dfa.lora_trl',...
  clean_T_dfa.lora_rest'],'color',[o29,o29,o29*2,o29*2,o29*3,o29*3])
  %,'color',clean_T_dfa.part_id)%,'color',[ones(1,29) ones(1,29)*2]');
  % g=gramm('x',idx_group,'y',[clean_T_dfa.placebo_trl',clean_T_dfa.lora_trl']','color',[1:29,1:29]');
  % num=2;
  % g=gramm('x',[ones(1,num) ones(1,num)*2],'y',[clean_T_dfa.placebo_trl(1:num)',clean_T_dfa.lora_trl(1:num)']','color',[1:num ,1:num]');

  % g.geom_line('dodge',0.1);
  g.stat_boxplot()%('nbins',20,'dodge',0,'fill','transparent');
  % g.geom_bar('dodge',0.8,'width',0.6)
  % g.geom_label('color','k','dodge',0.7,'VerticalAlignment','bottom','HorizontalAlignment','center');
  % g.geom_abline()
  g.set_names('column','Origin','x','Group','y','DFA exp','color','Pla/Noc/Lor');
  % g.set_text_options('base_size',20);
  % g(2,1).set_color_options('chroma',0,'lightness',20)
  g.set_title(sprintf('Bandpass %d-%dHz',intervals(which_freq,1),intervals(which_freq,2)));

  %g.facet_grid('space','free')
  figure('Position',[100 100 800 600]);
  g.axe_property('XTick',[1 2 3 4 5 6])
  g.axe_property('XTickLabel',x_labels)
  g.draw();
  % g.facet_grid('scale','free')
  % g.facet_axes_handles.XLim=[0.5 1];
  % g.facet_axes_handles.YLim=[0.5 1];

  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/plots/')
  %Name of figure
  filetyp='svg';
  %name filess
  formatOut = 'yyyy-mm-dd';
  todaystr = datestr(now,formatOut);
  namefigure = sprintf('prelim2_DFA_exponents_newplot_%d-%dHz',intervals(which_freq,1),intervals(which_freq,2));%fractionTrialsRemaining
  filetype    = filetyp;
  figurename = sprintf('%s_%s.%s',todaystr,namefigure,filetype);
  g.export('file_name',figurename,'file_type',filetype);


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Plot the DFA exponent in ??
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  x_labels ={'placebo task','placebo rest','nocebo task','nocebo rest','lorazepam task','lorazepam rest'};


  o29 =ones(1,33);
  idx_group = ones(1,66);
  idx_group(33:end)=2;
  clear g;close all
  % g=gramm('x',idx_group,'y',[clean_T_dfa.placebo_trl',clean_T_dfa.lora_trl'],'color',idx_group);
  g=gramm('x',[o29,o29*2,o29*3,o29*4,o29*5,o29*6],'y',[clean_T_dfa.placebo_trl',...
  clean_T_dfa.placebo_rest',clean_T_dfa.nocebo_trl',clean_T_dfa.nocebo_rest',clean_T_dfa.lora_trl',...
  clean_T_dfa.lora_rest'],'color',[o29,o29,o29*2,o29*2,o29*3,o29*3])
  %,'color',clean_T_dfa.part_id)%,'color',[ones(1,29) ones(1,29)*2]');
  % g=gramm('x',idx_group,'y',[clean_T_dfa.placebo_trl',clean_T_dfa.lora_trl']','color',[1:29,1:29]');
  % num=2;
  % g=gramm('x',[ones(1,num) ones(1,num)*2],'y',[clean_T_dfa.placebo_trl(1:num)',clean_T_dfa.lora_trl(1:num)']','color',[1:num ,1:num]');

  % g.geom_line('dodge',0.1);
  g.stat_boxplot()%('nbins',20,'dodge',0,'fill','transparent');
  % g.geom_bar('dodge',0.8,'width',0.6)
  % g.geom_label('color','k','dodge',0.7,'VerticalAlignment','bottom','HorizontalAlignment','center');
  % g.geom_abline()
  g.set_names('column','Origin','x','Group','y','DFA exp','color','Pla/Noc/Lor');
  % g.set_text_options('base_size',20);
  % g(2,1).set_color_options('chroma',0,'lightness',20)
  % g.set_title('Time (s) since rotation stop');
  %g.facet_grid('space','free')
  figure('Position',[100 100 800 600]);
  g.axe_property('XTick',[1 2 3 4 5 6])
  g.axe_property('XTickLabel',x_labels)
  g.draw();
  % g.facet_grid('scale','free')
  % g.facet_axes_handles.XLim=[0.5 1];
  % g.facet_axes_handles.YLim=[0.5 1];

  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/plots/')
  %Name of figure
  filetyp='svg';
  %name filess
  formatOut = 'yyyy-mm-dd';
  todaystr = datestr(now,formatOut);
  namefigure = sprintf('DFA_exponents');%fractionTrialsRemaining
  filetype    = filetyp;
  figurename = sprintf('%s_%s.%s',todaystr,namefigure,filetype);
  g.export('file_name',figurename,'file_type',filetype);

  %load all the resting-state DFA

  %Create a table and insert DFA information/session.

  %Create bar plots of the 6 categories:
  %Pla_trial, Pla_rest, Drug1_trial, Drug1_rest, Drug2_trial, Drug2_rest

  %Analysis 1: Is there an effect of drug?
  %Average the DFA across trial/resting, and only check drug/placebo.
  placebo = [clean_T_dfa.placebo_trl',clean_T_dfa.placebo_rest'];
  lorazepam = [clean_T_dfa.lora_trl',clean_T_dfa.lora_rest'];



  [~,p_drug]=ttest(placebo',lorazepam')

  [~,p_drugtaskPla]=ttest(clean_T_dfa.placebo_trl,clean_T_dfa.lora_trl)

  [~,p_drugrestPla]=ttest(clean_T_dfa.placebo_rest,clean_T_dfa.lora_rest)

  [~,p_drugtaskNoc]=ttest(clean_T_dfa.nocebo_trl,clean_T_dfa.lora_trl)

  [~,p_drugrestNoc]=ttest(clean_T_dfa.nocebo_rest,clean_T_dfa.lora_rest)

  [~,p_plaTaskRest]=ttest(clean_T_dfa.placebo_rest,clean_T_dfa.placebo_trl)

  [~,p_drugTaskRest]=ttest(clean_T_dfa.lora_rest,clean_T_dfa.lora_trl)

  [~,p_nocTaskRest]=ttest(clean_T_dfa.nocebo_rest,clean_T_dfa.nocebo_trl)



  %Analysis 2: Is there an effect of trial/resting-state? In placebo, individually
  %in each drug condition, and across all condition types.

  %Analysis 3: Repeat 1 and 2 for all frequency bands.

  %Do we have any predictions at all? How certain are we on the hypotheses?
  %





end
