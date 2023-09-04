#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J rr
#SBATCH -o rr.out
#SBATCH -e rr.err
#SBATCH -p long
#SBATCH -c 1

while true; do
  # Use find to locate files with 'region' in their filename and delete them
  find /well/ckb/users/aey472/projects/ckb_popgen/data/painting_output -type f -name '*region*' -delete

  # Sleep for 30 seconds before running again
  sleep 30
done
