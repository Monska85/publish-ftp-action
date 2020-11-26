# Publish (S)FTP GitHub docker action

This action publish your repo in (S)FTP server.

## Inputs

### host

**Required** The remote host as hostname or IP address.

### username

**Required** The username for access to the (S)FTP server.

### password

The password fro access to the (S)FTP server.

### folder

The folder used for `chdir` (default: `./`).

### port

The (S)FTP port (default: 21).
