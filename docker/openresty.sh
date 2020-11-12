#!/usr/bin/env bash
wget https://openresty.org/package/centos/openresty.repo
sudo mv openresty.repo /etc/yum.repos.d/

# update the yum index:
sudo yum check-update

sudo yum install openresty -y