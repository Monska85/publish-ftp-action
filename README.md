# Publish (S)FTP GitHub action

This action publish your repository in FTP or SFTP server.

## Inputs

### host

**Required** The remote host as hostname or IP address

### username

**Required** The username for access to the (S)FTP server

### password

The password fro access to the (S)FTP server

### ssh_key

SSH key used for the connection (KEYs with passphrase are not supported)

### remote_folder

The remote folder to `chdir` (default: `./`)

### repo_folder

The repository folder to transfer (default: `./`)

### port

The (S)FTP port (default: 21)

### type

FTP or SFTP protocol (default: FTP)

### put_github_sha

Add to transfer a file named `.github-putsftpaction-<GITHUB SHA>` (default: yes)

## Output

### exit-status

The exit status of the (S)FTP command