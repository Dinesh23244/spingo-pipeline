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
- ✅ Required files in your working directory:
  - `spingo_paired.sh` or `spingo_single.sh` (the pipeline script)
  - `create_species_matrix.pl` (Perl script for generating species abundance matrix)

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

## Manual Species Matrix Generation

If the Perl script (`create_species_matrix.pl`) was missing during your initial pipeline run, you can generate the species matrix manually after the fact.

### Prerequisites

- Individual SPINGO output files (`*_spingo.out.txt`) already exist
- `create_species_matrix.pl` is available in your working directory
- Perl is installed

### Command

```bash
ls *spingo.out.txt > "spingo_file_list.txt"; perl create_species_matrix.pl "spingo_file_list.txt" > "species_matrix_your_study_name.txt"
```

### Step-by-Step Instructions

1. **Navigate to your SPINGO output directory:**
   ```bash
   cd /path/to/your/spingo/output
   ```

2. **Ensure the Perl script is present:**
   ```bash
   ls create_species_matrix.pl
   ```
   If not found, copy it to this directory.

3. **Generate the species matrix:**
   ```bash
   ls *spingo.out.txt > "spingo_file_list.txt"
   perl create_species_matrix.pl "spingo_file_list.txt" > "species_matrix_your_study_name.txt"
   ```
   Replace `your_study_name` with your actual study name.

### What This Does

1. Lists all SPINGO output files and saves the list to `spingo_file_list.txt`
2. Runs the Perl script to combine all individual results
3. Outputs the final species abundance matrix

### Example

```bash
# Navigate to your SPINGO output directory
cd ~/microbiome_data/gut_samples

# Verify Perl script is present
ls create_species_matrix.pl

# Generate matrix
ls *spingo.out.txt > "spingo_file_list.txt"
perl create_species_matrix.pl "spingo_file_list.txt" > "species_matrix_gut_study_2024.txt"

# Verify output
ls -lh species_matrix_gut_study_2024.txt
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
