# Numbers
# Preprocessing 

The preprocessing pipeline is executed from main_parallel_Numbers.m.
The purpose of main_parallel_Numbers.m is to create cfg structures for each separate 
dataset to be analyzed. Many different types of analyses can be executed from this script. 
But to run preprocessing, define runcfg.execute  = 'preprocTrial', for trial based data or
'parallel' for resting based data.

main_parallel_Numbers then calls function run_parallel_Numbers.m which submits every job to cluster.
There are 7 different analyses which can be run from there. Three of these are defined here below.

# ICA
Change setting in main_parallel_Numbers.m to runcfg.execute  = 'ICA' to run
the independen component analysis. 

# Reject ICA components
Change setting in main_parallel_Numbers.m to runcfg.execute  = 'cohICA' to run
the component rejection of blinks and heart rates. This is done automatically
with the threshold setting of coherence correlation 0.5 between ICA components 
and spectrally decomposed artifacts.

# DFA
Change setting in main_parallel_Numbers.m to runcfg.execute  = 'dfa' to run
detrended fluctuation analysis on the cleaned data. 
