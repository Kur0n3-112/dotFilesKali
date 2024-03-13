#!/bin/bash

# this file is located in /etc/rc.local

sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled

sudo echo never > /sys/kernel/mm/transparent_hugepage/defrag
