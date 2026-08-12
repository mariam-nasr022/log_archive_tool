# Log Archive Tool

A Bash script that automatically finds old `.log` files and archives them into a compressed `tar.gz` file.

## 📌 Overview

Log files can accumulate over time and consume unnecessary disk space.

This tool helps organize old log files by:

- Searching for `.log` files older than a specified number of days.
- Collecting the matching log files.
- Compressing them into a `tar.gz` archive.
- Storing the archive in a dedicated directory.
- Displaying the archive process and its result.

## ⚙️ How It Works

The script follows these steps:

1. Defines the log directory and archive directory.
2. Creates the archive directory if it does not exist.
3. Searches for `.log` files older than 7 days.
4. Creates a compressed archive using `tar` and `gzip`.
5. Checks the command exit status.
6. Displays whether the archive was created successfully.

## 🛠️ Technologies

- Bash
- Linux
- `find`
- `tar`
- `gzip`

## 📂 Configuration

The main configuration variables are:

```bash
Log_dir="/var/log"
Archive_dir="/var/log/archive"
Days=7
