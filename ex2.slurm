#!/bin/bash 
## Submit job to our class's allocation
#SBATCH --partition=standard
#SBATCH --account=hpc4astro_crch_fall2025

## Time requested: 0 hours, 15 minutes, 0 seconds
#SBATCH --time=0:15:00 

## Ask for one core of one node, plus 1 GPU
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1 
#SBATCH --gres=gpu:1

## Promise that each processor will use no more than 1GB of RAM
#SBATCH --mem=16GB

## Save STDOUT and STDERR into one file (%j will expand to become the SLURM job id)
#SBATCH --output=ex2_%j.log
## Optionally, you could uncomment the line below to write STDERR to a separate file
##SBATCH --error=ex2_%j.stderr  

## Specify job name, so easy to find using squeue –u
#SBATCH --job-name=ex2

## Uncomment next two lines (by removing one of #'s in each line) and replace with your email if you want to be notified when jobs start and stop
##SBATCH --mail-user=YOUR_EMAIL_HERE@psu.edu
## Ask for emails when jobs begin, end, or fail (options are ALL, NONE, BEGIN, END, FAIL)
#SBATCH --mail-type=ALL

echo "Starting job $SLURM_JOB_NAME"
echo "Job id: $SLURM_JOB_ID"
date

echo "This job was assigned the following nodes"
echo $SLURM_NODELIST

echo "Activating environment that provides Julia 1.11.2"
source /storage/ehome/ebf11/hpc4astro/astro_528/scripts/env_setup

echo "About to change into $SLURM_SUBMIT_DIR"
cd $SLURM_SUBMIT_DIR            # Change into directory where job was submitted from

# env |grep SLURM               # Uncomment if you want to see all the environment variables set

FILE=./Project_has_been_instantiated
if [ -f "$FILE" ]; then
    echo "# $FILE exists.  Assuming no need to instantiate project to install packages."
else
    echo "# $FILE does not exist. Will install relevant packages."
    julia --project=. -e 'import Pkg; Pkg.instantiate(); Pkg.build() '
    touch $FILE
fi

date
echo "About to start Julia, using $SLURM_TASKS_PER_NODE CPU cores on one node"
julia --project=. -t $SLURM_TASKS_PER_NODE -e 'using Weave; weave("ex2.ipynb")'                  # To create html version
# julia --project=. -t $SLURM_TASKS_PER_NODE -e 'using Weave; convert_doc("ex2.ipynb","ex2.jmd")'  # To create Markdown version
# To run without writing a markdown version
# julia --project=. -t $SLURM_TASKS_PER_NODE -e 'include("ex2_run_nb.jl")'  
echo "Julia exited"
date
