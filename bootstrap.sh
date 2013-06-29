#!/usr/bin/env bash

apt-get update -y
apt-get install -y git curl vim

curl -L https://get.rvm.io | sudo -u vagrant bash -s stable --ruby=2.0.0