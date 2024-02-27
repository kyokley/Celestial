#!/bin/bash

pip install -Ur requirements.txt

ansible-galaxy install artis3n.tailscale
ansible-galaxy install kwoodson.yedit

ansible-galaxy collection install linode.cloud
pip install -r ~/.ansible/collections/ansible_collections/linode/cloud/requirements.txt
