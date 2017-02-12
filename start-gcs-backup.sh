#!/bin/bash -ex

KEY_FILE=$1
DB_NAME=$2
GCS_BUCKET_NAME=$3

if [ -z "${KEY_FILE}" ] && [ -z "${DB_NAME}" ] && [ -z "${GCS_BUCKET_NAME}" ]; then
  echo "./start_gcs_backup.sh <KEY_FILE> <DB_NAME> <GCS_BUCKET_NAME>"
fi

gcloud auth activate-service-account --key-file "${KEY_FILE}"

MONGO_CMD=$(which mongodump)
GSUTIL_CMD=$(which gsutil)

if [ -z "${MONGO_CMD}" ] && [ -z "${GSUTIL_CMD}" ]; then
  echo "Require 'mongodump' and 'gsutil' commands"
fi

FOLDER_NAME=`date +%Y%m%d-%H%M`
ROOT_PATH="/opt/${DB_NAME}-backup/"
mkdir -p "${ROOT_PATH}"
${MONGO_CMD} --out "${ROOT_PATH}/${FOLDER_NAME}" --db ${DB_NAME}
tar cvzf "${ROOT_PATH}/${FOLDER_NAME}.tar.gz" -C "${ROOT_PATH}/${FOLDER_NAME}" . --remove-files

gsutil cp "${ROOT_PATH}/${FOLDER_NAME}.tar.gz" "gs://${GCS_BUCKET_NAME}"
