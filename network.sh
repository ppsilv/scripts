#!/bin/bash
#

#/etc/netplan$ sudo vim 90-NM-0e5cb369-6de9-4cc4-ba7f-20a7b1552c8b.yaml
#pdsilva@raspi001:/etc/netplan$ sudo netplan apply
#Deixar somente um arquivo depois que eu apaguei várias copias e coloquei o codigo abaixo no arquivo acima e funcionou depois 
#de rodar o comando sudo netplan apply
#
#network:
#  version: 2
#  ethernets:
#    eth0:
#      dhcp4: no
#      addresses:
#        - 192.168.1.100/24
#      gateway4: 192.168.1.1
#      nameservers:
#        addresses:
#          - 8.8.8.8
#          - 8.8.4.4
#
#
