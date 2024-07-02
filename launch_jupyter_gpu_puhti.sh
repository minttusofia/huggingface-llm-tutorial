#!/bin/bash
#SBATCH --account=project_2010262
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=64G
#SBATCH --time=2:00:00
#SBATCH --gres=gpu:v100:1
#SBATCH -e slurm-jupyter.out
#SBATCH -o slurm-jupyter.out

export PATH="/projappl/project_2010262/conda_envs/llm_tutorial/bin:$PATH"
export HF_HOME="/scratch/project_2010262/shared/huggingface-hub-cache"

srun jupyter lab --port-retries=10
