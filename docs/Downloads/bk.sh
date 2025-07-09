#!/usr/bin/env bash
input="${1%/}"

# Check if the input exists
if [ ! -e "$input" ]; then
  echo "Error: '$input' does not exist."
  exit 1
fi

# Handle file or directory
if [ -d "$input" ]; then
  # If it's a directory
  tar -zcvf "$input.tar.gz" "$input" && rm -rf "$input"
  echo "Backup complete for directory: $input -> $input.tar.gz"
elif [ -f "$input" ]; then
  # If it's a file
  tar -zcvf "$input.tar.gz" "$input" && rm -f "$input"
  echo "Backup complete for file: $input -> $input.tar.gz"
else
  echo "Error: '$input' is neither a regular file nor a directory."
  exit 1
fi


## Check if the input directory exists
##if [ ! -d "$input" ]; then
#  echo "Error: Directory '$input' does not exist."
#  exit 1
#fi
#
## Create a tarball and remove the directory
#tar -zcvf "$input.tar" "$input" && rm -rf "$input"
#echo "Backup complete: $input.tar"
#
#tar -zcvf "$1".tar "$1" && rm "$1" -fr
