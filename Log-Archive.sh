#!/bin/bash
#
# Script Name : Log-Archive.sh
# Description : Finds old log files, compresses them into dated archives,
#               logs script activity, and removes expired archives.
#
# Usage : ./Log-Archive.sh [Days]
# Author : Mariam Nasr
# Version : 1.0



#================== Function to display help information =========================

show_help () {
    echo "Log Archive Tool"
    echo "================"
    echo "Description: Finds old log files, creates compressed archives,"
    echo "             logs script activity, and removes expired archives."
    echo
    echo "Usage:"
    echo "    ./Log-Archive.sh [days]"
    echo
    echo "Options:"
    echo "    -h    Display this help message"
    echo
    echo "Examples:"
    echo "    ./Log-Archive.sh"
    echo "    ./Log-Archive.sh 5"
    echo "    ./Log-Archive.sh -h"
}


#================ Check if the user requested help ==============================

if [ "$1" = "-h" ]
then
    show_help
    exit 0
fi




# Variables
Log_dir="/var/log"                      # directory that contains the system log files
Archive_dir="/var/log/archive"          # directory where the compressed archive will be stored
Log_file="$Archive_dir/log_archive.log" # Define the log file path
Days=${1:-7}                            # Log files older than this number of days will be archived
Retention_days=45                       # Number of days before old archives are removed



#===================== Function to write messages to log file =====================


log_message(){
                local message="$1"
                local timestamp

                timestamp=$(date +"%Y-%m-%d %H:%M:%S")
                echo "$timestamp - $message" >> "$Log_file"
}








#===================== Validate that Days is a numeric value =================================

    if ! [[ "$Days" =~ ^-?[0-9]+$ ]]
    then
          echo "Error: Days must be a number"
          exit 1
    fi


#====================== Validate that Days is greater than zero ===============================

    if [ "$Days" -le 0 ]
    then
          echo "Error: Days must be greater than 0"
          exit 1
    fi



# Commands

mkdir -p "$Archive_dir"     # Create the directory if it does not exist

        if [ $? -ne 0 ]     #Check if archive directory failed
        then
              echo "Error: Failed to create archive directory"
              log_message "ERROR: Failed to create archive directory"
              exit 1

        else
               echo "Archive directory created successfully"
               log_message "Archive directory created successfully"
        fi


touch "$Log_file"

        if [ $? -ne 0 ]       # Check if Log file creation failed
        then
              echo "Error: Failed to create log file"
        exit 1
        fi




# Function to find old file logs

find_old_logs (){
                    find_output1=$(find "$Log_dir" -type f -name "*.log" -mtime +"$Days")

                    # Store matching log files in a variable for further processing

                        if [ $? -ne 0 ]
                        then
                                echo "Error: Failed to search for old log files"
                                log_message "ERROR: Failed to search for old log files"
                                 exit 1
                         fi



                         mapfile -t old_logs <<< "$find_output1"        # Store the found log files in an array

                         if [ ${#old_logs[@]} -eq 0 ]
                         then
                               echo "No old log files found"
                               log_message "No old log files found"
                         else
                               echo "Old log files found"
                               log_message "Old log files found"
                         fi


            # -type f  -> search for regular files
            # -name    -> search for files ending with .log
            # -mtime   -> find files modified more than $Days days ago
}


# Function to create a compressed, date-based archive

archive_log (){
                echo " The files are ready for archive and compress "
                echo " ============================================ "

                tar -czvf "$Archive_dir/logs$(date +"%Y-%m-%d").tar.gz" "${old_logs[@]}"

                # tar options:
                # -c -> create a new archive
                # -z -> compress the archive using gzip
                # -v -> display the files being added
                # -f -> specify the archive file name


        if [ $? -eq 0 ]     # $? -> The exit status of the last command
                            # 0 -> tar command completed successfully
        then
                echo " Compressed Archive created successfully "
                log_message "Compressed archive created successfully"
        else
                echo "Error: Failed to create compressed archive"
                log_message "ERROR: Failed to create compressed archive"
                exit 1
         fi
}






clean_up_old_archives (){

        find_output2=$(find "$Archive_dir" -type f -name "logs*.tar.gz" -mtime +"$Retention_days")

                 if [ $? -ne 0 ]    # Check if find command failed
                 then
                      echo "Error: Failed to find old archives"
                      log_message "ERROR: Failed to find old archives"
                      exit 1
                 fi
# Check if find returned any old archives before creating the array

                             if [ -z "$find_output2" ]
                             then
                                    old_archives=()
                             else
                                    mapfile -t old_archives <<< "$find_output2"
                             fi

                 if [ ${#old_archives[@]} -eq 0 ]
                 then
                      echo "No old archives found"
                      log_message "No old archives found"
                 else
                      echo "Old archives found"

# Delete all archives older than the retention period

                 rm -- "${old_archives[@]}"

                            if [ $? -ne 0 ]    # Check if archive deletion failed
                            then
                                 echo "Error: Failed to delete old archives"
                                 log_message "ERROR: Failed to delete old archives"
                                 exit 1
                                 fi

                log_message "Old archives deleted successfully"

                 fi
}





#============================== Main =====================================================
find_old_logs                                   #call find_old_log function

# Archive logs only if old log files were found

if [ ${#old_logs[@]} -gt 0 ]
then
    archive_log                                 # Call archive_log function
fi

clean_up_old_archives                            # Call clean_up_old_archives

log_message "Script completed successfully"
