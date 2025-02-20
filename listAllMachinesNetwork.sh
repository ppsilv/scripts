#!/bin/bash

sudo nmap -sn 192.168.1.0/24 | grep "Nmap scan report for\|MAC"

