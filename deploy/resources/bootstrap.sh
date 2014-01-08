#!/bin/sh
yum clean all
[[ $(rpm -qa | grep ^git-) ]] || (yum install -y -q git && sleep 5)
[[ "$(gem query -i -n r10k)" == "true" ]] || gem install --no-rdoc --no-ri r10k
cd /vagrant/resources && r10k -v info puppetfile install
