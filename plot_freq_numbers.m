function plot_freq_numbers(~)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Created 2018-02-22
%Load spectral decomposition of all numbers data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/freq')

  freq_files = dir('*.mat')

  mat_freq = zeros(length(freq_files),269,641);

  for ifreq = 1:length(freq_files)

    disp(ifreq)
    load(freq_files(ifreq).name)

    mat_freq(ifreq,:,:)=freq.powspctrm(1:269,:);

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
  saveas(gca,'figure17.png')

end
