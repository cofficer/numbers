function  data=run_coherenceICA( varargin )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Handle the coherence analysis this function will output the channels which
  %should be rejected. cfgin.restingfile='040_3_3.mat'
  %channelRej='4' %'UADC004'; %UADC004, % EEG059 Heart.
  %TODO: comment out the cleaning part.
  %Created 2017-11-20
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  cfgin=varargin{1};
  %component for blinks
  %cfgin=ab{6} %redo comp '15_S3_P3.mat'. PART 43, no comp!!

  %Decide to load manually defined components or compute automatic rejection
  if strcmp(cfgin.comp,'manual')
    comp=check_manual_ICA_components(cfgin.blocktype);
    if strcmp(cfgin.blocktype,'trial')
      if strcmp(cfgin.restingfile(3),'_')
        dataset=sprintf('P%s_%s_%s',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
      else
        dataset=sprintf('P%s_%s_%s',cfgin.restingfile(2:3),cfgin.restingfile(6),cfgin.restingfile(9));
      end
    elseif strcmp(cfgin.blocktype,'resting')
      if strcmp(cfgin.restingfile(1),'0')
        dataset=sprintf('P%s_%s_%s',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
      else
        dataset=sprintf('P%s_%s_%s',cfgin.restingfile(1:2),cfgin.restingfile(5),cfgin.restingfile(8));
      end
    end
    comp_idx=comp.(dataset);
  else
    try
      %Convert coherenceICA to varargin...
      if isfield(cfgin,'runblock')
        data=varargin{2};
        comp=varargin{3};
        [val_corBlink,idx_corBlink] = coherenceICA(cfgin,'EYE01',data,comp);
      else
        [val_corBlink,idx_corBlink] = coherenceICA(cfgin,'EYE01');
      end

    catch err

        cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/')
        fid=fopen('logfile_noEYE01','a+');
        c=clock;
        fprintf(fid,sprintf('\n\n\n\nNew entry for %s at %i/%i/%i %i:%i\n\n\n\n',cfgin.restingfile,fix(c(1)),fix(c(2)),fix(c(3)),fix(c(4)),fix(c(5))))

        fprintf(fid,'%s',err.getReport('extended','hyperlinks','off'))

        fclose(fid)

        if isfield(cfgin,'runblock')
          data=varargin{2};
          comp=varargin{3};
          [val_corBlink,idx_corBlink] = coherenceICA(cfgin,'EEG058',data,comp);
        else
          [val_corBlink,idx_corBlink] = coherenceICA(cfgin,'EEG058');
        end
    end
    %component for heart rate
    if isfield(cfgin,'runblock')
      [val_corHR,idx_corHR] = coherenceICA(cfgin,'EEG059',data,comp);
    else
      [val_corHR,idx_corHR] = coherenceICA(cfgin,'EEG059');
    end
    %cellfun(@createFullMatrix, cfg1, outputfile);
    %get the comp_idx for all correlation >0.52. TODO: decide on threshold.

    comp_idx1= idx_corBlink(val_corBlink>0.70)';
    comp_idx2= idx_corHR(val_corHR>0.50);

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
    %comp_idx=[1,2,3]

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
  end

  %TODO: Save the removed components, as well as what they look like, for a final inspection.
  data=remove_ICA(cfgin,comp_idx,data,comp);


  %Decide where to save the component to reject information,
  %or remove them directly and finish the preprocessing.





end
