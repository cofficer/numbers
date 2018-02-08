function all_dfa = create_dfa_table(~)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Plot DFA results
  %Created 2018-02-07
  %Changes wanted to plot_dfa:
  %Input every dfa value, no means.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  clear all

  trial_method = 'automatic'; %either manual or automatic

  intervals = [2 4;4 8;8 12;12 24; NaN NaN]; %Nan = <12
  % which_freq = 5;%Alpha 3
  %load csv of session info.
  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos')
  drug_order=xlsread('Drug_Placebo.xlsx');

  %load all the trial-based DFA
  if strcmp(trial_method,'automatic')
    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/auto_task')
    trl_dfa = dir('P*.mat');
    trl_dfa={trl_dfa.name};
  else
    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/DFA')
    trl_dfa = dir('P*.mat');
    trl_dfa={trl_dfa.name};
  end
  %load all the rest-based DFA
  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/DFA')
  rest_dfa = dir('P*.mat');
  rest_dfa={rest_dfa.name};

  %Variable of DFA exponent
  nocebo_trl      =cell(5,45); %ab{end}=[2,3]
  nocebo_rest     =cell(5,45);
  lora_trl        =cell(5,45);
  lora_rest       =cell(5,45);
  placebo_trl     =cell(5,45);
  placebo_rest    =cell(5,45);

  %Loop and store trial-based dfa exponent. Important to correctly average.
  for idfa = 1:length(trl_dfa)

    load(trl_dfa{idfa})
    disp(trl_dfa{idfa})

    for which_freq=1:length(intervals)


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
        if ~isempty(nocebo_trl{which_freq,numP})
          nocebo_trl{which_freq,numP}  = [mean(dfa_all{which_freq}.exp),nocebo_trl{which_freq,numP}];
        else
          nocebo_trl{which_freq,numP}  = mean(dfa_all{which_freq}.exp);
        end
        %Crete case of placebo, trl
      elseif sess_pla
        if ~isempty(placebo_trl{which_freq,numP})
          placebo_trl{which_freq,numP} = [mean(dfa_all{which_freq}.exp),placebo_trl{which_freq,numP}];
        else
          placebo_trl{which_freq,numP}  = mean(dfa_all{which_freq}.exp);
        end
      elseif sess_drug
        if ~isempty(lora_trl{which_freq,numP})
          lora_trl{which_freq,numP}=[mean(dfa_all{which_freq}.exp),lora_trl{which_freq,numP}];
        else
          lora_trl{which_freq,numP}  = mean(dfa_all{which_freq}.exp);
        end
      end
    end
  end
  %store the resting dfa exponent.
  for i2dfa = 1:length(rest_dfa)
    load(rest_dfa{i2dfa})
    disp(rest_dfa{i2dfa})

    for which_freq=1:length(intervals)

      %Identify the current participant.
      numP        = str2num(rest_dfa{i2dfa}(2:3));
      curr_sess   = str2num(rest_dfa{i2dfa}(6));
      curr_block  = str2num(rest_dfa{i2dfa}(9));


      curr_order = drug_order(numP,2:3);
      sess_pla   = curr_order(1)==curr_sess;
      sess_drug  = curr_order(2)==curr_sess;

      %Crete case of nocebo, trl
      if curr_sess==1
        if ~isempty(nocebo_rest{which_freq,numP})
          nocebo_rest{which_freq,numP}=[mean(dfa_all{which_freq}.exp),nocebo_rest{which_freq,numP}];
        else
          nocebo_rest{which_freq,numP}  = mean(dfa_all{which_freq}.exp);
        end
        %Crete case of placebo, rest
      elseif sess_pla
        if ~isempty(placebo_rest{which_freq,numP})
          placebo_rest{which_freq,numP}  = [mean(dfa_all{which_freq}.exp),placebo_rest{which_freq,numP}];
        else
          placebo_rest{which_freq,numP}  = mean(dfa_all{which_freq}.exp);
        end
      elseif sess_drug
        if ~isempty(lora_rest{which_freq,numP})
          lora_rest{which_freq,numP}  =  [mean(dfa_all{which_freq}.exp),lora_rest{which_freq,numP}];
        else
          lora_rest{which_freq,numP}  =   mean(dfa_all{which_freq}.exp);
        end
      end
    end
  end



  %Store all the dfa exponents in one struct
  all_dfa.lora_rest       = lora_rest;
  all_dfa.placebo_rest    = placebo_rest;
  all_dfa.nocebo_rest     = nocebo_rest;
  all_dfa.lora_trl        = lora_trl;
  all_dfa.placebo_trl     = placebo_trl;
  all_dfa.nocebo_trl      = nocebo_trl;

  %Create a clean table with all the mean information.
  for ipartn = 1:45
    nocebo_trl_2_4Hz(ipartn)        = mean(nocebo_trl{1,ipartn});
    nocebo_trl_4_8Hz(ipartn)        = mean(nocebo_trl{2,ipartn});
    nocebo_trl_8_12Hz(ipartn)       = mean(nocebo_trl{3,ipartn});
    nocebo_trl_12_24Hz(ipartn)      = mean(nocebo_trl{4,ipartn});
    nocebo_trl_12Hz(ipartn)         = mean(nocebo_trl{5,ipartn});

    placebo_trl_2_4Hz(ipartn)       =mean(placebo_trl{1,ipartn});
    placebo_trl_4_8Hz(ipartn)       =mean(placebo_trl{2,ipartn});
    placebo_trl_8_12Hz(ipartn)      =mean(placebo_trl{3,ipartn});
    placebo_trl_12_24Hz(ipartn)     =mean(placebo_trl{4,ipartn});
    placebo_trl_12Hz(ipartn)        =mean(placebo_trl{5,ipartn});

    lora_trl_2_4Hz(ipartn)        =mean(lora_trl{1,ipartn});
    lora_trl_4_8Hz(ipartn)        =mean(lora_trl{2,ipartn});
    lora_trl_8_12Hz(ipartn)       =mean(lora_trl{3,ipartn});
    lora_trl_12_24Hz(ipartn)      =mean(lora_trl{4,ipartn});
    lora_trl_12Hz(ipartn)         =mean(lora_trl{5,ipartn});

    nocebo_rest_2_4Hz(ipartn)       =mean(nocebo_rest{1,ipartn});
    nocebo_rest_4_8Hz(ipartn)       =mean(nocebo_rest{2,ipartn});
    nocebo_rest_8_12Hz(ipartn)      =mean(nocebo_rest{3,ipartn});
    nocebo_rest_12_24Hz(ipartn)     =mean(nocebo_rest{4,ipartn});
    nocebo_rest_12Hz(ipartn)        =mean(nocebo_rest{5,ipartn});

    placebo_rest_2_4Hz(ipartn)      =mean(placebo_rest{1,ipartn});
    placebo_rest_4_8Hz(ipartn)      =mean(placebo_rest{2,ipartn});
    placebo_rest_8_12Hz(ipartn)     =mean(placebo_rest{3,ipartn});
    placebo_rest_12_24Hz(ipartn)    =mean(placebo_rest{4,ipartn});
    placebo_rest_12Hz(ipartn)       =mean(placebo_rest{5,ipartn});

    lora_rest_2_4Hz(ipartn)       =mean(lora_rest{1,ipartn});
    lora_rest_4_8Hz(ipartn)       =mean(lora_rest{2,ipartn});
    lora_rest_8_12Hz(ipartn)      =mean(lora_rest{3,ipartn});
    lora_rest_12_24Hz(ipartn)     =mean(lora_rest{4,ipartn});
    lora_rest_12Hz(ipartn)        =mean(lora_rest{5,ipartn});
  end

    nocebo_trl_2_4Hz = nocebo_trl_2_4Hz';
    nocebo_trl_4_8Hz = nocebo_trl_4_8Hz';
    nocebo_trl_8_12Hz = nocebo_trl_8_12Hz';
    nocebo_trl_12_24Hz = nocebo_trl_12_24Hz';
    nocebo_trl_12Hz = nocebo_trl_12Hz';
    placebo_trl_2_4Hz = placebo_trl_2_4Hz';
    placebo_trl_4_8Hz = placebo_trl_4_8Hz';
    placebo_trl_8_12Hz = placebo_trl_8_12Hz';
    placebo_trl_12_24Hz = placebo_trl_12_24Hz';
    placebo_trl_12Hz = placebo_trl_12Hz';
    lora_trl_2_4Hz = lora_trl_2_4Hz';
    lora_trl_4_8Hz = lora_trl_4_8Hz';
    lora_trl_8_12Hz = lora_trl_8_12Hz';
    lora_trl_12_24Hz = lora_trl_12_24Hz';
    lora_trl_12Hz = lora_trl_12Hz';
    nocebo_rest_2_4Hz = nocebo_rest_2_4Hz';
    nocebo_rest_4_8Hz = nocebo_rest_4_8Hz';
    nocebo_rest_8_12Hz = nocebo_rest_8_12Hz';
    nocebo_rest_12_24Hz = nocebo_rest_12_24Hz';
    nocebo_rest_12Hz = nocebo_rest_12Hz';
    placebo_rest_2_4Hz = placebo_rest_2_4Hz';
    placebo_rest_4_8Hz = placebo_rest_4_8Hz';
    placebo_rest_8_12Hz = placebo_rest_8_12Hz';
    placebo_rest_12_24Hz = placebo_rest_12_24Hz';
    placebo_rest_12Hz = placebo_rest_12Hz';
    lora_rest_2_4Hz = lora_rest_2_4Hz';
    lora_rest_4_8Hz = lora_rest_4_8Hz';
    lora_rest_8_12Hz = lora_rest_8_12Hz';
    lora_rest_12_24Hz = lora_rest_12_24Hz';
    lora_rest_12Hz = lora_rest_12Hz';



  part_id = (1:length(nocebo_trl))';
  Table_dfa = table(nocebo_trl_2_4Hz,nocebo_trl_4_8Hz,nocebo_trl_8_12Hz,...
  nocebo_trl_12_24Hz,nocebo_trl_12Hz,placebo_trl_2_4Hz,placebo_trl_4_8Hz,...
  placebo_trl_8_12Hz,placebo_trl_12_24Hz,placebo_trl_12Hz,lora_trl_2_4Hz,...
  lora_trl_4_8Hz,lora_trl_8_12Hz,lora_trl_12_24Hz,lora_trl_12Hz,...
  nocebo_rest_2_4Hz,nocebo_rest_4_8Hz,nocebo_rest_8_12Hz,nocebo_rest_12_24Hz,...
  nocebo_rest_12Hz,placebo_rest_2_4Hz,placebo_rest_4_8Hz,placebo_rest_8_12Hz,...
  placebo_rest_12_24Hz,placebo_rest_12Hz,lora_rest_2_4Hz,lora_rest_4_8Hz,...
  lora_rest_8_12Hz,lora_rest_12_24Hz,lora_rest_12Hz,part_id);

  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos')
  %save('2018-02-08_DFA_exponents.mat','Table_dfa','all_dfa')

  %sum_dfa = summary(T_dfa);



  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Plot the DFA exponent in boxplots
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  doplot=0;

  if doplot

    x_labels ={'placebo task','placebo rest','nocebo task','nocebo rest','lorazepam task','lorazepam rest'};


    o29 =ones(1,38);
    idx_group = ones(1,76);
    idx_group(38:end)=2;
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


    %switch all of the dfa values where something about the resting state.
    [~,p_drug]=ttest(placebo',lorazepam')

    [~,p_drugtaskPla]=ttest(clean_T_dfa.placebo_trl,clean_T_dfa.lora_trl)

    [~,p_drugrestPla]=ttest(clean_T_dfa.placebo_rest,clean_T_dfa.lora_rest)

    [~,p_drugtaskNoc]=ttest(clean_T_dfa.nocebo_trl,clean_T_dfa.lora_trl)

    [~,p_drugrestNoc]=ttest(clean_T_dfa.nocebo_rest,clean_T_dfa.lora_rest)

    [~,p_plaTaskRest]=ttest(clean_T_dfa.placebo_rest,clean_T_dfa.placebo_trl)

    [~,p_drugTaskRest]=ttest(clean_T_dfa.lora_rest,clean_T_dfa.lora_trl)

    [~,p_nocTaskRest]=ttest(clean_T_dfa.nocebo_rest,clean_T_dfa.nocebo_trl)


  end
  %Analysis 2: Is there an effect of trial/resting-state? In placebo, individually
  %in each drug condition, and across all condition types.

  %Analysis 3: Repeat 1 and 2 for all frequency bands.

  %Do we have any predictions at all? How certain are we on the hypotheses?
  %




end
