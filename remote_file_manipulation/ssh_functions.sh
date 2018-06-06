# This script:
#   provide useful functions for run.sh
#
#
# Auth Infos
user=""
addr=""
MY_DIR=".workspace"
[ -d "$MY_DIR" ] || mkdir "$MY_DIR"
HASH_FILE="${MY_DIR}/ha.sh"
MAP_FILES="${MY_DIR}/files2dir.txt"
VERIFY_INTERVAL="5"

test_connection(){
  /usr/bin/ssh-copy-id "$user@$addr"
  ssh "$user@$addr" "ls" > /dev/null
  echo $?
}

ssh_upload(){
  arr="$1"
  (for f in ${!arr[@]}
  do
    scp "${arr[$f]}" "${user}@${addr}:$(grep ${arr[$f]} ${MAP_FILES})" ; sleep 0.7
    echo "Uploading $(grep ${arr[$f]} ${MAP_FILES})..."

    # Calculates the new hash for the changed file
    grep -v "${arr[$f]}" "$HASH_FILE" > temp
    /usr/bin/sha256sum "${arr[$f]}" >> temp
    mv temp "$HASH_FILE"

    bc -l <<< "$f/${#arr[@]}"
  done) | zenity --progress \
  --title="Uploading" \
  --text="Uploading files" \
  --percentage=0

  if [ "$?" != 0 ] ; then
        zenity --error \
          --text="Upload canceled."
  fi

}

# Function that detect changes on Downloaded files
look_updates(){
  /usr/bin/sha256sum -c "$HASH_FILE" &> /dev/null
  if [ $? -ne 0 ]; then
      code=$(/usr/bin/sha256sum -c "$HASH_FILE" --quiet 2> /dev/null | awk -F':' '{print $1}')
      ssh_upload "$code"
  fi
}

# Run remote commands
ssh_cmd(){
  ssh "$user@$addr" "$1"
}

# Downloads the files listed in the array
ssh_download(){
  arr="$1"
  zenity --text-info --auto-scroll <<< $(
    for f in ${arr[@]}
    do
      save="$(awk -F'/' '{print $NF}' <<< "$f")"
      echo -e "Downloading $save..."
      scp "$user@${addr}:$f" "${MY_DIR}/$save"
      echo "$f" >> "$MAP_FILES"
      /usr/bin/sha256sum "${MY_DIR}/$save" >> "$HASH_FILE"
    done
  )
}
