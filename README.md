# MACSIMA pipeline for hpc usage
## Bashscripts to stage, apply illumination correction and run mcmicro on MACSima data

This is work on progress, currently only the staging script is available (staging.sh).  The steps to use this are:
*1) download the container of macsima2mc with the following command:
singularity pull docker://ghcr.io/schapirolabor/multiplex_macsima:v1.0.0
*2) Create a tsv file with the absolute path of all the acquisitons on which the staging will be applied.
