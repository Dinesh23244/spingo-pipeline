# SPINGO Scripts Usage Guide

This guide explains how to use the SPINGO pipeline scripts (`spingo_paired.sh` and `spingo_single.sh`) for automated taxonomic classification of metagenomic amplicon sequences.

---

## Prerequisites for Pipeline Scripts

Before running the scripts, ensure you have:

- ✅ SPINGO successfully installed in `~/SPINGO/` (see [SPINGO_INSTALL_GUIDE.md](SPINGO_INSTALL_GUIDE.md))
- ✅ Required dependencies:
  - `seqtk` (sequence toolkit)
  - `GNU Parallel` (optional, for parallel processing)
  - `perl` (for matrix creation) 
  - `mail` utility (optional, for email notifications)

> **📌 Note:** The scripts automatically detect your HOME directory and look for SPINGO installation at `~/SPINGO/`. No manual path configuration needed!

---

## Using spingo_paired.sh (Paired-End Data)

**Input file naming convention:**
- Forward reads: `SAMPLE_1.fastq.gz`
- Reverse reads: `SAMPLE_2.fastq.gz`

**Examples of paired-end files:**
```
sample001_1.fastq.gz    sample001_2.fastq.gz
sample002_1.fastq.gz    sample002_2.fastq.gz
patient_A_1.fastq.gz    patient_A_2.fastq.gz
gut_microbiome_1.fastq.gz    gut_microbiome_2.fastq.gz
```

**Usage:**
```bash
# Navigate to directory containing your paired FASTQ files
cd /path/to/your/fastq/files

# Run the pipeline
bash /path/to/spingo_paired.sh <study_name> <threads>
```

**Example:**
```bash
bash spingo_paired.sh gut_microbiome_study 8
```

**Output:**
- Individual results: `SAMPLE_spingo.out.txt` for each sample
- Final matrix: `species_matrix_<study_name>.txt`

---

## Using spingo_single.sh (Single-End Data)

**Input file naming convention:**
- Single reads: `SAMPLE.fastq.gz`

**Examples of single-end files:**
```
sample001.fastq.gz
sample002.fastq.gz
patient_A.fastq.gz
gut_microbiome.fastq.gz
16S_amplicon_run1.fastq.gz
```

**Usage:**
```bash
# Navigate to directory containing your FASTQ files
cd /path/to/your/fastq/files

# Run the pipeline
bash /path/to/spingo_single.sh <study_name> <threads>
```

**Example:**
```bash
bash spingo_single.sh 16S_amplicon_study 8
```

**Output:**
- Individual results: `SAMPLE_spingo.out.txt` for each sample
- Final matrix: `species_matrix_<study_name>.txt`

---

## Pipeline Workflow

The pipeline operates in two stages:

**Paired-End:**
```
Stage 1 (Per Sample):
  FASTQ.gz → Decompress → Merge R1+R2 → Convert to FASTA → SPINGO 
  → Output: sample_spingo.out.txt

Stage 2 (All Samples):
  All *_spingo.out.txt files → Perl Script (create_species_matrix.pl)
  → Output: species_matrix_<study_name>.txt
```

**Single-End:**
```
Stage 1 (Per Sample):
  FASTQ.gz → Decompress → Convert to FASTA → SPINGO
  → Output: sample_spingo.out.txt

Stage 2 (All Samples):
  All *_spingo.out.txt files → Perl Script (create_species_matrix.pl)
  → Output: species_matrix_<study_name>.txt
```

---

## Manual SPINGO Usage

If you prefer to run SPINGO manually without the pipeline scripts:

```bash
# Basic usage
./spingo -d database/RDP_11.2.species.fa -i your_sequences.fasta

# View all options
./spingo -h
```

---

## Support

For installation help, see [SPINGO_INSTALL_GUIDE.md](SPINGO_INSTALL_GUIDE.md)

For more information:
- Check the official SPINGO repository
- Review the publication for methodology details
- Consult the [README.md](README.md) for additional documentation
