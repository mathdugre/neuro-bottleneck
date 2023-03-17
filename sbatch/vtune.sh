#!/bin/sh
set -e
set -u

singularity exec --cleanenv \
    -B ~/intel/oneapi/vtune/latest/:/vtune \
    -B ${SLURM_TMPDIR}:/data \
    -B ${PROJECT_DIR}:${PROJECT_DIR} \
    ${SIF_IMG} \
    /vtune/bin64/vtune \
    -collect hpc-performance \
    -knob enable-stack-collection=true \
    -knob analyze-openmp=false \
    -result-dir ${PROFILING_DIR} \
    $@