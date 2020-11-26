#!/bin/bash -l

EXIT_STATUS=-99

HOST="${INPUT_HOST}"
USERNAME="${INPUT_USERNAME}"
PASSWORD="${INPUT_PASSWORD:-""}"
SSH_KEY="${INPUT_SSH_KEY:-""}"
REMOTE_FOLDER="${INPUT_REMOTE_FOLDER:-"./"}"
LOCAL_FOLDER="${INPUT_LOCAL_FOLDER:-"./"}"
PORT="${INPUT_PORT:-"21"}"
TYPE="${INPUT_TYPE:-"ftp"}"
PUT_GITHUB_SHA="${INPUT_PUT_GITHUB_SHA:-"yes"}"

if [ -z "${HOST}" ]; then
    echo "Host is not defined"
    exit -98
fi

if [ -z "${USERNAME}" ]; then
    echo "Username is not defined"
    exit -97
fi

cd "${LOCAL_FOLDER}"
rm -rf .git
rm -rf .github

if [ "${PUT_GITHUB_SHA}" == "yes" ]; then
    echo "${GITHUB_SHA}" > ".github-put-sftp-action"
fi

echo ""
echo "--- Current location ---"
pwd
echo ""
echo "--- List this directory ---"
ls -lha
echo ""

if [ "${TYPE}" == "sftp" ]; then
    BATCH_FILE=/tmp/commands
    echo "cd ${REMOTE_FOLDER}" > ${BATCH_FILE}
    echo "put -r ." >> ${BATCH_FILE}
    echo "ls" >> ${BATCH_FILE}
    echo "bye" >> ${BATCH_FILE}

    CMD=""

    if [ -n "${PASSWORD}" ]; then
        CMD="sshpass -p \"${PASSWORD}\" "
    fi

    CMD="${CMD} sftp -P ${PORT} -oStrictHostKeyChecking=no -oBatchMode=no -b ${BATCH_FILE} "

    if [ -n "${SSH_KEY}" ]; then
        export SSH_AUTH_SOCK=/tmp/ssh_agent.sock
        mkdir -p ~/.ssh
        ssh-agent -a $SSH_AUTH_SOCK > /dev/null
        ssh-add - <<< "${SSH_KEY}"
    fi
    
    CMD="${CMD} ${USERNAME}@${HOST} "
    
    echo "Command is:"
    echo "${CMD}"

    ${CMD}
    
    EXIT_STATUS=$?
elif [ "${TYPE}" == "ftp" ]; then
    AUTH="${USERNAME}"
    if [ -n "${PASSWORD}" ]; then
        AUTH="${AUTH},${PASSWORD}"
    fi

    CMD="lftp --debug -e \"set ftp:ssl-allow no; set ftp:use-feat no; mirror -R ./ ${REMOTE_FOLDER}; quit;\" -u ${AUTH} -p ${PORT} ${HOST}"

    echo "Command is:"
    echo "${CMD}"

    lftp --debug -e "set ftp:ssl-allow no; set ftp:use-feat no; mirror -R ./ ${REMOTE_FOLDER}; quit;" -u ${AUTH} -p ${PORT} ${HOST}
    
    EXIT_STATUS=$?
fi

echo "Exit status is: ${EXIT_STATUS}"

echo "::set-output name=exit-status::${EXIT_STATUS}"

exit ${EXIT_STATUS}