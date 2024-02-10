#! /bin/bash

# Define Variables
userDownloads=~/Downloads # Production (DO NOT USE)

testDownloads=$(pwd)/Download

MiscDir=$(pwd)/Misc

# Check if Misc directory is created, if not, create it
if [ ! -d "$MiscDir" ]; then
    echo "===================================="
    echo "Creating the directory: $MiscDir"
    echo "===================================="
    mkdir "$MiscDir"
fi
# Loop through each file in the checking directory
for file in "$testDownloads"/*; do
    if [ -f "$file" ]; then
        extension="${file##*.}"

        #Check if the extension is over 4 characters
        if [ ${#extension} -gt 4 ]; then
            echo "Moving $file to the Misc folder"
            cp "$file" "$MiscDir"
        else
        # Check if extension directory is created, if not, create it
        if [ ! -d "$(pwd)/$extension" ]; then
            echo "Creating the directory: $extension"
            mkdir "$extension"
        fi

        # Move the remaining files to their correct folder
        echo "===================================="
        echo "File Path: $file"
        echo "File Extension: $extension"
        echo "Moving it to the: $extension directory"
        cp "$file" "$extension"
        fi
    fi
done;
