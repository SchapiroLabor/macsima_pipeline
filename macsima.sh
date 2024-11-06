#!/usr/bin/bash

#SBATCH --job-name=macsima_test
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=16gb
#SBATCH --array=1-2

module load applications-extra
module load java/17.0.2
module load nextflow/22.10.6

singularity_config="absolute path to the singularity.config file"
params_file="absolute path to the params.yml file"
array_config="absolute path to the samples.tsv file"
sample=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $array_config)


nextflow -c $singularity_config run labsyspharm/mcmicro --in ${sample} -profile singularity \
 --params $params_file -with-report ${sample}.html  