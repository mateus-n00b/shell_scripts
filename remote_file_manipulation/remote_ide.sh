#!/bin/bash
# This script:
#     Downloads and edit a set of files from a remote machine
#
#
# TODO: Implement the checksum veryfing and files upload to server functions
#
#
# Imports
source ssh_functions.sh

# Avoiding trojans
alias ssh="$(/usr/bin/which ssh)"
alias zenity="$(/usr/bin/which zenity)"

# Colors
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # no color

main(){
  if [[ $(test_connection) = "0" ]]; then
  # Locate the desired file
  file_name=$(zenity --entry --title "File selection" --text "Enter a file name or some regex" --width 300 --height 100)

  # checklist
  chosen_ones=$(zenity --list\
  --checklist\
  --title="Options"\
  --text="Select the files to edit" \
  --width 500 --height 400\
  --column="Files" \
  --column="" $(ssh_cmd "locate $file_name") | sed 's/^$//g')

  # Handle zenity output
  chosen_ones="$(sed 's/|/\n/g' <<< "$chosen_ones")"
  # Is empty?
  [ "${chosen_ones}" ] && ssh_download "$chosen_ones"

  else
      # printf "${RED}Error on connection!${NC}\n"
      zenity --error --text "Error on connection!" --width 100 --height 50
  fi
}

user=$(zenity --entry --title "User" --text "User name" --width 300 --height 100)
addr=$(zenity --entry --title "Host" --text "Host address" --width 300 --height 100)
# Call main function
main $user "$addr"
