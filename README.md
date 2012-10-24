# Overview

This project will provision a virtual machine using
[Vagrant](http://vagrantup.com). After provisioning, the vm should be packaged
into a box and made available for other team members to download.

Doing so will allow a team member to get starting using this vm by simply doing
the following steps:

    curl -O http://[server]/vm.box       #=> download the vm box
    vagrant box add box_name vm.box      #=> adds the vm box

    # inside the project directory
    vagrant init                         #=> creates vagrantfile (optional)
    vagrant up                           #=> start the vm


## Provisioning

Before you can package and distribute the vm as a box you'll need to provision
it. You can do so by executing the `provision.sh` script. 

The provisioning script will do the following:

    bundle install                                  #=> install gems to vendor/bundle
    librarian-chef install                          #=> install the cookbooks
    vagrant up                                      #=> provision the vm
    vagrant package --vagrantfile Vagrantfile.pkg   #=> package the vm
    vagrant box add box_name package.box            #=> add box to local boxes
