#!/bin/bash 
## Submit job to our class's allocation
#SBATCH --partition=standard
#SBATCH --account=hpc4astro_crch_fall2025

## Time requested: 0 hours, 15 minutes, 0 seconds
#SBATCH --time=0:15:00 

## Ask for one core of one node, plus 1 CPU
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1 
#SBATCH --gres=gpu:1

## Promise that each processor will use no more than 1GB of RAM
#SBATCH --mem=16GB

## Save STDOUT and STDERR into one file (%j will expand to become the SLURM job id)
#SBATCH --output=ex1_%j.log
## Optionally, you could uncomment the line below to write STDERR to a separate file
##SBATCH --error=ex1_%j.stderr  

## Specify job name, so easy to find using squeue –u
#SBATCH --job-name=ex1

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
    julia --project -e 'import Pkg; Pkg.instantiate() '
    # If using a Pluto notebook
    #julia --project -e 'import Pluto, Pkg; Pluto.activate_notebook_environment("ex1.jl"); Pkg.instantiate() '
    julia --project -e 'import Pkg; Pkg.build() '
    touch $FILE
fi

date
echo "# About to run Pluto notebook and generate HTML version with outputs, using $SLURM_TASKS_PER_NODE CPU cores on one node"
# export JULIA_PKG_OFFLINE="true"
julia --project=. -t $SLURM_TASKS_PER_NODE -e 'using Weave; weave("ex1.ipynb")'                  # To create Html version of outputs
# julia --project=. -t $SLURM_TASKS_PER_NODE -e 'using Weave; convert_doc("ex1.ipynb","ex1.jmd")'  # To create Markdown version
## If using a Pluto notebook instead of a Jupyter notebook
## julia --project -t $SLURM_TASKS_PER_NODE -e 'import Pkg, PlutoSliderServer; Pkg.offline(); PlutoSliderServer.export_notebook("ex1.jl")'
## Or to just run Pluto notebook without saving HTML version
## julia -t $SLURM_TASKS_PER_NODE -e 'using Pkg, Pluto; Pkg.offline(); Pluto.activate_notebook_environment("ex1.jl"); Pkg.instantiate(); include("ex1.jl")'  
echo "Julia exited"
date
