#!/bin/bash -l

EXIT_STATUS=-99

HOST="${INPUT_HOST}"
USERNAME="${INPUT_USERNAME}"
PASSWORD="${INPUT_PASSWORD:-""}"
SSH_KEY="${INPUT_SSH_KEY:-""}"
REMOTE_FOLDER="${INPUT_REMOTE_FOLDER:-"./"}"
REPO_FOLDER="${INPUT_REPO_FOLDER:-"./"}"
PORT="${INPUT_PORT:-"21"}"
TYPE="${INPUT_TYPE:-"FTP"}"
PUT_GITHUB_SHA="${INPUT_PUT_GITHUB_SHA:-"yes"}"

rm -rf .git
rm -rf .github

cd "${REPO_FOLDER}"

if [ "${PUT_GITHUB_SHA}" == "yes" ]; then
    touch ".github-putsftpaction-${GITHUB_SHA}"
fi

echo ""
echo "--- Current location ---"
pwd
echo ""
echo "--- List this directory ---"
ls -lha
echo ""

BATCH_FILE=/tmp/commands
if [ "${TYPE}" == "SFTP" ]; then
    echo "cd ${REMOTE_FOLDER}" > ${BATCH_FILE}
    echo "put -r ." >> ${BATCH_FILE}
    echo "ls" >> ${BATCH_FILE}
    echo "bye" >> ${BATCH_FILE}

    CMD=""

    if [ -n "${PASSWORD}" ]; then
        echo "Len of password if ${#PASSWORD}"
        CMD="sshpass -p \"${PASSWORD}\""
    fi

    CMD="${CMD} sftp -P ${PORT} -oStrictHostKeyChecking=no -oBatchMode=no -b ${BATCH_FILE}"

    if [ -n "${SSH_KEY}" ]; then
        export SSH_AUTH_SOCK=/tmp/ssh_agent.sock
        mkdir -p ~/.ssh
        ssh-agent -a $SSH_AUTH_SOCK > /dev/null
        ssh-add - <<< "${SSH_KEY}"
    fi
    
    CMD="${CMD} ${USERNAME}@${HOST}"
    
    echo "Command is:"
    echo "${CMD}"

    ${CMD}
    
    EXIT_STATUS=$?
elif [ "${TYPE}" == "FTP" ]; then
    echo "Sviluppare FTP"
fi

echo "Exit status is: ${EXIT_STATUS}"

echo "::set-output name=exit-status::${EXIT_STATUS}"

exit ${EXIT_STATUS}