#!/bin/bash

#SBATCH -J ants-BrainExtraction-fp
#SBATCH --array=1
#SBATCH --time=2:00:00
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=0
# -------------------------
#SBATCH -o log/%x-%A-%a.out
#SBATCH -e log/%x-%A-%a.err
# -------------------------
set -e
set -u

# Setup environment and parse args.
source ./sbatch/pre_run.sh ants brainExtraction-fp -j ${SLURM_CPUS_PER_TASK} $@

cat <<EOT >> ${TMP_SCRIPT}/${RANDOM_STRING}.sh
TMPLT="/opt/templates/OASIS"

antsBrainExtraction.sh \
    -q 1 \
    -d 3 \
    -a /data/input/sub-${SUBJECT_ID}/ses-1/anat/sub-${SUBJECT_ID}_ses-1_run-1_T1w.nii.gz \
    -e ${TMPLT}/T_template0.nii.gz \
    -m ${TMPLT}/T_template0_BrainCerebellumProbabilityMask.nii.gz \
    -o /data/output/sub-${SUBJECT_ID}/
EOT

export SINGULARITYENV_ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=$NTHREAD
source ./sbatch/vtune.sh bash ${TMP_SCRIPT}/${RANDOM_STRING}.sh

source ./sbatch/post_run.sh