#! /bin/bash

# Define Variables
userDownloads=~/Downloads # Production (DO NOT USE YET)

parentDir=$(pwd)
fileDir=$parentDir/Download
miscDir=$fileDir/Misc

# Check if Misc directory is created, if not, create it
if [ ! -d "$miscDir" ]; then
    echo "===================================="
    echo "Creating the directory: $miscDir"
    mkdir "$miscDir"
fi
# Loop through each file in the checking directory
for file in "$fileDir"/*; do
    if [ -f "$file" ]; then
        extension="${file##*.}"

        # Choose where the extension directories go
        extensionDir=$fileDir/$extension

        #Check if the extension is over 4 characters
        if [ ${#extension} -gt 4 ]; then
            echo "===================================="
            echo "Moving $file to the Misc folder"
            mv "$file" "$miscDir"
        else
        # Check if extension directory is created, if not, create it
            if [ ! -d "$extensionDir" ]; then
                echo "===================================="
                echo "Creating the directory: $extension"
                mkdir "$extensionDir"
            fi
            
            # Move the remaining files to their correct folder
            echo "===================================="
            echo "File Path: $file"
            echo "File Extension: $extension"
            echo "Moving it to: $extension directory"
            mv "$file" "$extensionDir"
        fi
    fi
done;
