#!/bin/bash
#SBATCH --job-name=makedom
#SBATCH --time=00:18:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --account=<you_proj_account>
#SBATCH --partition=standard
#SBATCH --qos=standard


# Setup the job environment (this module needs to be loaded before any other modules)
module swap craype-network-ofi craype-network-ucx 
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.0.7
module load cray-netcdf-hdf5parallel/4.7.4.7

# Set the number of threads to 1
#   This prevents any threaded system libraries from automatically 
#   using threading.
export OMP_NUM_THREADS=1

# Launch the parallel job
#   Using 512 MPI processes and 128 MPI processes per node
#   srun picks up the distribution from the sbatch options

./make_domain_cfg.exe



