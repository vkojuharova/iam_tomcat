vagrant-iam-castest-poc
=======================

Vagrant-powered environment for deploying a CAS test application using Apache and Tomcat.

General notes
-------------
For the local install, we are using a box (image) from [Puppet Labs](http://puppet-vagrant-boxes.puppetlabs.com/). For the remote install, we are using the most recent Amazon Linux AMI.

Puppet modules are pulled in using r10k on the VM.

Getting started
---------------
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](http://docs.vagrantup.com/v2/installation/index.html)
3. Clone this repository to a local directory

Running locally with VirtualBox
-------------------------------
1. From within this directory, run: `vagrant up --provider virtualbox`

