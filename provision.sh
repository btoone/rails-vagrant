#!/bin/bash
# Simple script to automate vm provisioning

project_name=${PWD##*/}

echo "Provision: Installing cookbooks"
librarian-chef install

echo "Provision: Provisioning"
vagrant up

echo "Provision: Packaging box"
vagrant package --vagrantfile Vagrantfile.pkg

echo "Provision: Adding box locally"
vagrant box add $project_name package.box

# echo "Provision: Deleting box to save space"
# rm package.box

echo "Provision: Finished provisioning"
