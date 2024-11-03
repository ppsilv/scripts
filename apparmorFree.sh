#!/bin/bash
#
sudo systemctl stop apparmor
sudo systemctl disable apparmor
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0

