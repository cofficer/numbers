function [UADChan,meg_eyelinkScale(UADChan)]=identify_MegEyelinkChan(meg_eyelink,dat_eye)
%The purpose is to find which of the two channels 003 and 004 contain the pupil dilations
%Need to append Eyelink to MEG. Why not just do so? 

  %Store each label as its own variable
  firsteye    = (dat_eye.asc.trial{1}(1,1:end));
  secondeye   = (dat_eye.asc.trial{1}(2,1:end));
  thirdeye    = (dat_eye.asc.trial{1}(3,1:end));
  fourtheye   = (dat_eye.asc.trial{1}(4,1:end)); %Pupil dilation.
  fiftheye    = (dat_eye.asc.trial{1}(5,1:end));

  %Cell operation
  for numChan  = 1:2
    meg_eyelinkScale(numChan,:) = -1 + 2.*(meg_eyelink.trial{1}(numChan,:) - min(meg_eyelink.trial{1}(numChan,:)))./(max(meg_eyelink.trial{1}(numChan,:)) - min(meg_eyelink.trial{1}(numChan,:)));

    %Rescale the meg end eyelink pupil data.
    %meg_eyelinkScale = -1 + 2.*(meg_eyelink.trial - min(meg_eyelink.trial))./(max(meg_eyelink.trial) - min(meg_eyelink.trial));
    eyelink_four = -1 + 2.*(fourtheye - min(fourtheye))./(max(fourtheye) - min(fourtheye));
    %Equalize the length of data.
    eyelink_fourScale = [ones(1,length(meg_eyelink.trial{1})-length(eyelink_four)),eyelink_four];

    meanDiff(numChan)=mean(meg_eyelinkScale(numChan,:))-mean(eyelink_fourScale);

    %Using two different scales, one for each channel. Probably not necessary
    eyelink_fourScale=eyelink_fourScale(1,:)+meanDiff(numChan);

    wannaPlot = 0;

    if wannaPlot
      sampleDef = 1:length(meg_eyelink.trial{1});
      figure(1),clf
      plot(meg_eyelinkScale2(1,sampleDef))
      hold on
      meanDiff=mean(meg_eyelinkScale2(sampleDef))-mean(eyelink_fourScale(sampleDef));
      plot(eyelink_fourScale(1,sampleDef)+meanDiff)
      legend('meg', 'eyelink')

      saveas(gca,[currpath,'compeyelinkmeg.png'],'png')
    end
    %Figure out a function for identifying the correct channels...
    %One way is to compute the covariance of the two vectors, and pick the highest channel.
    covarianceM(numChan) = corr(meg_eyelinkScale(numChan,:)',eyelink_fourScale');

  end

      [~,UADChan]=max(covarianceM )

end
