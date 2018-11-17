#!/bin/bash
# Starts a jupyter lab under the current user
# Parameters:
#   1: port no - the port to assign the notebook to. Default is 8888.
#
# Example usage:
# ./start-notebook.sh 9000

# Check who the script is being run by. Should be non-priveleged user
echo "Running as: " $(whoami)

# Assign a default port number
port=${1:-8888}

# Make default directories if they don't exist
mkdir -p $HOME/.jupyter
mkdir -p /volume_data/logvolume

# Set the log file
LOGFILE=/volume_data/logvolume/$(hostname)-jupyter.log

# Make sure the right environment is activated
. $HOME/conda/bin/activate base >> $LOGFILE 2>&1

# Start the notebook
jupyter lab --ip=0.0.0.0 --port=${port} --no-browser --notebook-dir=/volume_data 2>&1 | tee $LOGFILE