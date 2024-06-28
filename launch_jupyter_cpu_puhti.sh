#!/bin/bash
#SBATCH --account=project_2010262
#SBATCH --partition=small
#SBATCH --time=02:00:00
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4000
#SBATCH -e slurm-jupyter.out
#SBATCH -o slurm-jupyter.out

export PATH="/projappl/project_2010262/conda_envs/llm_tutorial/bin:$PATH"
export HF_HOME="/scratch/project_2010262/shared/huggingface-hub-cache"

srun jupyter lab --port-retries=10
