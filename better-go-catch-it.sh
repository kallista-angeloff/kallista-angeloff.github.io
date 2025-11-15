#!/bin/sh

set -eux
 
experiment_name='my_experiment'
experiment_directory='path/to/all-experiments'
year_string='end_date'
run_directory='path/to/run'
run_shell_script='submit_runs.sh'

if [ "$(squeue --format='%.100j' --me | grep -c ${experiment_name})" -eq 0 ]; then
    echo 'Not running. Has it reached the desired year?'
    for experiment_version in foo bar baz; do
        if [ "$(ls -l "${experiment_directory}/${experiment_name}_${experiment_version}" | grep -c ${year_string})" -eq 0 ]; then
            echo "Experiment ${experiment_version} has not reached the desired year."
        else
            echo "Experiment ${experiment_version} has finished! Stop."
            exit 
        cd ${run_directory}
        sbatch ${run_shell_script} 
        echo "Submitted runs through ${run_shell_script}, now in progress."
        fi
    done
else
    echo 'Still running.'
fi