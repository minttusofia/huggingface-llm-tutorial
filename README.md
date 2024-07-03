# LLM hands-on session & Introduction to CSC's Puhti and Mahti clusters

<br>

# Connecting to CSC clusters
1. Register an account with CSC if you haven't already done so: https://my.csc.fi/csc-customer-registration.  
Instructions have been emailed to registered CoGenAI participants.

2. Create an SSH key (or use an existing one) and add it to your profile at https://my.csc.fi/profile.
e.g.
```bash
ssh-keygen -t rsa
```
* Upload the created public key, e.g. `~/.ssh/id_rsa.pub` to https://my.csc.fi/profile.

3. Add the following to your `~/.ssh/config`:
```
Host puhti 
    User <YOUR_CSC_USERNAME>
    HostName puhti.csc.fi

Host mahti
    User <YOUR_CSC_USERNAME>
    HostName mahti.csc.fi
```
4. Connect to Puhti using `ssh puhti` or Mahti using `ssh mahti`.

<br>

# CSC cluster basics
> [!IMPORTANT]
**Please read this section carefully to ensure fair use of our shared CSC compute resources!**


### Scheduling jobs
Computation should not be done on the login nodes, so please do not run python, jupyter, etc. there. Puhti and Mahti use Slurm to schedule jobs on the compute nodes.
If you won't need GPUs for your small-scale experimental job, please use either your local machine, or Puhti. Mahti is best suited for either GPU jobs or large-scale CPU jobs.

### Disk space on CSC clusters
The following paths relate to both Mahti and Puhti, but their disks are separate.

Your home directory `/users/<YOUR_CSC_USERNAME>` has 10GB of space.

The shared project directory in `/scratch/project_2010262` has about 40GB per CoGenAI participant. Let us know if you need more for your use case. Please create your own subdirectory for your files (such as files related to Friday's project) with `mkdir /scratch/project_2010262/$USER`, or add them to `/scratch/project_2010262/shared/` if they may be useful to others (e.g. common datasets).

### Shared conda and HuggingFace cache
For this tutorial, we will be using a shared conda environment saved under `/projappl/project_2010262/conda_envs/llm_tutorial` and HuggingFace models saved under `/scratch/project_2010262/shared/huggingface-hub-cache`. The `launch_jupyter_*.sh` scripts take care of defining these settings.

The `llm_tutorial` conda environment should cover most use cases for HuggingFace experiments with LLMs. To activate it, run:  
```export PATH="/projappl/project_2010262/conda_envs/llm_tutorial/bin:$PATH"```

### Further information
For more documentation on CSC clusters, please see https://docs.csc.fi/support/tutorials/puhti_quick/, https://docs.csc.fi/support/tutorials/mahti_quick/ and https://docs.csc.fi/.

### Limiting queueing time for GPUs
With a large cohort of us running jobs at once, wait times may arise. For the exercises requiring GPUs (notebook2), we recommend you pair up and share one notebook with someone, check Mahti if you cannot get your GPU job scheduled on Puhti and vice versa, or perhaps try your university's own cluster, if applicable. Apologies for the hassle.

For Wednesday's tutorial slot (2:30-5pm) and Friday's project (8am-3pm), we also have 20 GPUs reserved on Puhti specifically for our CSC project. Please make use of these first and foremost if they are free, using the slurm argument `--reservation=ellis-summer-school-2024-wed` and `--reservation=ellis-summer-school-2024-fri`, respectively. Slurm arguments can be defined either directly as arguments to the `sbatch` command on the command line or in a launch script (such as `launch_jupyter_gpu_puhti.sh`). If all 20 are already in use and you cannot schedule your job within the reservation, leave out this argument to request a GPU in the rest of the cluster.

# LLM tutorial
## Setup -- Running on CPU / GPU on Puhti or on a GPU on Mahti
1. After connecting to Puhti with `ssh puhti` or Mahti with `ssh mahti`, clone this repository under your home directory:
```bash
git clone https://github.com/minttusofia/huggingface-llm-tutorial
cd huggingface-llm-tutorial
```
2. For notebook1, we won't yet need a GPU. Launch a jupyter lab instance on CPU, e.g.:
```bash
sbatch launch_jupyter_cpu_puhti.sh
```
* You can check if your job is being scheduled using `squeue --me`. Once it's running, check the name of the compute node. E.g., for the job below, the node would be `g1102`:
```
            JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
           3562598  gpusmall launch_j alakuija  R       0:05      1 g1102
```
* To cancel your jupyter instance, use, `scancel <JOBID>`, such as `scancel 3562598`.  

> [!IMPORTANT]
Please try to not leave jobs running once you no longer need them!

3. Find the port jupyter is using by looking at `slurm-jupyter.out`. It will be logged like this: `http://localhost:<PORT>/lab?token=<TOKEN>`. Run the following on your **local machine** to set up ssh port forwarding to connect to your instance:
```bash
ssh -J puhti -N -L <PORT>:localhost:<PORT> <YOUR_CSC_USERNAME>@<COMPUTE_NODE>
```
for example, for the job above:
```bash
ssh -J puhti -N -L 8888:localhost:8888 alakuija@g1102
```
4. Point your web browser to the URL logged to `slurm-jupyter.out`.  
It should look like this: `http://localhost:<PORT>/lab?token=<TOKEN>`.  
You should now see Jupyter and be able to run notebooks. Start from `notebook1/huggingface_intro_cpu_friendly.ipynb`.


## Setup -- Running locally, or on a cluster other than Puhti / Mahti:

Prerequisite: Install conda. This setup was tested using conda version 24.1.2.

1. Create a conda environment: use `env_nocuda.yml` to install pytorch for CPU only, or `env.yml` if you will be using a GPU.
```bash
conda env create -f env_nocuda.yml
conda activate llm_tutorial
```
2. To use gated models, such as Llama-3, you will need a HuggingFace account, and an access token that can be created at https://huggingface.co/settings/tokens; this step is not needed on mahti or puhti, where Llama-3-8B-Instruct is already pre-downloaded. Add the access token to `.env`:
```
HF_TOKEN=<YOUR_TOKEN>
```
* To use this environment variable in jupyter, (re)run the following lines in your notebook:
```python
from dotenv import load_dotenv
load_dotenv(override=True)
```
- You can also modify the HuggingFace cache directory (HF_HOME) to a path of your choice in `.env`.

3. Launch jupyter with ```jupyter lab``` and open the localhost link in your browser. Start from `notebook1/huggingface_intro_cpu_friendly.ipynb`.
