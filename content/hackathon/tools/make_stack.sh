#!/bin/bash

# Script to create a stack to use in OCI Resource Manager

cd stack
zip -r -FS ../releases/oci-hackathon-starterkit-stack.zip * \
  -x ".terraform/*" ".terraform.lock.hcl" "modules/releases/*"
cd -
