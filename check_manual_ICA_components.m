function comp=check_manual_ICA_components(blocktype)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  %Defined components to be removed for each dataset
  %Created 2018-01-29
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Trial datasets.

  if strcmp(blocktype,'trial')
    comp.P1_1_1=[6,10,11];
    comp.P1_1_2=[14,11,9];
    comp.P1_1_3=[8,12,18];
    comp.P1_2_1=[11,13,18];
    comp.P1_2_2=[10,17,18]; %- missed
    comp.P1_2_3=[15,17,18]; %- missed
    comp.P1_3_1=[8,9,14];
    comp.P1_3_2=[6,12,20];
    comp.P1_3_3=[12,14,15];

    comp.P2_1_1=[4,17,21];
    comp.P2_1_2=[7,18,23];
    comp.P2_1_3=[5,19,24];
    comp.P2_2_1=[3,16,17];
    comp.P2_2_2=[1,12,13];
    comp.P2_2_3=[1,11,20];
    comp.P2_3_1=[1,17,28];
    comp.P2_3_2=[1,19,32];
    comp.P2_3_3=[1,9,31]; %-missed 42

    comp.P4_1_1=[2,5,12];
    comp.P4_1_2=[2,3,11];
    comp.P4_1_3=[1,3,5]; %- all missed
    comp.P4_2_1=[6,7,12];
    comp.P4_2_2=[6,8,12];
    comp.P4_2_3=[8,9,12];
    comp.P4_3_1=[10,14,22];
    comp.P4_3_2=[11,15,19];
    comp.P4_3_3=[4,15,19];

    comp.P5_1_1=[3,7,19];
    comp.P5_1_2=[4,9,30];
    comp.P5_1_3=[6,12,28];
    comp.P5_2_1=[11,13,17];
    comp.P5_2_2=[7,8,16,40];
    comp.P5_2_3=[6,13,24];
    comp.P5_3_1=[7,10,11];
    comp.P5_3_2=[5,6,9];
    comp.P5_3_3=[6,8,10]; %- one too many 29

    comp.P6_1_1=[4,7,12]; %- missed
    comp.P6_1_2=[6,12,16];
    comp.P6_1_3=[3,5,10];
    comp.P6_2_1=[1,3,13];
    comp.P6_2_2=[1,2,9];
    comp.P6_2_3=[1,2,8,17];
    comp.P6_3_1=[3,6,16];
    comp.P6_3_2=[4,7,15];
    comp.P6_3_3=[2,3,11];

    comp.P7_1_1=[1,2,17];
    comp.P7_1_2=[1,3,17,21]; %-missed
    comp.P7_1_3=[1,4,16,23]; %-missed
    comp.P7_2_1=[2,4,24,26]; %-missed - not sure on these 3, could just be frontal...
    comp.P7_2_2=[1,3,18,29];
    comp.P7_2_3=[2,3,12,21]; %-missed 12
    comp.P7_3_1=[1,6,20];
    comp.P7_3_2=[1,12,15];
    comp.P7_3_3=[1,9];

    comp.P8_1_1=[3,12,21];
    comp.P8_1_2=[3,11];
    comp.P8_2_1=[1,7,16];
    comp.P8_2_2=[1,5,14];
    comp.P8_2_3=[2,6,19];
    comp.P8_3_1=[6,14,31,50];
    comp.P8_3_2=[1,3,25]; %- missed, 3 too many/
    comp.P8_3_3=[1,5,27];

    comp.P11_1_1=[7,10,16];
    comp.P11_1_2=[3,10,11];
    comp.P11_1_3=[2,11,14];
    comp.P11_2_1=[2,7,8];
    comp.P11_2_2=[3,11,12];
    comp.P11_2_3=[2,8,10]; %- missed, 20 no need to remove.
    comp.P11_3_1=[3,6,9];
    comp.P11_3_2=[6,7,10];
    comp.P11_3_3=[4,5,9];

    comp.P12_1_1=[3,4,24];
    comp.P12_1_2=[3,8,22];
    comp.P12_1_3=[4,7,25];
    comp.P12_2_1=[1,10,25]; %-missed the 10
    comp.P12_2_2=[5,8,25];
    comp.P12_2_3=[7,9,25];
    comp.P12_3_1=[2,5,23];
    comp.P12_3_2=[4,5,25];
    comp.P12_3_3=[4,5,24];

    comp.P13_1_1=[3,10,16];
    comp.P13_1_2=[4,13,17];
    comp.P13_1_3=[5,12,16];
    comp.P13_2_1=[6,7,19]; %- missed 6
    comp.P13_2_2=[4,6,17];
    comp.P13_2_3=[8,9,23];
    comp.P13_3_1=[7,8,22,24];
    comp.P13_3_2=[2,9,24,25];
    comp.P13_3_3=[2,10,26,28];

    comp.P14_1_1=[1,2,14];
    comp.P14_1_2=[1,3,12];
    comp.P14_1_3=[1,4,15];
    comp.P14_2_1=[1,4,10,23]; %- missed 23, and auto 24 instead
    comp.P14_2_2=[1,2,7]; %- removed 38, wrong
    comp.P14_2_3=[1,3,10]; %- removed 26, wrong
    comp.P14_3_1=[1,3,15];
    comp.P14_3_2=[1,3,11];
    comp.P14_3_3=[1,5,14];

    comp.P15_1_1=[6,26,33];
    comp.P15_1_2=[7,27,30];
    comp.P15_1_3=[7,26,28];
    comp.P15_2_1=[4,20,27];
    comp.P15_2_2=[5,20,26]; %- removed 56 not necessary
    comp.P15_2_3=[3,14]; %- removed 63 not necessary
    comp.P15_3_1=[22,27,32]; %- missed 22, removed 73 not ness
    comp.P15_3_2=[6,27,31];
    comp.P15_3_3=[1,25,38]; %removed 65 not necessary -----59

    comp.P17_1_1=[4,8,17];
    comp.P17_1_2=[6,9,16];
    comp.P17_1_3=[3,9,19];
    comp.P17_2_1=[2,7,14];
    comp.P17_2_2=[4,5,19];
    comp.P17_2_3=[1,4,16];
    comp.P17_3_1=[3,11,17];
    comp.P17_3_2=[2,7,20,22];
    comp.P17_3_3=[]; %-Consider fixing all the channels that were removed. Strange ICA.

    comp.P18_1_1=[15,27];
    comp.P18_1_2=[7,25]; %removed 41, not necessary
    comp.P18_1_3=[3,29,36]; %removed 38 not necessary
    comp.P18_2_1=[4,24,29,31];
    comp.P18_2_2=[2,22,27];
    comp.P18_2_3=[4,19,21];
    comp.P18_3_1=[6,28,33];
    comp.P18_3_2=[9,28,34];
    comp.P18_3_3=[8,27,35];

    comp.P19_1_1=[9,14,16];
    comp.P19_1_2=[10,13,16];
    comp.P19_1_3=[7,13,14];
    comp.P19_2_1=[15,22,23];
    comp.P19_2_2=[15,19,21];
    comp.P19_2_3=[11,14,15];
    comp.P19_3_1=[6,10,12]; %missed 10, not necessary 28
    comp.P19_3_2=[2,11,13];
    comp.P19_3_3=[7,10,12];

    comp.P20_1_1=[7,13,16]; %missed 7,not necessary 4
    comp.P20_1_2=[5,14,15];
    comp.P20_1_3=[5,13,15];
    comp.P20_2_1=[2,16,18]; %missed 2, not necessary 49
    comp.P20_2_2=[7,15,16]; %missed 7, not necessary 77
    comp.P20_2_3=[8,16,18];
    comp.P20_3_1=[3,13,16];
    comp.P20_3_2=[6,11,18];
    comp.P20_3_3=[3,13,16]; %missed all comcomp.Ponents

    comp.P21_1_1=[1,10,21];
    comp.P21_1_2=[2,15];
    comp.P21_1_3=[4,10,23,24];
    comp.P21_2_1=[2,3,21];
    comp.P21_2_2=[2,5];
    comp.P21_2_3=[2,4,31];
    comp.P21_3_1=[2,5,23];
    comp.P21_3_2=[5,11]; %missed all comcomp.Ponents

    comp.P22_1_1=[5,11,19]; %missed 19, removed 62 not necessary
    comp.P22_1_2=[6,13,14]; %missed 14, removed 75 not necessary
    comp.P22_1_3=[5,7,12]; %missed 5, removed 64 not nnecessary
    comp.P22_2_1=[8,9,17,36]; %missed 17,
    comp.P22_2_2=[6,8,17,133]; %missed 17
    comp.P22_2_3=[7,8,32];
    comp.P22_3_1=[7,8,18]; %missed 18, removed 10 not necessary
    comp.P22_3_2=[8,10,15]; %missed 15, removed 12 not necessary
    comp.P22_3_3=[6,9,20]; %missed 20, removed 15, not necessary, tricky actually

    comp.P23_1_1=[9,19,25];
    comp.P23_1_2=[17,18];
    comp.P23_1_3=[17,18];
    comp.P23_2_1=[17,22,29];
    comp.P23_2_2=[14,15];
    comp.P23_2_3=[12,22];
    comp.P23_3_1=[12,18,28];
    comp.P23_3_2=[13,17,25];
    comp.P23_3_3=[11,17];
    comp.P23_3_4=[16,15,19];
    comp.P23_3_5=[13,21,30];

    %Look deecomp.Per into comp.Part 24. Might just be that the removal of channels is a
    %huge issue, just like comp.Peter suggested.
    %Maybe just disregard this whole comp.Particicomp.Pant?
    comp.P24_1_1=[]; %-removed way too many channels.
    comp.P24_1_2=[11,22]; %removed 2 not necessary, channel removal issue? Could be movement?
    comp.P24_1_3=[15,26];
    comp.P24_2_1=[18,19]; %removed too many comcomp.Ponents, 2,63,274.
    comp.P24_2_2=[15,19,20]; %comcomp.Ponents like strange in general. Many hannels removed
    comp.P24_2_3=[17,24]; %removed 3 not necessary. 1 channels removed. 40mm movement.
    comp.P24_3_1=[14,23]; %removed 4,7 not necessary. Channels removed look like eyelink... Worth looking into.
    comp.P24_3_2=[19,26]; %removed channels look strange, might be tracking head movement...
    comp.P24_3_3=[26,28];%? %removed 34 not necessary. Still strange comcomp.Ponents.

    comp.P26_1_1=[14,15,16];
    comp.P26_1_2=[12,17,24];
    comp.P26_1_3=[16,17,19];
    comp.P26_2_1=[13,16,20];
    comp.P26_2_2=[12,15,18];
    comp.P26_2_3=[13,14,21]; %missed 13, not necessary 73
    comp.P26_3_1=[17,21,23];
    comp.P26_3_2=[18,21,25]; %not necessary 43
    comp.P26_3_3=[16,26,29];

    comp.P27_1_1=[1,3,6];
    comp.P27_1_2=[3,5,10]; %not necessary 25
    comp.P27_1_3=[2,3,5]; %not necessary 47
    comp.P27_2_1=[1,2,6]; %missed 6, not necessary 10
    comp.P27_2_2=[1,4,8];
    comp.P27_2_3=[1,3,4];
    comp.P27_3_1=[1,2,4]; %not necessary 26
    comp.P27_3_2=[1,2,3]; %not necessary 20
    comp.P27_3_3=[1,2,3]; %not necessary 18, actually 3 comp.Past datasets, same half-artifact looking comcomp.Ponent.


    comp.P28_1_1=[6,8,10];
    comp.P28_1_2=[4,9,10];
    comp.P28_1_3=[1,8,9];
    comp.P28_2_1=[5,8,9];
    comp.P28_2_2=[4,11,13];
    comp.P28_2_3=[4,10,12];
    comp.P28_3_1=[5,9,12];  %missed 5, not necessary 10
    comp.P28_3_2=[6,12,15]; %missed 6, not necessary 13
    comp.P28_3_3=[3,13,18];

    comp.P29_1_1=[6,7,15]; %missed 6, not necessary 19
    comp.P29_1_2=[7,8,19,43];
    comp.P29_1_3=[8,9,17];
    comp.P29_2_1=[3,4,10];
    comp.P29_2_2=[5,7,11];
    comp.P29_2_3=[6,9,11];
    comp.P29_3_1=[4,6,15,263]; %not necessary 263, looks artifactual though
    comp.P29_3_2=[3,6,11];
    comp.P29_3_3=[4,6,10];

    comp.P30_1_1=[2,20,24];
    comp.P30_1_2=[4,23,34];
    comp.P30_1_3=[4,25,29];
    comp.P30_2_1=[2,14,22];
    comp.P30_2_2=[6,17,25];
    comp.P30_2_3=[9,24,29];
    comp.P30_3_1=[1,14,18];
    comp.P30_3_2=[2,18,22];
    comp.P30_3_3=[5,21,23]; %missed 5, not necessary 16

    comp.P31_1_1=[12,13,20];
    comp.P31_1_2=[6,12,18];
    comp.P31_1_3=[6,10,17];
    comp.P31_2_1=[7,13,17];
    comp.P31_2_2=[8,12,15];
    comp.P31_2_3=[7,11,14];
    comp.P31_3_1=[7,11,13];
    comp.P31_3_2=[5,8,12];
    comp.P31_3_3=[8,10,13];

    comp.P32_1_1=[1,3,4]; %missed 4, not necessary 12
    comp.P32_1_2=[1,2,3];
    comp.P32_1_3=[1,2,3];
    comp.P32_2_1=[1,2,4];
    comp.P32_2_2=[1,2,3];
    comp.P32_2_3=[1,2,3];
    comp.P32_3_2=[1,2,3];
    comp.P32_3_3=[1,2,3];

    %Several datsets with massive headm
    comp.P33_1_1=[4,10,12];
    comp.P33_1_2=[5,7];
    comp.P33_1_3=[]; %Massive head movement, weird comcomp.Ponents, many channels removed.
    comp.P33_2_1=[1,11,12];
    comp.P33_2_2=[1,6,10,251];
    comp.P33_2_3=[3,4,7]; %many removed channels, lots of head movement....
    comp.P33_3_1=[2,6,13];
    comp.P33_3_2=[2,6];
    comp.P33_3_3=[1,7,8];


    comp.P34_1_1=[4,10,13];
    comp.P34_1_2=[4,10,15,20,22];
    comp.P34_1_3=[7,10,14,19];
    comp.P34_2_1=[9,10,14,18];
    comp.P34_2_2=[8,12,14,20];
    comp.P34_2_3=[6,8,17,19];
    comp.P34_3_1=[4,6,9,19];
    comp.P34_3_2=[5,9,13,19];
    comp.P34_3_3=[6,12,14,19];

    comp.P35_1_1=[14,15,22];
    comp.P35_1_2=[16,18,21];
    comp.P35_1_3=[14,17,21];
    comp.P35_2_1=[13,17,18];
    comp.P35_2_2=[16,17,20];
    comp.P35_2_3=[13,14,18]; %not necessary 34
    comp.P35_3_2=[19,23,26];
    comp.P35_3_3=[19,24,27];
    comp.P35_3_4=[22,28,29];

    %Many massive movements for 5 datasets
    comp.P36_1_1=[2,8,13]; %Missed 8, not necessary 21
    comp.P36_1_2=[2,4,12]; %Missed 4, not necessary 8
    comp.P36_1_3=[3,4,11];
    comp.P36_2_1=[1,2,9];
    comp.P36_2_2=[1,5,9,14];
    comp.P36_2_3=[1,2,7,22];
    comp.P36_3_1=[1,2,11];
    comp.P36_3_2=[1,2,11];
    comp.P36_3_3=[1,2,12];

    %Some jumcomp.Ps and removed channels.
    comp.P37_1_1=[11,17];
    comp.P37_1_2=[13,21];
    comp.P37_1_3=[13,15];
    comp.P37_2_1=[10,12];
    comp.P37_2_2=[10,12];
    comp.P37_2_3=[17,18];
    comp.P37_3_1=[10,11];
    comp.P37_3_2=[13,14];
    comp.P37_3_3=[9,10];

    %Last 3_3, lots of jumcomp.Ps and channel removals.
    %Many comcomp.Ponents look strange, jittered. Headm looks shaky.
    %Many comcomp.Ponents variances looks strange too.
    comp.P38_1_1=[3,6,8];
    comp.P38_1_2=[4,5,11];
    comp.P38_1_3=[3,4,17];
    comp.P38_2_1=[2,3,17];
    comp.P38_2_2=[2,4,18];
    comp.P38_2_3=[1,3,7];
    comp.P38_3_1=[2,4,15];
    comp.P38_3_2=[3,4,11];
    comp.P38_3_3=[3,4,12];

    %A coucomp.Ple bad headm, last many jumcomp.Ps and channel removal.
    comp.P39_1_1=[28,29,37];
    comp.P39_1_2=[27,29,36]; %not necessary 41
    comp.P39_1_3=[25,28,33];
    comp.P39_2_1=[28,31,34,39];
    comp.P39_2_2=[29,30,33]; %not necessary 40
    comp.P39_2_3=[25,32,36,42];
    comp.P39_3_1=[24,28,31];
    comp.P39_3_2=[22,24,28];
    comp.P39_3_3=[22,26,36];

    %Good headm, but quite few jumcomp.Ps in a coucomp.Ple of the datasets.
    comp.P40_1_1=[6,9,18];
    comp.P40_1_2=[4,10,18];
    comp.P40_1_3=[4,8,12];
    comp.P40_2_1=[1,3,10,28,29]; %Missed 3 and 10, not necessary 36, 139, 209
    comp.P40_2_2=[3,7,31];
    comp.P40_2_3=[3,11,25];
    comp.P40_3_1=[5,6,11];
    comp.P40_3_2=[6,7,9];
    comp.P40_3_3=[3,4,12];

    %2_2 bad headm, 2_3 many jumcomp.Ps, 3_1 bad headm, 3_2 bad headm, 3_3 bad headm,
    comp.P41_1_2=[1,2,12,21];
    comp.P41_1_3=[1,3,12];
    comp.P41_1_4=[2,4,13];
    comp.P41_2_1=[2,3,5,10];
    comp.P41_2_2=[1,3,7,17];
    comp.P41_2_3=[1,4,8,16]; %not sure on 16
    comp.P41_3_1=[1,2,8,21]; %missed 1
    comp.P41_3_2=[1,2,19,27]; %missed 1, not necessary 12.
    comp.P41_3_3=[1,2,25]; %missed 1, not necessary 10

    %almost all have comp.Peaks of bad headm
    comp.P43_1_1=[27,29,35]; %missed 29, not necessary 77
    comp.P43_1_3=[24,28,44]; %missed 24, no necessary 62
    comp.P43_1_4=[24,27,39,43];
    comp.P43_2_1=[25,31,35,39]; %missed 31?
    comp.P43_2_2=[29,32,41,44]; %missed 32
    comp.P43_2_3=[26,40,42];
    comp.P43_3_1=[17,23,28,35]; %missed 23
    comp.P43_3_2=[16,24];
    comp.P43_3_3=[17,21,32];

    %A coucomp.Ple bad headm,1_1 many jumcomp.Ps.
    comp.P44_1_1=[9,16,27];
    comp.P44_1_2=[11,19,28];
    comp.P44_1_3=[11,16,29];
    comp.P44_2_1=[5,9,12];
    comp.P44_2_2=[6,10,21];
    comp.P44_2_3=[6,12,20];
    comp.P44_3_1=[16,24,26];
    comp.P44_3_2=[21,28,29];
    comp.P44_3_3=[15,28,29];

    %Looks like good headm, one jumcomp.P
    comp.P45_1_1=[9,15,33];
    comp.P45_1_2=[10,17,31];
    comp.P45_1_3=[10,21,34];
    comp.P45_2_1=[6,9,24,25]; %missed 24
    comp.P45_2_2=[9,10,33];
    comp.P45_2_3=[10,11,33];
    comp.P45_3_1=[8,18];
    comp.P45_3_2=[11,20,33];
    comp.P45_3_3=[10,19,35];

  elseif strcmp(blocktype,'resting')

    %Resting datasets
    comp.P1_2_1=[3,6,8];
    comp.P1_2_3=[10,11,15];
    comp.P1_3_1=[2,5,7];

    %The comp.Precomp.Processed seems strange comp.Power scomp.Pectrum. No hcomp.P-filter?
    comp.P2_1_1=[2,7,13];
    comp.P2_1_3=[1,8,12]; %not necessary 14
    comp.P2_2_1=[1,9,21]; %missed 9 not necessary 4,42,102
    comp.P2_3_3=[1,5,9];

    comp.P4_1_1=[2,7,8];
    comp.P4_1_3=[2,3,5]; %not necessary maybe 6
    comp.P4_2_1=[3,5,6];
    comp.P4_2_3=[3,4,5];
    comp.P4_3_1=[4,7,8];
    comp.P4_3_3=[1,6];

    comp.P5_1_1=[9,10];
    comp.P5_1_3=[10,11];
    comp.P5_2_1=[5,7,9];
    comp.P5_2_3=[6,8,23];
    comp.P5_3_1=[6,8];
    comp.P5_3_3=[5,6,26];

    comp.P6_1_1=[1,3,7]; %missed 7, not necessary 101
    comp.P6_1_3=[1,2];
    comp.P6_2_1=[1,2,3];
    comp.P6_2_3=[1,2,6];
    comp.P6_3_1=[1,2,3];
    comp.P6_3_3=[1,3,6];

    %huge headm 2_3
    comp.P7_1_1=[3,5];
    comp.P7_1_3=[3,6];
    comp.P7_2_1=[1,2];
    comp.P7_2_3=[1,2];
    comp.P7_3_1=[1,9];
    comp.P7_3_3=[1,11];

    %massive headm 2_1
    comp.P8_1_1=[1,5];
    comp.P8_2_1=[1,3];
    comp.P8_2_3=[1,4,8];
    comp.P8_3_1=[2,11];
    comp.P8_3_3=[3,7];

    comp.P11_1_1=[1,6,7];
    comp.P11_1_3=[2,3,5];
    comp.P11_2_1=[1,4,5];
    comp.P11_2_3=[1,4,12];
    comp.P11_3_1=[1,2,4];
    comp.P11_3_3=[3,4,5];

    comp.P12_1_1=[5,14,19];
    comp.P12_1_3=[5,8,17];
    comp.P12_2_1=[2,10,19,42]; %missed 10 maybe. The eye comcomp.Ponents 10 and 42, are not well differentiated
    comp.P12_2_3=[5,12,17];
    comp.P12_3_1=[5,11,13];
    comp.P12_3_3=[7,11,15];

    comp.P13_1_1=[3,5,7];
    comp.P13_1_3=[3,5,9];
    comp.P13_2_1=[3,4,8]; %missed 3, the eye artifact, not necessary 180.
    comp.P13_2_3=[5,6,9];
    comp.P13_3_1=[4,5,9];
    comp.P13_3_3=[1,4,10];

    comp.P14_1_1=[1,2,7];
    comp.P14_1_3=[1,5,12];
    comp.P14_2_1=[1,4,9]; %not necessary 20
    comp.P14_2_3=[1,4,8,21,24]; %comcomp.Ponents 21 24, there is too much eye movements. Strange
    comp.P14_3_1=[1,4,11];
    comp.P14_3_3=[1,7,10]; %not necessary 18

    %missing overview figure for some datasets.
    comp.P15_1_1=[1,13,15];
    comp.P15_1_3=[1,10,15];
    comp.P15_2_1=[1,6,7];
    comp.P15_2_3=[1,9,11];
    comp.P15_3_1=[16,17,26];
    comp.P15_3_3=[1,10];

    %16 missing from cleaned, but there are comp.Precomp.Processed figures, could redo ICA/DFA.

    comp.P17_1_1=[2,4,6];
    comp.P17_1_3=[1,4,8];
    comp.P17_2_1=[1,3,7];
    comp.P17_2_3=[1,3,5];
    comp.P17_3_1=[1,5,8];
    comp.P17_3_3=[1,3,7]; %missed 7 heartrate

    %massive headm 1_3
    comp.P18_1_1=[2,4]; %not necessary 8 and 139
    comp.P18_1_3=[6,12,15];
    comp.P18_2_1=[7,13];
    comp.P18_2_3=[2,11,12];
    comp.P18_3_1=[9,13,43];
    comp.P18_3_3=[5,15,19];

    comp.P19_1_1=[9,10,13];
    comp.P19_1_3=[3,6,14];
    comp.P19_2_1=[9,13,15]; %missed 15, not necessary 259
    comp.P19_2_3=[4,6,13]; %missed 13, not necessary 156
    comp.P19_3_1=[5,6,9,26];
    comp.P19_3_3=[3,4,6];

    %massive headm 2_1
    comp.P20_1_1=[4,5,6];
    comp.P20_1_3=[6,7,8];
    comp.P20_2_1=[2,7,8];
    comp.P20_2_3=[8,9,10];
    comp.P20_3_1=[1,4,7];
    comp.P20_3_3=[5,6,8]; %missed all comcomp.Ponents to remove.

    %massive headm 2_3
    comp.P21_1_1=[2,5,9]; %missed 9, not necessary 109
    comp.P21_1_3=[2,13,15];
    comp.P21_2_1=[2,3];
    comp.P21_2_3=[2,6,15]; %missed 6, not necessary 89
    comp.P21_3_1=[1,9];

    %massive headm 2_3, many jumcomp.Ps 3_1
    comp.P22_1_1=[7,9,12]; %missed 12, not necessary 97
    comp.P22_1_3=[4,9,12,15]; %missed 4, 15, not necessary 47
    comp.P22_2_1=[7,9,15]; %missed 15, not necessary 20
    comp.P22_2_3=[5,6,15]; %missed 15, not necessary 93
    comp.P22_3_1=[5,9,12,14]; %missed 9
    comp.P22_3_3=[5,6,13,18]; %missed 13,

    comp.P23_1_1=[6,9,11];
    comp.P23_1_3=[13,16];
    comp.P23_2_1=[8,9];
    comp.P23_2_3=[13,16]; %missed 16, not necessary 239
    comp.P23_3_1=[7,12]; %missed 12, not necessary 113
    comp.P23_3_3=[10,11];

    comp.P24_1_1=[13,15];
    comp.P24_1_3=[12,14];
    comp.P24_2_1=[12,14];
    comp.P24_2_3=[15,17];
    comp.P24_3_1=[12,13,17];
    comp.P24_3_3=[10,15]; %not necessary 91

    comp.P26_1_1=[9,10,11];
    comp.P26_1_3=[7,8,12]; %missed 12, not necessary 163
    comp.P26_2_1=[6,8,14]; %missed 14, not necessary 241
    comp.P26_2_3=[8,9,12]; %missed 12, not necessary 15
    comp.P26_3_1=[11,12,20]; %missed 20, not necessary 131
    comp.P26_3_3=[11,16,19];

    comp.P26_1_1=[9,10,11];
    comp.P26_1_3=[7,8,12]; %missed 12, not necessary 163
    comp.P26_2_1=[6,8,14]; %missed 14, not necessary 241
    comp.P26_2_3=[8,9,12]; %missed 12, not necessary 15
    comp.P26_3_1=[11,12,20]; %missed 20, not necessary 131
    comp.P26_3_3=[11,16,19]; %missed 19, not necessary 9

    comp.P27_1_1=[2,3,6];
    comp.P27_1_3=[6,7,11];
    comp.P27_2_1=[3,5,9];
    comp.P27_2_3=[4,5,12]; %not necessary 21
    comp.P27_3_1=[1,3,5];
    comp.P27_3_3=[2,7,9];

    comp.P28_1_1=[1,6,7];
    comp.P28_1_3=[1,6,7];
    comp.P28_2_1=[2,4,5];
    comp.P28_2_3=[1,5,6];
    comp.P28_3_1=[2,3,4];
    comp.P28_3_3=[2,3,4];

    comp.P29_1_1=[4,8,9];
    comp.P29_1_3=[4,8,10];
    comp.P29_2_1=[2,6,7];
    comp.P29_2_3=[4,6,7];
    comp.P29_3_1=[3,5,8];
    comp.P29_3_3=[3,8,13];

    comp.P30_1_1=[7,19,24];
    comp.P30_1_3=[11,14,20];
    comp.P30_2_1=[8,10,15]; %not necessary 78
    comp.P30_2_3=[9,13,15];
    comp.P30_3_1=[14,17,22];
    comp.P30_3_3=[6,8,9];

    %large headm 1_1
    comp.P31_1_1=[10,16,18];
    comp.P31_1_3=[6,12,15];
    comp.P31_2_1=[8,12,13];
    comp.P31_2_3=[6,11,15];
    comp.P31_3_1=[6,10,17];
    comp.P31_3_3=[8,11,12];

    comp.P32_1_1=[1,4,5];
    comp.P32_1_3=[1,5,6];
    comp.P32_2_1=[1,3,4];
    comp.P32_2_3=[1,2,3];
    comp.P32_3_3=[1,3,5];

    %many jumcomp.Ps 1_1, strange comcomp.Ponents.
    comp.P33_1_1=[5,6,11];
    comp.P33_1_3=[3,4,8];
    comp.P33_2_1=[1,4];
    comp.P33_2_3=[3,4,5];
    comp.P33_3_1=[3,4];

    %large headm 3_3
    comp.P34_1_1=[4,10,14,16];
    comp.P34_1_3=[6,9,13,15];
    comp.P34_2_1=[5,7,12];
    comp.P34_2_3=[7,8,10,12];
    comp.P34_3_1=[5,10,13];
    comp.P34_3_3=[7,9,10];

    comp.P35_1_1=[2,13,15];
    comp.P35_1_3=[3,16,18]; %missed 3, not necessary 37
    comp.P35_2_1=[2,15,18];
    comp.P35_2_3=[14,15,16];
    comp.P35_3_1=[10,16,18];
    comp.P35_3_3=[13,18,19];

    comp.P36_1_1=[1,5,6];
    comp.P36_1_3=[3,7]; %missed 7, not necessary 36
    comp.P36_2_1=[1,5]; %not necessary 202
    comp.P36_2_3=[1,5,6];
    comp.P36_3_1=[1,3,4];
    comp.P36_3_3=[1,5,7];

    comp.P37_1_1=[6,9];
    comp.P37_1_3=[8,12];
    comp.P37_2_1=[6,7];
    comp.P37_2_3=[8,14];
    comp.P37_3_1=[8,10]; %missed 10, not necessary 67
    comp.P37_3_3=[7,10];

    %large headm, 2_3, 3_1. many jumcomp.Ps 3_3.
    comp.P38_1_1=[1,2,4];
    comp.P38_1_3=[1,3,5];
    comp.P38_2_1=[1,2,7];
    comp.P38_2_3=[1,2,6];
    comp.P38_3_1=[1,2];
    comp.P38_3_3=[1,2,5,12]; %missed 1,5. Not necessary 35. Jumcomp.Ps make it difficult.

    %several datasets, massive headm
    comp.P39_1_1=[20,23,26];
    comp.P39_1_3=[15,18,26];
    comp.P39_2_1=[15,25,27];
    comp.P39_2_3=[12,13,20];
    comp.P39_3_1=[20,23,27];
    comp.P39_3_3=[12,19,34];

    %last dataset, many jumcomp.Ps.
    comp.P40_1_1=[8,9,16];
    comp.P40_1_3=[5,10,18];
    comp.P40_2_1=[4,5,13];
    comp.P40_2_3=[2,9,19];
    comp.P40_3_1=[6,11,15];
    comp.P40_3_3=[4,12,22];

    %last dataset some headm
    comp.P41_1_1=[1,2,9];
    comp.P41_1_3=[1,2,7];
    comp.P41_2_1=[1,2,6]; %not necessary 12
    comp.P41_2_3=[1,5,7,8]; %missed 5, not necessary 11
    comp.P41_3_1=[1,2,14];
    comp.P41_3_3=[1,2,12];

    comp.P43_1_1=[16,26,42,76]; %missed maybe 26
    comp.P43_1_3=[16,17];
    comp.P43_2_1=[24,32,40]; %missed 40, not necessary 235
    comp.P43_2_3=[14,18,31,151]; %missed 18, 151
    comp.P43_3_1=[10,21,27]; %missed 21
    comp.P43_3_3=[19,22]; %not necessary 33,60,84,119,160

    %many jumcomp.Ps 1_1. large headm 2_1
    comp.P44_1_1=[12,18,24];
    comp.P44_1_3=[17,19,25];
    comp.P44_2_1=[9,13,19];
    comp.P44_2_3=[16,17,21];
    comp.P44_3_1=[11,20,22];
    comp.P44_3_3=[16,20,28];

    comp.P45_1_1=[10,12,20];
    comp.P45_1_3=[12,17,21];
    comp.P45_2_1=[5,7,12];
    comp.P45_2_3=[8,10];
    comp.P45_3_1=[9,13]; %not necessary 74
    comp.P45_3_3=[9,15,19];
  end
end
