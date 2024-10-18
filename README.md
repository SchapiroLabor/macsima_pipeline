# MACSIMA pipeline for hpc usage
## Bashscripts to stage, apply illumination correction and run mcmicro on MACSima data

This is work on progress, currently only the staging script is available (staging.sh).  The steps to use this are:
1. download the container of macsima2mc with the following command:
``` 
singularity pull docker://ghcr.io/schapirolabor/multiplex_macsima:v1.0.0
```
2. Create a tab separated sample array file (e.g. *acquisitions.tsv*) with two columns: ArrayTaskID and Sample.  The former is an integer number that represents the TaskID, the latter is the absolute path of the folder that contains the cycles of the acquisition.

![Screenshot of the sample array file](https://github.com/SchapiroLabor/macsima_pipeline/blob/main/figs/sample_array_tsv_example.PNG)

![Screenshot of cycles inside acquisition_A](https://github.com/SchapiroLabor/macsima_pipeline/blob/main/figs/acquisition_A.png?raw=true)


3. Create a directory for the outputs of the staging tool, e.g. *output_dir*.  
4. Open the staging.sh file and specify the following inputs:
    -SBATCH --array=1 : range of samples to take from the ArrayTaskID, in this example we only have ID 1, if n samples then,
    ``` 
    SBATCH --array=1-n
    ``` 
    -acquisitions : path to the sample array file
    ``` 
    acquisitions=/myarrays/acquisitions_array.tsv
    ``` 
    -staging_container=absolute path to the macsima2mc container, downloaded in step 1.
    ``` 
    staging_container=/mycontainers/multiplex_macsima_v1.0.0.sif
    ``` 
    -output_dir=absolute path to the created *output_dir* folder
    ``` 
    output_dir=/home/output_dir
    ``` 
    ![Screenshot of staging.sh](https://github.com/SchapiroLabor/macsima_pipeline/blob/main/figs/staging_sh_screenshot.PNG?raw=true)




