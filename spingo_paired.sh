#!/bin/bash

start_time=$(date)

# ============================================================
# SECTION 1: Resource Detection
# ============================================================

# Detect available system resources
total_cores=$(nproc)
total_memory_gb=$(awk '/MemTotal/ {printf "%.0f", $2/1024/1024}' /proc/meminfo)
available_memory_gb=$(awk '/MemAvailable/ {printf "%.0f", $2/1024/1024}' /proc/meminfo)

# Display system resources
  echo "=============================================="
  echo "        SYSTEM RESOURCE INFORMATION          "
  echo "=============================================="
  echo "Total CPU cores:        $total_cores"
  echo "Total memory:            ${total_memory_gb} GB"
  echo "Available memory:        ${available_memory_gb} GB"
echo "=============================================="

# ============================================================
# SECTION 2: Variable Assignment & PATH Validation
# ============================================================

# Detect HOME directory
  echo "Detected HOME directory: $HOME"
  echo ""

  echo "Assigning executables / file paths to variables..."
  spingo_directory="${HOME}/SPINGO/spingo"
  reference_data="${HOME}/SPINGO/database/RDP_11.2.species.fa"
  sequence_directory=$(pwd)
  study_name=$1
  threads=$2

# Check if SPINGO executable exists and is executable
  if [ ! -x "$spingo_directory" ]; then
      echo "ERROR: SPINGO executable not found:  $spingo_directory"
      exit 1
  fi

# Check if reference database exists
  if [ ! -f "$reference_data" ]; then
      echo "ERROR: Reference database not found: $reference_data"
      exit 1
  fi

  echo "Path validation successful!"

export spingo_directory reference_data sequence_directory threads

# ============================================================
# SECTION 2.5: Software Version Information
# ============================================================

  echo "=============================================="
  echo "        SOFTWARE VERSION INFORMATION         "
  echo "=============================================="
  echo "SPINGO:       $($spingo_directory -v 2>&1)"
  echo "seqtk:        $(seqtk 2>&1 | grep Version)"
  echo "GNU Parallel: $(parallel --version | head -1)"
  echo "Perl:         $(perl -v | grep version)"
  echo "=============================================="

# ============================================================
# SECTION 3: Sample Processing Function (FULLY OPTIMIZED)
# ============================================================

  process_sample() {
      file_name=$1
    
      echo "[$(date)] Processing sample: $file_name"
    
    # Fully optimized:  Decompress -> Merge -> Convert to FASTA -> SPINGO (all streamed)
      zcat "${file_name}_1.fastq.gz" "${file_name}_2.fastq.gz" | seqtk seq -A | \
          "${spingo_directory}" -d "${reference_data}" -p "${threads}" -i /dev/stdin > "${file_name}_spingo.out.txt"
    
      echo "[$(date)] The Spingo process completed for sample: $file_name"
  }

  export -f process_sample

# ============================================================
# SECTION 4: Main Execution
# ============================================================

  echo "Initiation of preprocess ***[ Unzip => Merge => *.fasta conversion ] and run spingo***"

  # Sequential processing (default - no parallel dependency required)
  for f in *_1.fastq.gz; do file_name=${f%_1.fastq.gz}; process_sample $file_name; done

  # Parallel processing (optional - uncomment to enable, requires GNU Parallel)
  # Uncomment the line below and comment out the sequential loop above to use parallel processing
  #for f in *_1.fastq.gz; do echo "${f%_1.fastq.gz}"; done | parallel -j 1 process_sample {}
  # Note: Change -j 1 to -j N for N parallel jobs

  echo "Taxonomical classification for all files were done..."

# ============================================================
# SECTION 5: Create Species Matrix
# ============================================================

  echo "Creating species abundance matrix..."

  ls *spingo.out.txt > "spingo_file_list.txt"

  perl create_species_matrix.pl "spingo_file_list.txt" > "species_matrix_${study_name}.txt"

  echo "******________Mission Accomplished________******"

# ============================================================
# SECTION 6: Email Notification
# ============================================================

  EMAIL="dinesh2biotech@gmail.com"
  end_time=$(date)

  echo "Sending completion notification..."

  mail -s "SPINGO: ${study_name} - Completed" "$EMAIL" <<EOF
Dear $(whoami), 
Please find the server job completion details. 
Job Details
==============================
Study Name:      ${study_name}
Started on:    ${start_time}
Completed :  ${end_time}
EOF

  echo "Email notification sent to:  $EMAIL"
