# packer-proxmox-iso

This repo builds automatically Ubuntu VM templates (Ubuntu 22.04) for Proxmox  environment using Hashicorp's Packer and downloads ISOs automatically.  

With this repo VM templates for the following Ubuntu systems can be built.

- Ubuntu Server 22.04


Ubuntu ISO files gets download automatically from public sources.

## How to use this repo

### Pre-requesites 

Make sure you have [Packer](https://www.packer.io/downloads) Version 1.7.1 or later installed. If you don't know Packer, it's a single commandline binary which only needs to be on your `PATH`.

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer

### Step 1: Adjust variables and user data http file

Rename the file [variables.auto.pkrvars.hcl.sample](variables.auto.pkrvars.hcl.sample) to `variables.auto.pkrvars.hcl` and adjust the variables for your VMware vSphere environment. Some documentation on each variable is inside the sample file.
```bash
mv variables.auto.pkrvars.hcl.sample variables.auto.pkrvars.hcl
vim variables.auto.pkrvars.hcl
```

Rename the file [example_user-data](example_user-data) to `user-data` and adjust the body as you wish.
```bash
cd http
mv example_user-data user-data
vim user-data
```


### Step 2: Init Packer

Init Packer by using the following command. (Spot the dot at the end of the command!)
```bash
packer init .
```

### Step 3: Build a VM Template

To build a VM template run one of the provided `build`-scripts.
For example to build a Ubuntu Server 20.04 template run: 
```bash
./build-2004.sh
``` 

### Optional: Template default credentials

the default credentials after a successful build are   
Username: `test`   
Password: `test`  
    
If you would like to change the default ćredentials before a packer build, then you need to edit the following files: 

- **variables.auto.pkrvars.hcl**
- **user-data** (Line 13.14; Line 41)

To generate an encypted password for [user-data](./html/user-data) use the following command: 
```bash
openssl passwd -1
``` 
