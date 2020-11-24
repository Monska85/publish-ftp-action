#!/bin/sh -l

EXIT_STATUS=-99

HOST="${1}"
USERNAME="${2}"
PASSWORD="${3}"
CHDIR="${4:-"./"}"
PORT="${5:-"21"}"
TYPE="${6:-"FTP"}"

echo "Hello, I am the github action and this is my input"
echo "${HOST}-${USERNAME}-${PASSWORD}-${CHDIR}-${PORT}-${TYPE}"

echo ""
echo "--- Current location ---"
pwd
echo ""
echo "--- List this directory ---"
ls -lha
echo ""

BATCH_FILE=/tmp/commands
if [ "${TYPE}" == "SFTP" ]; then
    echo "cd ${CHDIR}" > ${BATCH_FILE}
    echo "put *" >> ${BATCH_FILE}
    echo "bye" >> ${BATCH_FILE}

    sshpass -p "${PASSWORD}" sftp -P ${PORT} -oStrictHostKeyChecking=no -oBatchMode=no -b ${BATCH_FILE} ${USERNAME}@${HOST}
    EXIT_STATUS=$?
fi


echo "::set-output name=exit-status::${EXIT_STATUS}"