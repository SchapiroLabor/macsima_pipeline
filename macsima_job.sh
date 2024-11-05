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

project_dir=/hpc/scratch/hdd1/vp232003/macsima_test
array_config=/hpc/scratch/hdd1/vp232003/tsvs/samples.tsv
sample=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $array_config)
echo "This is array task ${SLURM_ARRAY_TASK_ID}, the sample name is ${sample}." >> $project_dir/a_cha.array_output.txt

#nextflow -c $project_dir/singularity.config run ./cellpose_fix/mcmicro --in ${sample} -profile singularity \
nextflow -c $project_dir/singularity.config run labsyspharm/mcmicro --in ${sample} -profile singularity \
 --params $project_dir/params_.yml -with-report ${sample}.html 