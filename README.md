# MACSIMA pipeline for hpc usage
This repo describes how to use [MCMICRO] (https://mcmicro.org/) to process multiplexed-images generated with the MACSima platform.  The instructions below focus on the execution of the pipeline in the hpc.
The repo contains the necessary bash scripts (sh) and config files to execute the pipeline.

This repo has been created as a temporary solution to process MACSima data with the current [MCMICRO](https://mcmicro.org/) version.  A more robust solution
## Usage instructions:
Two steps are to be implemented. In the first one the raw tiles are staged so they can be directly used as input for ASHLAR, which is the registration and stitching algorithm used by MCMICRO.  What the staging step does is reorder the raw tiles of a cycle, all tiles of a cycle and common rack, roi,well and exposure time will be written in the single file with their corresponding ome metadata.  

The second step is simply the execution of MCMICRO with a specific set of parameters.



1. **Staging**:

    1. download the container (v1.1.0) of macsima2mc  with the following command: ``` singularity pull docker://ghcr.io/schapirolabor/multiplex_macsima:v1.1.0 ``` .

    2. Create a tab separated sample array file (e.g. *acquisitions.tsv*) with two columns: ArrayTaskID and Sample.  Each row of the first column is an integer number that represents the TaskID.  The rows of the second column are the absolute path of the folder that contains the **n** cycles of the acquisition.  As of now, the content of this latter folder contains multiple folders with the name x_Cycle_**n**.  See the images below for reference of the *acquisitions.tsv* file and the cycles folder, in this representative example we apply the pipeline to the cycles in the folder *mydir/acquisition_A*.

    ![Screenshot of the sample array file](https://github.com/SchapiroLabor/macsima_pipeline/blob/main/figs/sample_array_tsv_example.PNG)

    ![Screenshot of cycles inside acquisition_A](https://github.com/SchapiroLabor/macsima_pipeline/blob/main/figs/acquisition_A.png?raw=true)


    3. Create a directory for the outputs of the staging tool, e.g. *output_dir*.  
    4. Open the staging.sh file and specify the following inputs:
        -SBATCH --array=1 : range of samples from the ArrayTaskID on which the staging will be applied.  In this example we only have ID 1, if m samples then,``` SBATCH --array=1-m``` .
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




