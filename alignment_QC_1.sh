#!/bin/bash -l
#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=qorts_script_1
#SBATCH --time=20:00:00 # HH/MM/SS
#SBATCH --mem=64G
#SBATCH --mail-user=avk4003@med.cornell.edu
#SBATCH --mail-type=ALL


mamba activate qorts
for file in mapped/*.bam; do
out_name="${file%.Aligned.sortedByCoord.out.bam}"
out_name="${out_name##*/}"
java -Xmx8G -jar ~luce/angsd/gierlinski/alignment_qc/QoRTs.jar QC --singleEnded --stranded --generatePdfReport ${file} /athena/angsd/scratch/avk4003/reference_genome/Homo_sapiens.GRCh38.109.gtf qorts_1/${out_name}
done

