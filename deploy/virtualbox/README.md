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

Running a remote instance on EC2
--------------------------------
1. Install the Vagrant AWS plugin:
        vagrant plugin install vagrant-aws
2. Import the Vagrant box we are using:
        vagrant box add amazon-linux-x64-13.09 https://github.com/huit/huit-vagrant-boxes/blob/master/aws/amazon-linux-2013.09.box?raw=true`
3. If you have not setup an EC2 keypair, do so now.
4. If you have deleted the default EC2 security group "basic-web", re-create it or customize this option in step 4.
4. Create a Vagrant configuration file in your home directory to contain your AWS credentials: `~/.vagrant.d/Vagrantfile`
  It should resemble this, and may be expanded with [additional options](https://github.com/mitchellh/vagrant-aws):
```ruby
    Vagrant.configure("2") do |config|
      config.vm.provider :aws do |aws, override|
        aws.access_key_id = "YOUR_AWS_ACCESS_KEY"
        aws.secret_access_key = "YOUR_AWS_SECRET_KEY"
        aws.keypair_name = "CHOOSE_AN_EXISTING_KEYPAIR"

        override.ssh.private_key_path = "PATH_TO_PRIVATE_KEY"
      end
    end
```
5. Run: `vagrant up --provider=aws`
