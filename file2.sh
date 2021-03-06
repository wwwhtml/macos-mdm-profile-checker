#!/bin/bash
# Script name: file2.sh
# Author: Daniel Arauz - DanArauz@gmail.com
# Date: January 21, 2019 (MLK Day!)
# Description: Checks for the existance of MDM profiles on MacOS computets.
# This script is intennted to be uploaded via SSH to a remote computer, so then can run on it.
# Generated results are collected remotely.
# +---------------------------------------------------------------------------------+
profilesCheck=$(profiles -C)
noProfiles="There are no configuration profiles installed in the system domain"

if [[ "$profilesCheck" == "$noProfiles" ]] ; then
    echo "$profilesCheck"
    echo "$(hostname)\t$(ipconfig getifaddr en0) PROFILES-NO" > profiles-check-results.log
    rm file2.sh
else
    Profiles -C
    echo "$(hostname)\t$(ipconfig getifaddr en0) PROFILES-YES" > profiles-check-results.log
    rm file2.sh
fi
