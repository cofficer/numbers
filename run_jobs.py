#!/usr/bin/python
# Example PBS cluster job submission in Python

from popen2 import popen2
import time

# Loop over your jobs
for i in range(1, 2):

    # Open a pipe to the qsub command.
    output, input = popen2('qsub')

    # Customize your options here
    job_name = "my_job_%d" % i
    walltime = "1:00:00"
    processors = "nodes=1:ppn=1"
    memory = "10gb"
    command = "run_test_py_qsub.m [arg1=%d]" % i
    
    job_string = """#!/bin/bash
    #PBS -N %s
    #PBS -l walltime=%s
    #PBS -l %s
    #PBS -o [path name of python script]/%s.out
    #PBS -e [path name of python script]/%s.err
    cd $PBS_O_WORKDIR
    %s""" % (job_name, walltime, processors, job_name, job_name, command)

    # Send job_string to qsub
    input.write(job_string)
    input.close()

    # Print your job and the system response to the screen as it's submitted
    print job_string
    print output.read()

    time.sleep(0.1)
