#!/bin/bash
#
# Assuming I've got my standard directory structure, push out a new site build.

set -e

cd ${HOME}/playbooks/azurefire-playbook
exec ansible-playbook -i hosts site.yml --tags publish
