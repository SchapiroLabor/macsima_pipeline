# MACSIMA pipeline for hpc usage
This repo describes how to use MCMICRO [MCMICRO] (https://mcmicro.org/) to process multiplexed-images generated with the MACSima platform.  The instructions below focus on the execution of the pipeline in the hpc.
The repo contains the necessary bash scripts (sh) and config files to execute the pipeline.

This repo has been created as a temporary solution to process MACSima data with the current [MCMICRO](https://mcmicro.org/) version.  A more robust solution
## Usage instructions:
Two steps are to be implemented. In the first one the raw tiles are staged so they can be directly used as input for ASHLAR.  ASHLAR is the registration and stitching algorithm used by MCMICRO.  What the staging step does is reorder the raw tiles

The second step is simply the execution of MCMICRO with a specific set of parameters.



1. **Staging**: 
    - download the container (v1.1.0) of macsima2mc with the following command:
``` 
singularity pull docker://ghcr.io/schapirolabor/multiplex_macsima:v1.1.0
```
    - Create a tab separated sample array file (e.g. *acquisitions.tsv*) with two columns: ArrayTaskID and Sample.  The former is an integer number that represents the TaskID, the latter is the absolute path of the folder that contains the cycles of the acquisition.

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

5. Save the changes to the staging.sh file and run it:
``` 
sbatch staging.sh
``` 
6. Once the staging script is over the restructured MACSima data sets will be found in the *output_dir*.  The data of a cycle will be written into two ome.tiff files, one file containes the marker signal (src- S) and the other one the backround signal (src- B).




