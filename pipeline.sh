#!/bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=pipeline_1
#SBATCH --time=12:00:00 # HH/MM/SS
#SBATCH --mem=64G
#SBATCH --mail-user=avk4003@med.cornell.edu
#SBATCH --mail-type=ALL



mamba activate angsd

while read line; do link=$(echo "$line" | cut -f 2); pre_filename=$(echo "$line" | cut -f 3); filename=$(echo "$pre_filename" | cut -d'_' -f3-); wget -O samples/${filename}.fastq.gz ftp://$link; done < samples.txt
echo "File downloads complete" >> align_slurm_output.txt
for file in /athena/angsd/scratch/avk4003/samples/*fastq.gz; do
	fastqc --extract -o /athena/angsd/scratch/avk4003/fastqc_reports "$file"
done
echo "Now beginning multiqc" >> align_slurm_output.txt
for file in /athena/angsd/scratch/avk4003/fastqc_reports/*_fastqc.zip; do
	mv "$file" /athena/angsd/scratch/avk4003/multi_report
done
mamba activate multiqc
multiqc multi_report/
echo "Now beginning STAR aligning" >> align_slurm_output.txt
mamba activate angsd
for file in /athena/angsd/scratch/avk4003/samples/*.fastq.gz; do
 out_name="${file%.fastq.gz}"
 out_name="${out_name##*/}"


 STAR --runMode alignReads \
    --runThreadN 1 \
    --genomeDir /athena/angsd/scratch/avk4003/reference_genome/GRCh38_STARindex \
    --readFilesIn "$file" \
    --readFilesCommand zcat \
    --outFileNamePrefix /athena/angsd/scratch/avk4003/mapped/${out_name}. \
    --outSAMtype BAM SortedByCoordinate ;
done
echo "Mapping completed" >> align_slurm_output.txt
cd /athena/angsd/scratch/avk4003/mapped
for file in *.bam; do
	samtools index "$file"
done

echo "task executed" >> align_slurm_output.txt
