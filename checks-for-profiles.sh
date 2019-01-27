#!/bin/bash
# Script name: checks-for-profiles.sh
# Author: Daniel Arauz - DanArauz@gmail.com
# Date: January 27, 2019
# Description: Checks for the existance of MDM profiles on MacOS computets.
# This script is intennted to be uploaded via SSH to a remote computer, so then can run on it.
# Generated results are collected remotely.
# +---------------------------------------------------------------------------------+
profilesCheck=$(profiles -C)
noProfiles="There are no configuration profiles installed in the system domain"

if [[ "$profilesCheck" == "$noProfiles" ]] ; then
    echo "$profilesCheck"
    echo "$(ipconfig getifaddr en0)\t$(hostname) NO-PROFILES" > profiles-check-results.log
    rm checks-for-profiles.sh
else
    Profiles -C
    echo "$(ipconfig getifaddr en0)\t$(hostname) YES-PROFILES" > profiles-check-results.log
    rm checks-for-profiles.sh
fi
