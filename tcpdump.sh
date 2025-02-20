#!/bin/bash
#

#sudo tcpdump -ni any icmp and host 8.8.8.8
#this print the payload
sudo tcpdump -XX -ni any icmp and host 8.8.8.8
