#!/bin/bash

# Set the path to Navicat Premium
navicat_path="/Applications/Navicat Premium.app"

# Check if Navicat Premium is installed
if [ -e "$navicat_path" ]; then
    echo "Navicat Premium found at $navicat_path"

    # Step 1: Delete preferences file
    rm -rf ~/Library/Preferences/com.navicat.NavicatPremium.plist

    # Step 2: Detect Navicat version
    file=$(defaults read "$navicat_path/Contents/Info.plist")
    regex="CFBundleShortVersionString = \"([^\.]+)"
    [[ $file =~ $regex ]]
    version=${BASH_REMATCH[1]}

    # Step 3: Choose the appropriate preferences file based on version
    case $version in
        "17")
            preferences_file=~/Library/Preferences/com.navicat.NavicatPremium.plist
            ;;
        "16")
            preferences_file=~/Library/Preferences/com.navicat.NavicatPremium.plist
            ;;
        "15")
            preferences_file=~/Library/Preferences/com.prect.NavicatPremium15.plist
            ;;
        *)
            echo "Version '$version' not handled"
            exit 1
            ;;
    esac


    # Step 4: Reset trial time
    echo "Reseting trial time for Navicat Premium version $version..."
    regex="([0-9A-Z]{32}) = "
    [[ $(defaults read "$preferences_file") =~ $regex ]]
    hash=${BASH_REMATCH[1]}

    if [ ! -z $hash ]; then
        defaults delete "$preferences_file" $hash
    fi

    regex="\.([0-9A-Z]{32})"
    [[ $(ls -a ~/Library/Application\ Support/PremiumSoft\ CyberTech/Navicat\ CC/Navicat\ Premium/ | grep '^\.') =~ $regex ]]
    hash2=${BASH_REMATCH[1]}

    if [ ! -z $hash2 ]; then
        rm ~/Library/Application\ Support/PremiumSoft\ CyberTech/Navicat\ CC/Navicat\ Premium/.$hash2
    fi

    echo "Trial time reset for Navicat Premium version $version"
else
    echo "Navicat Premium not found. Please set the correct path in the script."
    exit 1
fi
