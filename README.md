# MACSIMA pipeline for hpc usage
## Bashscripts to stage, apply illumination correction and run mcmicro on MACSima data

This is work on progress, currently only the staging script is available (staging.sh).  The steps to use this are:
1. download the container of macsima2mc with the following command:
``` 
singularity pull docker://ghcr.io/schapirolabor/multiplex_macsima:v1.0.0
```

2. Create a tab separated file (.tsv) file with two columns: ArrayTaskID and Sample.  The former is an integer number that represents the TaskID, the latter is the absolute path of the folder that contains the cycles of the acquisition.

![Screenshot of the sample array file](https://github.com/SchapiroLabor/macsima_pipeline/blob/main/figs/sample_array_tsv_example.PNG) 

```
ArrayTaskID Sample
1   /mydir/acquisition_A

```

