function findMEGdatatype(~)
%I really need to know which files have the combined_dat and which only have data...
cd('/home/chrisgahn/Documents/MATLAB/ktsetsos/resting/eyedat/')

%Store all the seperate data files
restingpaths = dir('*.mat');

%Loop all data files into seperate jobs
rawpath = '/mnt/homes/home024/chrisgahn/Documents/MATLAB/ktsetsos/resting/raw/';
cd(rawpath)

for icfg = 1:length(restingpaths)

    %dat             = restingpaths(icfg).name;%40 100. test 232, issues.
    %cfgin=cfgin{1}

    if restingpaths(icfg).name(7)=='2'
      restingpaths(icfg).name(7) ='3';
    end
    dsfile =sprintf('%s%s_S%s_P%s.mat',rawpath,restingpaths(icfg).name(2:3),restingpaths(icfg).name(5),restingpaths(icfg).name(7))
    dat = load(dsfile)

end


end
