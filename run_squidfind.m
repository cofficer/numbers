
%%Main find squid jumps

%Change the folder to where MEG data is contained
cd('/mnt/homes/home024/ktsetsos/resting')

%Store all the seperate data files
restingpaths = dir('*.mat');


for icfg = 1:1%length(restingpaths)

    cfgin{icfg}.restingfile             = restingpaths(icfg).name;%40 100. test 232, issues.
    %cfgin=cfgin{1}
end

jumps_total=findSquidJumps( ~ )