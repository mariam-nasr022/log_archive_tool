# Log Archive Tool

A Bash-based Linux utility that finds old `.log` files, compresses them into date-based `tar.gz` archives, logs script activity, and removes expired archives according to a retention policy.

## 📌 Overview

Log files can accumulate over time and consume unnecessary disk space.

This tool helps manage old log files by:

* Searching for `.log` files older than a specified number of days.
* Validating the number of days provided by the user.
* Creating a dedicated archive directory if it does not exist.
* Compressing old log files into `tar.gz` archives.
* Naming archives using the current date.
* Logging important operations and errors.
* Removing archives older than the configured retention period.
* Providing a help option with usage information.

## ⚙️ How It Works

The script follows these steps:

1. Checks whether the user requested help using `-h`.
2. Sets the number of days from the command-line argument or uses `7` days by default.
3. Validates that the provided value is a positive number.
4. Creates the archive directory if it does not exist.
5. Creates the script log file.
6. Searches `/var/log` for `.log` files older than the specified number of days.
7. Creates a compressed archive using `tar` and `gzip`.
8. Names the archive using the current date.
9. Records successful operations and errors in the log file.
10. Removes archives older than the configured retention period.

## 🚀 Usage

Make the script executable:

```bash
chmod +x Log-Archive.sh
```

Run with the default number of days:

```bash
./Log-Archive.sh
```

The default value is `7` days.

Run with a custom number of days:

```bash
./Log-Archive.sh 10
```

Display help:

```bash
./Log-Archive.sh -h
```

## 🗂️ Archive Naming

Archives are stored in:

```text
/var/log/archive
```

and are named using the current date:

```text
logsYYYY-MM-DD.tar.gz
```

Example:

```text
logs2026-08-15.tar.gz
```

## 🧹 Retention Policy

The script automatically removes compressed archives older than the configured retention period.

The current retention period is:

```bash
Retention_days=45
```

This means archives older than `45` days are removed during script execution.

## 📝 Logging

Script activity is recorded in:

```text
/var/log/archive/log_archive.log
```

The log contains timestamps and messages for important operations, including:

* Archive directory creation
* Log file discovery
* Archive creation
* Cleanup operations
* Errors
* Script completion

## ⚠️ Error Handling

The script checks the exit status of important commands such as:

* `mkdir`
* `find`
* `tar`
* `rm`

If a critical operation fails, an error message is displayed and recorded in the log file.

## 🛠️ Technologies

* Bash
* Linux
* `find`
* `tar`
* `gzip`
* `date`
* `mapfile`

## 📂 Configuration

The main configuration variables are:

```bash
Log_dir="/var/log"
Archive_dir="/var/log/archive"
Log_file="$Archive_dir/log_archive.log"
Days=${1:-7}
Retention_days=45
```

| Variable         | Description                           | Default                            |
| ---------------- | ------------------------------------- | ---------------------------------- |
| `Log_dir`        | Directory containing system log files | `/var/log`                         |
| `Archive_dir`    | Directory where archives are stored   | `/var/log/archive`                 |
| `Log_file`       | File used to record script activity   | `/var/log/archive/log_archive.log` |
| `Days`           | Age of log files to archive           | `7`                                |
| `Retention_days` | Age after which archives are removed  | `45`                               |

