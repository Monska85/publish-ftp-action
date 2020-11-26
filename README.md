# Publish (S)FTP GitHub action

This action publishes your repository in a (S)FTP server.

## Input

| Parameter      | Required |      Values       | Default value | Notes                                                        |
| :------------- | :------: | :---------------: | :-----------: | :----------------------------------------------------------- |
| host           |   Yes    |                   |       -       | Remote (S)FTP server as hostname or IP address               |
| username       |   Yes    |                   |       -       | Username to access to the (S)FTP server                      |
| password       |    No    |                   |       -       | Password to access to the (S)FTP server                      |
| ssh_key        |    No    |                   |       -       | SSH key used for the connection (KEYs with passphrase are not supported) |
| remote_folder  |    No    |                   |      ./       | Remote destination folder                                    |
| local_folder   |    No    |                   |      ./       | Path of the local folder (relative to the GitHub repository) to be transferred to the (S)FTP server |
| port           |    No    |                   |      21       | (S)FTP port                                                  |
| type           |    No    | - ftp<br />- sftp |      ftp      |                                                              |
| put_github_sha |    No    |  - yes<br />- no  |      yes      | If `yes`, the action will create a file `.github-put-sftp-action` containing the `GITHUB_SHA`, which will be transferred to the remote_folder |

## Output

| Name        | Notes                                                        |
| :---------- | :----------------------------------------------------------- |
| exit-status | This variable will be filled with the exit code of the (S)FTP command |