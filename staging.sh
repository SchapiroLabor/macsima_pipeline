#!/usr/bin/bash
#SBATCH --job-name=basicpy_test
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=16gb
#SBATCH --array=1

#INPUTS
acquisitions=/hpc/scratch/hdd1/vp232003/tsvs/acquisitions.tsv
staging_container=/hpc/scratch/hdd1/vp232003/containers/multiplex_macsima_v1.1.0.sif
output_dir=/hpc/scratch/hdd1/vp232003/output/
#END INPUTS

sample=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $acquisitions)




for cycle in $sample/*Cycle*;
do

cycle_folder=$(basename "$cycle")
sample_id=${SLURM_ARRAY_TASK_ID}
sample_id+="_$(basename $sample)"
singularity exec --bind $sample:/mnt,$output_dir:/media --no-home $staging_container python /staging/macsima2mc/macsima2mc.py -i /mnt/$cycle_folder -o /media/$sample_id -ic
echo $cycle_folder
done

