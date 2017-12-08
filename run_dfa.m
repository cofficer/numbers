function run_dfa(cfgin)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Run Tom Pfeffer's implementation of DFA analysis, on restin
  %and trial based data
  %Created 2017-11-28
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  try
    if strcmp(cfgin.blocktype,'resting')
      %define ds file, this is actually from the trial-based data
      if strcmp(cfgin.restingfile(1),'0')
        dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/cleaned/P0%s_S%s_P%s.mat',cfgin.blocktype,cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
        savefile= sprintf('P0%s_S%s_B%s.mat',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
      else
        dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/cleaned/P%s_S%s_P%s.mat',cfgin.blocktype,cfgin.restingfile(1:2),cfgin.restingfile(5),cfgin.restingfile(8));
        savefile= sprintf('P%s_S%s_B%s.mat',cfgin.restingfile(1:2),cfgin.restingfile(5),cfgin.restingfile(8));
      end
    elseif strcmp(cfgin.blocktype,'trial')
      %load clean data
      if strcmp(cfgin.restingfile(3),'_')
        dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/cleaned/P%s_s%s_b%s.mat',cfgin.blocktype,cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
        savefile= sprintf('P%s_s%s_b%s.mat',cfgin.restingfile(2),cfgin.restingfile(5),cfgin.restingfile(8));
      else
        dsfile = sprintf('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/%s/cleaned/P%s_s%s_b%s.mat',cfgin.blocktype,cfgin.restingfile(2:3),cfgin.restingfile(6),cfgin.restingfile(9));
        savefile= sprintf('P%s_s%s_b%s.mat',cfgin.restingfile(2:3),cfgin.restingfile(6),cfgin.restingfile(9));
      end
    end
    %P08_S2_P1.mat, P08_S3_P1.mat
    load(dsfile)

    %Define bandpass intervals
    intervals = [2 4;4 8;8 12;12 24];

    for i_val = 1:length(intervals)
      disp(i_val)
      %bandpass filter signal
      cfg =[];
      cfg.bpfreq = intervals(i_val,:);
      cfg.bpfilter='yes';
      cfg.bpfilttype='but';
      cfg.channel = 'MEG';
      dataBP=ft_preprocessing(cfg,data);

      %compute the amplitude envelope
      dataBP.trial{1}=abs(hilbert(dataBP.trial{1}));
      %Compute DFA
      % Uses the following inputs:
      % x:        signal to be analyzed
      % win:      length of fitting window in seconds (default: [1 50])
      % Fs:       sampling rate
      % overlap:  overlap of windows (default: 0.5)
      % binnum:   number of time bins for fitting (default: 10)
      if strcmp(cfgin.blocktype,'resting')
        win = [3 30];
      else
        win = [3 50];
      end
      Fs  = 500;
      overlap = 0.5;
      binnum = 10;
      dfa = tp_dfa(dataBP.trial{1}',win,Fs,overlap,binnum)

      dfa_all{i_val}=dfa;

    end

    if strcmp(cfgin.blocktype,'resting')
      cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/DFA')
    else
      cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/trial/DFA')
    end

    save(savefile,'dfa_all')


    %TODO: Check the number of components removed from each participant.
    %TODO: Figure out best way of storage.
    %TODO: Decide on loops, need to compute for each freq band. Maybe cluster is
    %TODO: Append the data from same session
    %TODO: Re-run all DFAs
    %better after all.



  catch err

    cd('/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/')
    fid=fopen('logfile_dfa','a+');
    c=clock;
    fprintf(fid,sprintf('\n\n\n\nNew entry for %s at %i/%i/%i %i:%i\n\n\n\n',cfgin.restingfile,fix(c(1)),fix(c(2)),fix(c(3)),fix(c(4)),fix(c(5))))

    fprintf(fid,'%s',err.getReport('extended','hyperlinks','off'))

    fclose(fid)

  end
end
