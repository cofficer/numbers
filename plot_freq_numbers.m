function plot_freq_numbers(~)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Created 2018-02-22
%Load spectral decomposition of all numbers data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  blocktype = 'trial';
  cd(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/freq',blocktype))

  freq_files = dir('*.mat')

  mat_freq = zeros(length(freq_files),269,641);

  %Need to figure which sensors are commonly available for all sessions.
  ab=load(freq_files(1).name)

  %Get the drug order so we can compare drug and placebo.
  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos')

  drug_order=xlsread('Drug_Placebo.xlsx');
  curr_order = drug_order(numP,2:3);
  %Second column is session for placebo
  %Last column is session for drug.
  sess_pla   = curr_order(1)==curr_sess;
  sess_drug  = curr_order(2)==curr_sess;


  %Variable of FREQ exponent
  nocebo_trl      =NaN(45,641);
  nocebo_rest     =NaN(45,641);
  lora_trl        =NaN(45,641);
  lora_rest       =NaN(45,641);
  placebo_trl     =NaN(45,641);
  placebo_rest    =NaN(45,641);

  blocktype = 'trial';
  cd(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/freq',blocktype))

  freq_files = dir('*.mat')
  for ifreq = 1:length(freq_files)
    disp(freq_files(ifreq).name)

    load(freq_files(ifreq).name)

    %Identify the current participant.
    if strcmp(freq_files(ifreq).name(3),'_')
      numP        = str2num(freq_files(ifreq).name(2));
      curr_sess   = str2num(freq_files(ifreq).name(5));
      curr_block  = str2num(freq_files(ifreq).name(8));
    else
      numP = str2num(freq_files(ifreq).name(2:3));
      curr_sess   = str2num(freq_files(ifreq).name(6));
      curr_block  = str2num(freq_files(ifreq).name(9));
    end

    curr_order = drug_order(numP,2:3);
    sess_pla   = curr_order(1)==curr_sess;
    sess_drug  = curr_order(2)==curr_sess;

    %Crete case of nocebo, trl
    if curr_sess==1
      if ~isnan(nocebo_trl(numP))
        nocebo_trl(numP,:)=mean([nocebo_trl(numP,:);mean(freq.powspctrm)]);
      else
        nocebo_trl(numP,:)  = mean(freq.powspctrm);
      end
      %Crete case of placebo, trl
    elseif sess_pla
      if ~isnan(placebo_trl(numP))
        placebo_trl(numP,:)=mean([placebo_trl(numP,:);mean(freq.powspctrm)]);
      else
        placebo_trl(numP,:)  = mean(freq.powspctrm);
      end
    elseif sess_drug
      if ~isnan(lora_trl(numP))
        lora_trl(numP,:)=mean([lora_trl(numP,:);mean(freq.powspctrm)]);
      else
        lora_trl(numP,:)  = mean(freq.powspctrm);
      end
    end
  end

  blocktype = 'resting';
  cd(sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/freq',blocktype))

  freq_files = dir('*.mat')

  %store the resting dfa exponent.
  for ifreq = 1:length(freq_files)
    disp(freq_files(ifreq).name)
    load(freq_files(ifreq).name)

    %Identify the current participant.
    if strcmp(freq_files(ifreq).name(3),'_')
      numP        = str2num(freq_files(ifreq).name(2));
      curr_sess   = str2num(freq_files(ifreq).name(5));
      curr_block  = str2num(freq_files(ifreq).name(8));
    else
      numP = str2num(freq_files(ifreq).name(2:3));
      curr_sess   = str2num(freq_files(ifreq).name(6));
      curr_block  = str2num(freq_files(ifreq).name(9));
    end


    curr_order = drug_order(numP,2:3);
    sess_pla   = curr_order(1)==curr_sess;
    sess_drug  = curr_order(2)==curr_sess;

    %Crete case of nocebo, trl
    if curr_sess==1
      if ~isnan(nocebo_rest(numP))
        nocebo_rest(numP,:)=mean([nocebo_rest(numP,:);mean(freq.powspctrm)]);
      else
        nocebo_rest(numP,:)  = mean(freq.powspctrm);
      end
      %Crete case of placebo, rest
    elseif sess_pla
      if ~isnan(placebo_rest(numP))
        placebo_rest(numP,:)=mean([placebo_rest(numP,:);mean(freq.powspctrm)]);
      else
        placebo_rest(numP,:)  = mean(freq.powspctrm);
      end
    elseif sess_drug
      if ~isnan(lora_rest(numP))
        lora_rest(numP,:)=mean([lora_rest(numP,:);mean(freq.powspctrm)]);
      else
        lora_rest(numP,:)  = mean(freq.powspctrm);
      end
    end
  end

  %save all the values
  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/')
  % save('2018-03-09_resting_freqs.mat','nocebo_rest','placebo_rest','lora_rest')
  % save('2018-03-09_trial_freqs.mat','nocebo_trl','placebo_trl','lora_trl')
  % load('2018-03-09_resting_freqs.mat')
  % load('2018-03-09_trial_freqs.mat')
  % load('2018-03-11_cluster_mask_pla-lora_powspctrm.mat')
  %Implement a gramm plot for resting.
  %The values of
  % nocebo_rest     = nanmean(nocebo_rest,1);
  % placebo_rest    = nanmean(nocebo_rest,1);
  % lora_rest       = nanmean(nocebo_rest,1);


  idxn          = isnan(nocebo_rest(:,1));
  idxp          = isnan(placebo_rest(:,1));
  idxl          = isnan(lora_rest(:,1));

  idxnt          = isnan(nocebo_trl(:,1));
  idxpt          = isnan(placebo_trl(:,1));
  idxlt          = isnan(lora_trl(:,1));

  idx_nant = idxnt+idxpt+idxlt;
  idx_nant = idx_nant==0;

  nocebo_trl    = nocebo_trl(idx_nant,:);
  placebo_trl   = placebo_trl(idx_nant,:);
  lora_trl      = lora_trl(idx_nant,:);

  idx_nan = idxn+idxp+idxl;
  idx_nan = idx_nan==0;

  nocebo_rest   = nocebo_rest(idx_nan,:);
  placebo_rest  = placebo_rest(idx_nan,:);
  lora_rest     = lora_rest(idx_nan,:);

  %insert nans for the freq spectrm we dont care about, around 50 and 100.
  idx_50                            =find(freq.freq==50);
  idx_100                           =find(freq.freq==100);
  nocebo_trl(:,idx_50-10:idx_50+10)   =NaN;
  nocebo_trl(:,idx_100-10:idx_100+10) =NaN;
  placebo_trl(:,idx_50-10:idx_50+10)  =NaN;
  placebo_trl(:,idx_100-10:idx_100+10)=NaN;
  lora_trl(:,idx_50-10:idx_50+10)     =NaN;
  lora_trl(:,idx_100-10:idx_100+10)   =NaN;


  %Looks like the best way to use gramm, is using converting the data
  %into long vectors....
  % dat.nocebo_rest = nocebo_rest';
  ist = 1
  ien = 641
  for ipart = 1:38

    dat.nocebo_rest(ist:ien) = nocebo_rest(ipart,1:641);
    dat.placebo_rest(ist:ien) = placebo_rest(ipart,1:641);
    dat.lora_rest(ist:ien) = lora_rest(ipart,1:641);

    ist = ist+641;
    ien = ien+641;
  end

  ist = 1
  ien = 641
  for ipart = 1:36
    dat.nocebo_trl(ist:ien) = nocebo_trl(ipart,1:641);
    dat.placebo_trl(ist:ien) = placebo_trl(ipart,1:641);
    dat.lora_trl(ist:ien) = lora_trl(ipart,1:641);
    dat.idx_mask(ist:ien) = idx_mask
    ist = ist+641;
    ien = ien+641;
  end

  dat.nocebo_trl = dat.nocebo_trl';
  dat.placebo_trl = dat.placebo_trl';
  dat.lora_trl = dat.lora_trl';

  dat.nocebo_rest = dat.nocebo_rest';
  dat.placebo_rest = dat.placebo_rest';
  dat.lora_rest = dat.lora_rest';

  dat.parts_rest       = [1:38]'*repmat(1,1,641);
  dat.parts_rest       = dat.parts_rest';
  dat.parts_rest       = dat.parts_rest(:);

  dat.parts_trl       = [1:36]'*repmat(1,1,641);
  dat.parts_trl       = dat.parts_trl';
  dat.parts_trl       = dat.parts_trl(:);

  dat.xfreq_rest       = repmat(freq.freq,1,38)';
  dat.xfreq_rest       = dat.xfreq_rest';
  dat.xfreq_rest       = dat.xfreq_rest(:);

  dat.xfreq_trl       = repmat(freq.freq,1,36)';
  dat.xfreq_trl       = dat.xfreq_trl';
  dat.xfreq_trl       = dat.xfreq_trl(:);

  %Gramm plot
  % x_labels ={'placebo rest','nocebo rest','lorazepam rest'};
  %
  % load('/home/chrisgahn/Documents/MATLAB/toolkits/gramm/example_data.mat')
  %
  % 
  %   numdat    = size(nocebo_rest,2);
  %   o29       = ones(38,numdat);
  %   idx_group = ones(1,78);
  %   idx_group(39:end)=2;


    clear g;close all

    % g=gramm('x',[log(freq.freq),log(freq.freq),log(freq.freq)],'y',...
    %         [log(mean(placebo_rest,1)),log(mean(nocebo_rest,1)),...
    %         log(mean(lora_rest,1))],'color',...
    %         [ones(1,641),ones(1,641)*2,ones(1,641)*3])
    %
    % g=gramm('x',[log(freq.freq),log(freq.freq),log(freq.freq)],'y',...
    %         [log(mean(placebo_trl,1)),log(mean(new_nocebo_trl,1)),...
    %         log(mean(new_loraz_trl,1))],'color',...
    %         [ones(1,641),ones(1,641)*2,ones(1,641)*3])
    %
    % g=gramm('x',[log(freq.freq)],'y',...
    %         [log(mean(new_nocebo_trl,1))],'color',...
    %         [ones(1,641)])
    %
    % g=gramm('x',[log(dat.xfreq_trl)],'y',...
    %         [log(dat.lora_trl)])

    %add the mask to the data as an extra line, with different values....
    id_m = ones(1,length(dat.idx_mask));
    id_m(dat.idx_mask==0)=NaN;
    id_m=id_m.*-64;
    id_m=id_m';

    % g=gramm('x',[log(dat.xfreq_trl)],'y',...
    %         id_m)

    % try and plot all the conditions with SEM.
    % colo_def = [ones(1,length(dat.placebo_trl)),ones(1,length(dat.placebo_trl))*2,ones(1,length(dat.placebo_trl))*3]';
    x_ais = [log(dat.xfreq_trl);log(dat.xfreq_trl);log(dat.xfreq_trl);log(dat.xfreq_trl)];
    g=gramm('x',x_ais,'y',...
            [log(dat.placebo_trl);log(dat.nocebo_trl);log(dat.lora_trl);id_m],'color',...
            [ones(1,length(dat.placebo_trl)),ones(1,length(dat.placebo_trl))*2,ones(1,length(dat.placebo_trl))*3,ones(1,length(dat.placebo_trl))*4])

    % %plot the resting state.
    % x_ais = [log(dat.xfreq_rest);log(dat.xfreq_rest);log(dat.xfreq_rest)]';
    % g=gramm('x',x_ais,'y',...
    %         [log(dat.placebo_rest),log(dat.nocebo_rest),log(dat.lora_rest)],'color',...
    %         [ones(1,length(dat.placebo_rest)),ones(1,length(dat.placebo_rest))*2,ones(1,length(dat.placebo_rest))*3])


    % g(2,1)=gramm('x',log(dat.xfreq),'y',log(dat.placebo_rest))
    %[id,val]=max(lora_trl(:,241))
    %new_nocebo_trl =nocebo_trl;
    %new_nocebo_trl(2,:) =[];
    %new_loraz_trl =lora_trl;
    %new_loraz_trl(17,:) =[];
    % g(3,1)=gramm('x',log(dat.xfreq),'y',log(dat.lora_rest))

    % ;log(dat.placebo_rest);log(dat.lora_rest)]

    % g.geom_line('dodge',0.1);

    g.stat_summary('type','sem')
    % g(2,1).geom_line('dodge',0.1)
    % g(3,1).geom_line('dodge',0.1)
    % g.stat_boxplot()%('nbins',20,'dodge',0,'fill','transparent');
    % g.geom_bar('dodge',0.8,'width',0.6)
    % g.geom_label('color','k','dodge',0.7,'VerticalAlignment','bottom','HorizontalAlignment','center');
    % g.geom_abline()
    g.set_names('column','Origin','x','log(freq)','y','log(pow)','color','Pla/Noc/Lor');
    g.set_text_options('base_size',20);
    % g(2,1).set_color_options('chroma',0,'lightness',20)
    g.set_title(sprintf('Task power'));

    %g.facet_grid('space','free')
    % figure('Position',[100 100 800 600]);
    x_labels=[2,4,8,16,32,64,128];
    a = 0.3;
    tol = 0.0001;
    [~,idx_f]=find(ismembertol(freq.freq,x_labels,tol));


    g.axe_property('XTick',log(freq.freq(idx_f)))

    freq.freq(1:40:450);
    g.axe_property('XTickLabel',x_labels)
    figure('Position',[100 100 800 800]);
    g.draw();
    % g.update('color',idx_mask)
    % freq.freq(idx_mask)


    % g.facet_grid('scale','free')
    g.facet_axes_handles.XLim=[0.4844 3.5];
    g.facet_axes_handles.YLim=[-69 -63];

    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/plots/')
    %Name of figure
    filetyp='svg';
    %name filess
    formatOut = 'yyyy-mm-dd';
    todaystr = datestr(now,formatOut);
    namefigure = sprintf('prelim4_FREQ_test_trl_xlim35');%fractionTrialsRemaining
    filetype    = filetyp;
    figurename = sprintf('%s_%s.%s',todaystr,namefigure,filetype);
    g.export('file_name',figurename,'file_type',filetype);






  for ifreq = 1:length(freq_files)

    disp(ifreq)
    load(freq_files(ifreq).name)

    %idx of all sensors common.
    idx_sens=ismember(freq.label,ab.freq.label);

    mat_freq(ifreq,:,:)=freq.powspctrm(idx_sens,:);

  end


  mat_freq          =      squeeze(mean(mat_freq(:,:,:),1));
  freq.powspctrm    =      mat_freq;

  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/plots')
  %Plot the figure
  figure(1),clf
  % loglog(freq.freq, freq.powspctrm, 'linewidth', 0.1); hold on;
  loglog(freq.freq, mean(freq.powspctrm), 'k', 'linewidth', 1);
  xlim([1 130])
  % % ylim([0.5 50])
  % nticks = 5;
  % tickpos = round( logspace(log10(0.5),log10(50), nticks) );
  % set(gca, 'XTick', tickpos)
  % grid on;
  % semilogx(freq.freq,freq.powspctrm)
  % hold on
  % semilogx(freq.freq,mean(freq.powspctrm),'r')
  % plot(freq.freq,freq.powspctrm)
  % axis tight; axis square; box off;
  % set(gca, 'xtick', [12,50,100])%, 'tickdir', 'out', 'xticklabel', []);
  % xticks([10 50 100])
  %find(freq.freq==12)
  % xticklabels({'12','50','100'})
  % set(gca, 'xticklabel', [freq.freq(10),freq.freq(50),freq.freq(100)], 'tickdir', 'out', 'xticklabel', []);
  saveas(gca,'figure18.png')

end
