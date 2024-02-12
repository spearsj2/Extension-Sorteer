#! /bin/bash

# Define Variables
userDownloads=~/Downloads # Production (DO NOT USE YET)

parentDir=$(pwd)
fileDir=$parentDir/Download
miscDir=$fileDir/Misc

function controls () {
    echo ""
    echo "===================================="
    echo ""
    echo "### Basic Arguments ###"
    echo ""
    echo "  -      -h <help> : Display this information on how to use the script."
    echo "  -      -p <path_to_directory>: Input for the directory to be sorted."
    echo "  -      -m <path_to_misc_directory>: Input for the miscellaneous directory to be sorted."    
    echo "  -      -l <log_file_path>: Directory for the log file output."
    echo "  -      -n <log_file_name>: Input for the name of the log file."
    echo "  -      -x <misc_extension_length>: Input for the extension length to send to the Misc directory."
    echo "              The default character limit is 4."
    echo ""
    echo "===================================="
    echo ""
    echo "### Statistics ###"
    echo ""
    echo "  -      -s <statistics>: Echoes the following statistics after moving all files in the directory:"
    echo ""
    echo "  -      -s = Display all statistics"
    echo "  -       -sN = Display the number of files sorted"
    echo "  -       -sS = Display the size of files sorted"
    echo "  -       -sQ = Display the time taken"
    echo ""
    echo "===================================="
    echo ""
}

if [[ $# -eq 0 ]]; then
    echo ""
    echo "Please provide arguments:"
    controls
    exit 0
fi


# # Process command-line options and arguments

while getopts ":h:p:l:n:x:s:sN:sS:sQ" opt; do
    case $opt in
        h) # option h - Display controls for using the program
            controls
            ;;

        p) # option p - Input directory for files to be sorted
            fileDir=$OPTARG
            ;;
        
        m) # option m - Input directory for misc directory
            miscDir=$OPTARG
            ;;

#         l) # option l - Input directory for logging to log file
#             action=$OPTARG
#             ;;

#         n) # option n - Change the name for the log file (default = named ($inputDir_$(date "%Y%m%d").log))
#             display_usage
#             exit 0
#             ;;

#         x) # option x - Change the minumum character length to be moved to Misc directory
#             display_usage
#             exit 0
#             ;;

#         s) # option s - Enable statistics all to be shown after sorting
#             display_usage
#             ;;

#         sN) # option sN - Display only the number of files sorted
#             display_usage
#             ;;

#         sS) # option sS - Display only the total size of files sorted
#             display_usage
#             ;;

#         sQ) # option sQ - Display only the time taken to sort all files
#             display_usage
#             ;;

        \?) # any other option
            echo "Invalid option: -$OPTARG"
                # display usage and exit
                controls
                exit 0
                ;;

        :) # no argument
            echo "Option -$OPTARG requires an argument."
                # display usage and exit
                controls
                exit 1
                ;;

        esac
done

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
