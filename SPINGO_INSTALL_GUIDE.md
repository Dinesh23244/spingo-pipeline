# SPINGO Installation Guide

This guide provides step-by-step instructions for installing SPINGO and setting up the RDP database.

## Prerequisites

- **Linux operating system** (SPINGO is designed for Linux environments)
- Python 3.x installed
- `tar` and `gzip` utilities (usually pre-installed)
- Sufficient disk space for the database files

## Installation Steps

### Step 1: Copy the SPINGO Archive to Home Directory

Copy the compressed SPINGO archive file to your home directory:

```bash
cp spingo_installed_with_RDP_database.tar.gz ~
```

**What this does:** Copies the SPINGO installation archive to your home directory (`~`).

---

### Step 2: Extract the Archive

Navigate to your home directory and extract the compressed archive:

```bash
cd ~
tar -xzvf spingo_installed_with_RDP_database.tar.gz
```

**What this does:** 
- `tar -xzvf` extracts the archive
- `x` = extract
- `z` = decompress gzip
- `v` = verbose (shows files being extracted)
- `f` = file name follows

**Expected output:** You should see a list of files being extracted, including the `SPINGO/` directory.

---

### Step 3: Navigate to SPINGO Directory

Change to the newly extracted SPINGO directory:

```bash
cd SPINGO
```

---

### Step 4: Verify SPINGO Installation

Test that SPINGO is properly installed by viewing the help message:

```bash
./spingo -h
```

**What this does:** Runs SPINGO with the `-h` (help) flag to display usage information.

**Expected output:** You should see the SPINGO help message with available options and parameters.

> **Note:** If you encounter an "exec format error", you may need to:
> - Use the appropriate binary from `dist/64bit/` or `dist/32bit/` directory
> - Or recompile SPINGO from source for your system architecture

---

### Step 5: Build the Database

Navigate to the database directory and build the RDP database:

```bash
cd database
make
```

**What this does:** 
- Changes to the `database/` subdirectory
- Runs the makefile to generate the SPINGO database from RDP reference sequences

**Expected output:** 
```
Generating database file RDP_11.2.species.fa
Done
```

**Build process:**
- Decompresses the bacterial and archaeal reference sequences
- Processes them through the taxonomy mapping
- Creates the final database file `RDP_11.2.species.fa`

---

### Step 6: Verify Database Installation

Check that the database file was created successfully:

```bash
ls -lh RDP_11.2.species.fa
```

**Expected output:** You should see the database file with its size information.

---

## Complete Installation Command (One-liner)

If you prefer to run all commands in sequence, use this single command:

> **⚠️ Important:** Before running this command, you must first navigate to the directory containing the `spingo_installed_with_RDP_database.tar.gz` file.

```bash
# First, navigate to the directory containing the tar file
cd /path/to/directory/containing/tar/file

# Then run the installation command
cp spingo_installed_with_RDP_database.tar.gz ~; tar -xzvf ~/spingo_installed_with_RDP_database.tar.gz; cd ~/SPINGO; ./spingo -h; cd database; make
```

**What this does:** Executes all installation steps sequentially using semicolons (`;`) to separate commands.

---

## Post-Installation: Using SPINGO Pipeline Scripts

After successful installation, you can use the automated pipeline scripts provided in this repository to process your sequencing data.

### Available Pipeline Scripts

This repository provides two automated scripts:

1. **`spingo_paired.sh`** - For paired-end sequencing data
2. **`spingo_single.sh`** - For single-end sequencing data

---

### Prerequisites for Pipeline Scripts

Before running the scripts, ensure you have:

- ✅ SPINGO successfully installed (completed steps above)
- ✅ Required dependencies:
  - `seqtk` (sequence toolkit)
  - `GNU Parallel` (parallel processing)
  - `perl` (for matrix creation)
  - `mail` utility (optional, for email notifications)

---

### Script Configuration

**IMPORTANT:** Both scripts contain hardcoded paths that you **must update** before running.

**Edit lines 28-29 in both scripts:**
```bash
spingo_directory="/home/dinesh/SPINGO/spingo"
reference_data="/home/dinesh/SPINGO/database/RDP_11.2.species.fa"
```

**Change to your actual installation paths:**
```bash
spingo_directory="/path/to/your/SPINGO/spingo"
reference_data="/path/to/your/SPINGO/database/RDP_11.2.species.fa"
```

---

### Using spingo_paired.sh (Paired-End Data)

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
- Final matrix: `abundance_table_<study_name>.txt`

---

### Using spingo_single.sh (Single-End Data)

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

### Pipeline Workflow

**Paired-End:**
```
FASTQ.gz → Decompress → Merge R1+R2 → Convert to FASTA → SPINGO → Species Matrix
```

**Single-End:**
```
FASTQ.gz → Decompress → Convert to FASTA → SPINGO → Species Matrix
```

---

### Manual SPINGO Usage

If you prefer to run SPINGO manually without the pipeline scripts:

```bash
# Basic usage
./spingo -d database/RDP_11.2.species.fa -i your_sequences.fasta

# View all options
./spingo -h
```

---

## Directory Structure

After installation, your SPINGO directory should look like this:

```
SPINGO/
├── spingo              # Main executable
├── spindex             # Indexing tool
├── database/
│   ├── RDP_11.2.species.fa       # Generated database file
│   ├── taxonomy.map              # Taxonomy mapping
│   └── makefile                  # Database build script
├── dist/               # Distribution files and utilities
├── source/             # Source code
└── README.md           # Documentation
```

---

## Additional Resources

- **Detailed usage guide:** See [SPINGO_USAGE_GUIDE.md](SPINGO_USAGE_GUIDE.md) for comprehensive instructions
- **Examples:** Check the `examples/` directory for sample data and workflows
- **Documentation:** Read [README.md](README.md) for more information
- **Citation:** Review the publication data for proper citation

---

## Support

For issues or questions:
- Check the official SPINGO repository
- Review the publication for methodology details
- Consult the README.md for additional documentation

