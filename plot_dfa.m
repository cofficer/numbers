function T_dfa = plot_dfa(~)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot DFA results
%Created 7/12-2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
nocebo_trl      =NaN(1,45);
nocebo_rest     =NaN(1,45);
lora_trl        =NaN(1,45);
lora_rest       =NaN(1,45);
placebo_trl     =NaN(1,45);
placebo_rest    =NaN(1,45);

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
for i2dfa = 1:length(trl_dfa)
  load(rest_dfa{i2dfa})

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
