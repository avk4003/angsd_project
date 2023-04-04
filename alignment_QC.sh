#!/bin/bash -l
#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=qorts_script
#SBATCH --time=12:00:00 # HH/MM/SS
#SBATCH --mem=64G
#SBATCH --mail-user=avk4003@med.cornell.edu
#SBATCH --mail-type=ALL


mamba activate qorts
for file in mapped/*.bam; do
java -Xmx4G -jar ~luce/angsd/gierlinski/alignment_qc/QoRTs.jar QC --singleEnded --stranded --generatePlots --maxPhredScore 45 ${file} /athena/angsd/scratch/avk4003/reference_genome/Homo_sapiens.GRCh38.109.gtf qorts/
done
mamba activate multiqc
mkdir qorts_multiqc
cd qorts_multiqc/
multiqc  /athena/angsd/scratch/avk4003/qorts/

