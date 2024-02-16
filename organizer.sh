#! /bin/bash

# Define Variables

    # Declaring Default values
    extensionLength=${extensionLength:-5}
    logBool=${logBool:-0}

# Function for checking if logging is enabled, what command to log, and where to log it
function log() {
    local logBool=$1 # Logging enabled
    local cmd=$2 # Command to run
    local log_output_file=$3 # Where to log the command

    if [ "$logBool" -eq 1 ]; then
        $cmd
        $cmd >> "$logPath/$logFile" # Execute the command and write output to log file
    else
        # Execute the command without logging
        $cmd
    fi
}

function controls () {

    echo ""
    echo "===================================="
    echo ""
    echo "### Basic Arguments ###"
    echo ""
    echo "  -      -h <help> : Display this information on how to use the script."
    echo "  -      -f <path_to_directory>: Input for the directory to be sorted."
    echo "  -      -m <path_to_misc_directory>: Input for the miscellaneous directory to be sorted."    
    echo "  -      -l <logPath>: Directory for the log file output."
    echo "              The default is no logging but this command enables it once given an argument."
    echo ""
    echo "  -      -n <log_file_name>: Input for the name of the log file."
    echo "  -      -x <misc_extension_length>: Input for the extension length to send to the Misc directory."
    echo "              The default character limit is 5."
    echo ""
    # echo "===================================="
    # echo ""
    # echo "### Statistics ###"
    # echo ""
    # echo "  -      -s <statistics>: Echoes the following statistics after moving all files in the directory:"
    # echo ""
    # echo "  -      -s = Display all statistics"
    # echo "  -       -sN = Display the number of files sorted"
    # echo "  -       -sS = Display the size of files sorted"
    # echo "  -       -sQ = Display the time taken"
    # echo ""
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
while getopts ":h:f:m:l:n:x:" opt; do
    case $opt in
        h) # option h - Display controls for using the program
            controls
            ;;

        f) # option f - Input directory for files to be sorted
            fileDir=$OPTARG

                # Check if directory does not exist
                if [[ ! -d $fileDir ]]; then
                    echo "$fileDir does not exist"
                fi
            ;;
        
        m) # option m - Input directory for misc directory
            miscDir=$OPTARG
            ;;

        l) # option l - Input directory for logging to log file
            logPath=$OPTARG
            logBool=1

                # Check if directory does not exist
                if [[ ! -d $logPath ]]; then
                    mkdir $logPath
                fi

                # Check if log file name is changed, if not, set to standard format name instead
                if [[ ! -n $logFile ]]; then
                    logFile="extension_sorter-$(date +"%Y-%m-%d_%H-%M-%S").log"
                fi
            ;;

        n) # option n - Change the name for the log file (default = named ($inputDir_$(date "%Y%m%d").log))
            logFile=$OPTARG
            ;;

        x) # option x - Change the minumum character length to be moved to Misc directory
            extensionLength=$OPTARG
            ;;

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
            log $logBool "echo Invalid option: -$OPTARG" "$logPath/$logFile"
                # display usage and exit
                controls
                exit 0
                ;;

        :) # no argument
            log $logBool "echo Option -$OPTARG requires an argument." "$logPath/$logFile"
                # display usage and exit
                controls
                exit 1
                ;;

        esac
done

# Check if misc directory is changed, if not, set to within file path instead
if [[ ! -n $miscDir ]]; then
    miscDir="$fileDir/Misc"
fi

# Record the current date and time for logging purposes
log $logBool 'echo ' "$logPath/$logFile"
log $logBool "echo Current Time: $(date +%Y-%m-%d_%H-%M-%S)" "$logPath/$logFile"
log $logBool 'echo ' "$logPath/$logFile"

# Check if Misc directory is created, if not, create it
if [ ! -d "$miscDir" ]; then
    log $logBool "echo ====================================" "$logPath/$logFile"
    log $logBool "echo Creating the directory: '$miscDir'" "$logPath/$logFile"
    mkdir "$miscDir"
fi
# Loop through each file in the checking directory
for file in "$fileDir"/*; do
    if [ -f "$file" ]; then
        extension="${file##*.}"

        # Choose where the extension directories go
        extensionDir=$fileDir/$extension

        #Check if the extension is over 4 characters
        if [ ${#extension} -gt $extensionLength ]; then
            log $logBool "echo ====================================" "$logPath/$logFile"
            log $logBool "echo Moving '$file' to the '$miscDir' folder" "$logPath/$logFile"
            mv "$file" "$miscDir"
        else
        # Check if extension directory is created, if not, create it
            if [ ! -d "$extensionDir" ]; then
                log $logBool "echo ====================================" "$logPath/$logFile"
                log $logBool "echo Creating the directory: $extension" "$logPath/$logFile"
                mkdir "$extensionDir"
            fi
            
            # Move the remaining files to their correct folder
            log $logBool "echo ====================================" "$logPath/$logFile"
            log $logBool "echo File Path: '$file'" "$logPath/$logFile"
            log $logBool "echo File Extension: $extension" "$logPath/$logFile"
            log $logBool "echo Moving it to: '$fileDir/$extension' directory" "$logPath/$logFile"
            mv "$file" "$extensionDir"
        fi
    fi
done;

# Add another line because it looks nice
log $logBool "echo ====================================" "$logPath/$logFile"

# Statistics go here