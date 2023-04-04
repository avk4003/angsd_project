#!/bin/bash -l
#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=feature_counts
#SBATCH --time=12:00:00 # HH/MM/SS
#SBATCH --mem=64G
#SBATCH --mail-user=avk4003@med.cornell.edu
#SBATCH --mail-type=ALL

mamba activate angsd
featureCounts -s 1 -a /athena/angsd/scratch/avk4003/reference_genome/Homo_sapiens.GRCh38.109.gtf -o counts/readcounts.txt /athena/angsd/scratch/avk4003/mapped/*.bam
cd counts/
mamba activate multiqc
multiqc .
 


