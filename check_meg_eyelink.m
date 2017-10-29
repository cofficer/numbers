

function check_meg_eyelink(~)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Testing the relationship between asc and meg data time.
  %Find if there is eyelink data in the meg, check ieye=80!!
  % 2017-10-28.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  block_type='trial';

  %General paths
  eyelinkpath = sprintf('/home/chrisgahn/Documents/MATLAB/ktsetsos/%s/eyedat/',block_type);
  megpath     = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/raw/',block_type);
  currpath    = '/home/chrisgahn/Documents/MATLAB/ktsetsos/code/numbers/';

  %Fieldtrip paths
  %addpath '/home/chrisgahn/Documents/MATLAB/fieldtrip-20170528/'  % tell Matlab where FieldTrip is
  %ft_defaults

  %Store filenames
  cd(eyelinkpath)
  alleyes     = dir('*.mat');
  %remove the 30's because they have already had the eyelink channels added.
  %[allNeweyes]=setdiff({alleyes.name},{eyes_30s.name})


  %Get all the unique names:
  namesDat = {alleyes.name};
  namesDat=cellfun(@(x) x(1:3),namesDat,'UniformOutput',false)
  [val_uni,pos_uni]=unique(namesDat)

  idx_006 = ismember(namesDat,'006');

  alleyes=alleyes(idx_006);
  %figure(1),clf
  %loop all eyelink files
  for ieye = 1:length(alleyes)
    cd(eyelinkpath)
    %load the eyelink file
    dat_eye         = load(alleyes(ieye).name);
    fprintf('Eyelink asc %s\n',alleyes(ieye).name)

    %save the variance for comparison027_1_1.mat
    %eyelink_var(ieye) = var(dat_eye.asc.trial{1}(4,:));
    %  if alleyes(ieye).name(7)=='1'
    %   aaa=1;
    % elseif alleyes(ieye).name(7)=='2'
    %    alleyes(ieye).name(7) ='3';
    %  end

    %Remove the 0 if part 1:9. Else do nothing.
    part0 = ismember(alleyes(ieye).name(2:3),'0');
    if part0(2)==0
      partstr=alleyes(ieye).name(3);
    else
      partstr=alleyes(ieye).name(2:3);
    end
    %load the MEG data
    dat_megname      = sprintf('%sp%s_s%s_b%s.mat',megpath,partstr,alleyes(ieye).name(5),alleyes(ieye).name(7));

    %Need to understand why this is sometimes the case...
    %if ~exist(dat_megname)
    %  continue
    %end


    %I really need to know which files have the combined_dat and which only have data...
    if ~exist(dat_megname)
      continue
    end
    %Load the meg data.
    dat_meg          = load(dat_megname);

    idx_blink_chan = find(ismember(dat_meg.data.label,'UADC004')==1);
    idx_blink_chan3 = find(ismember(dat_meg.data.label,'UADC003')==1);
    idx_blink_eog = find(ismember(dat_meg.data.label,'EEG058')==1);
    for trln=1:3;


      diff_time = length(dat_meg.data.trial{trln})-length(dat_eye.asc.trial{trln})
      %
       figure(1),clf
      subplot(3,1,1)
      meg_eyelink=dat_meg.data.trial{trln}(idx_blink_chan,:);%723287
      % plot((meg_eyelink-mean(meg_eyelink))/std(meg_eyelink))
      plot(meg_eyelink)
      legend megUAD4

      subplot(3,1,2)
      real_eyelink = dat_eye.asc.trial{trln}(4,31200:end);
      % plot((real_eyelink-mean(real_eyelink))/std(real_eyelink),'r')
      plot(real_eyelink,'r')
      legend eye4

      subplot(3,1,3)
      meg_eyelink=dat_meg.data.trial{trln}(idx_blink_eog,:);%723287
      % plot((real_eyelink-mean(real_eyelink))/std(real_eyelink),'r')
      plot(meg_eyelink,'k')
      legend eog58

      % subplot(2,1,1)
      % meg_eyelink=dat_meg.data.trial{trln}(idx_blink_chan3,1:end);%723287
      % % plot((meg_eyelink-mean(meg_eyelink))/std(meg_eyelink))
      % plot(meg_eyelink)
      % legend megUAD3
      %
      % subplot(2,1,2)
      % real_eyelink = dat_eye.asc.trial{trln}(3,1:end);
      % % plot((real_eyelink-mean(real_eyelink))/std(real_eyelink),'r')
      % plot(real_eyelink,'r')
      % legend eye3

      %save figure
      cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/plots')
      %New naming file standard. Apply to all projects.
      formatOut = 'yyyy-mm-dd';
      todaystr = datestr(now,formatOut);
      namefigure='eyeblinkdata_task_meg-eyelink'
      figurefreqname = sprintf('%s_%s_2P%s_T%d.png',todaystr,namefigure,alleyes(ieye).name(2:7),trln)%
      saveas(gca,figurefreqname,'png')
    end
  end
end




%Error on 030_1_1.mat, there is no data there.
%Error on 008_2_1.mat, there is no MEG data there.
%Error on 008_2_2.mat, there is no eyelink data there. I should rerun, convertEDF
%and check what the error may be.
%Error on 008_2_3.mat, there is no eyelink data there. I should rerun, convertEDF
%and check what the error may be.
%Error on 008_3_1.mat, there is no eyelink data there. I should rerun, convertEDF
%and check what the error may be.
