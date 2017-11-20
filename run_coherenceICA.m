function  run_coherenceICA( cfgin )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Handle the coherence analysis this function will output the channels which
  %should be rejected. cfgin.restingfile='040_3_3.mat'
  %channelRej='4' %'UADC004'; %UADC004, % EEG059 Heart.
  %TODO: comment out the cleaning part.
  %Created 2017-11-20
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  %component for blinks
  [val_corBlink,idx_corBlink] = coherenceICA(cfgin,'EYE01');
  %component for heart rate
  [val_corHR,idx_corHR] = coherenceICA(cfgin,'EEG059');
  %cellfun(@createFullMatrix, cfg1, outputfile);
  %get the comp_idx for all correlation >0.52. TODO: decide on threshold.
  comp_idx1= idx_corBlink(val_corBlink>0.52)';
  comp_idx2= idx_corHR(val_corHR>0.52);

  if isempty(comp_idx1) & ~isempty(comp_idx2)
    comp_idx=comp_idx2;
  elseif isempty(comp_idx2) & ~isempty(comp_idx1)
    comp_idx=comp_idx2;
  elseif isempty(comp_idx2) && isempty(comp_idx1)
    comp_idx = [];
  else
    comp_idx = [comp_idx1;comp_idx2]';

  end
  comp_idx=unique(comp_idx);

  disp(sprintf('\n\nIdentified components: %s',num2str(comp_idx)))
  add_comps=0
  if add_comps
    resp_add = input('\nChange components? 1-add, 2-remove 3-same \n\n ','s')

    switch resp_add
    case '1'
      while strcmp(resp_add,'1')
        disp(sprintf('\n\nIdentified components: %s',num2str(comp_idx)))
        comp_idx(end+1) = input('Extra components: ')
        resp_add = input('\nChange components? 1-add, 2-remove 3-same \n\n ','s')
      end
    case '2'
      while strcmp(resp_add,'2')
        disp(sprintf('\n\nIdentified components: %s',num2str(comp_idx)))
        comp_idx_rem = input('Index remove: ');
        comp_idx(comp_idx_rem)=[];
        resp_add = input('\nChange components? 1-add, 2-remove 3-same \n\n ','s')
      end
    end
  end


  %TODO: Save the removed components, as well as what they look like, for a final inspection. 
  %remove_ICA(cfgin,comp_idx)


  %Decide where to save the component to reject information,
  %or remove them directly and finish the preprocessing.





end
