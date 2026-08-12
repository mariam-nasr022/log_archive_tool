#!/bin/bash
#
# Script Name : Log-Archive.sh
# Discription : Collects and archives logs to keep them organized and accessible
# Usage : ./Log-Archive.sh 
# Author : Mariam Nasr
# Version : 1.0


# Variables 
Log_dir="/var/log"                    # directory that contains the system log files
Archive_dir="/var/log/archive"        # directory where the compressed archive will be stored
Days=7                                # Log files older than this number of days will be archived
                               


# Commands

 mkdir -p $Archive_dir     # to create a directory if is not exist


# Function to find old file logs

find_old_logs (){
		   find "$Log_dir" -type f -name "*.log" -mtime +"$Days"
        		

	    # -type f  -> search for regular files
            # -name    -> search for files ending with .log
  	    # -mtime   -> find files modified more than $Days 
}


# function to archive file log 

archive_log (){
		echo " The files are ready for archive and compress "
		echo " ============================================ "

		tar -czvf "$Archive_dir/logs.tar.gz" $(find_old_logs)
		
		# tar options:
         	# -c -> create a new archive
  	        # -z -> compress the archive using gzip
    		# -v -> display the files being added
	        # -f -> specify the archive file name

	
	if [ $? -eq 0 ]     # $? -> The exit status of the last command  
	                    # 0 -> tar command completed successfully
	then 
		echo " Compressed Archive created successfully "
	else
		echo " Copressed Archive failed "
	fi 
}



#Main

archive_log	# Call archive_log function
