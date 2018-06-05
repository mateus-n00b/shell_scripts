# This script:
#   provide useful functions for remote_ide.sh
#
#
# Auth Infos
user=""
addr=""

test_connection(){
  /usr/bin/ssh-copy-id "$user@$addr"
  ssh "$user@$addr" "ls" > /dev/null
  echo $?
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
      scp "$user@${addr}:$f" "$save"
    done
  )
}
