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
OPTIONS="\
 Edit
 Upload"


main(){
  if [[ $(test_connection) = "0" ]]; then
  # Locate the desired file
  opt=$(zenity --list\
  --checklist\
  --title="Options"\
  --text="Select one option" \
  --width 500 --height 400\
  --column="Options" --column="" "" Upload "" Edit ) || exit -1

  case "$(cut -f1 -d'|' <<< "$opt")" in
    [Ee]dit)
          file_name=$(zenity --entry --title "File selection"  --text "Enter a file name or some regex" --width 300 --height 100)
          if [ -z "$file_name" ]; then
            zenity --error --text "No file provided!"
            exit -1
          fi

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
          [ "${chosen_ones}" ] && ssh_download "$chosen_ones" || exit 0
          while [ 1 ]
          do
            look_updates
            sleep "$VERIFY_INTERVAL"
          done
      ;;
      [Uu]pload)
                # TODO: write this part
                echo "In progress..."
      ;;

      *)
        exit -1
      ;;
    esac
  else
      # printf "${RED}Error on connection!${NC}\n"
      zenity --error --text "Error on connection!" --width 100 --height 50
      exit -1
  fi
}

credentials=$(zenity --text "Insert your credentials" --forms\
 --add-entry "Username"\
 --add-entry "Host address" --width 400 --height 100) || exit -1
user=$(cut -f1 -d'|' <<< "$credentials")
addr=$(cut -f2 -d'|' <<< "$credentials")
# Call main function
main $user "$addr"
