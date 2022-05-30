#!/bin/bash
# variable files ending with .auto.pkrvars.hcl are automatically loaded
PACKER_LOG=1 PACKER_LOG_PATH=packer.log packer build -var-file="credentials.pkr.hcl" ./ubuntu-server-template/ubuntu-server-template.pkr.hcl
