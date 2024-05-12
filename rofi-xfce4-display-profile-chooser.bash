#!/bin/bash
# vim: set ft=sh:
shopt -s extglob

###
# rofi script to switch between display profiles
#
# This script uses xfconf-query to list available display profiles
# and to switch between them.
#
# Usage
#
#  rofi -modi "Display Profiles:rofi-display-profiles.sh" -show "Display Profiles"
#

requires_command(){
  if ! command -v "$1" &>/dev/null; then
    echo "Error: $1 is not installed" >&2
    exit 1
  fi
}

get_display_profiles(){
  local profiles

  # an array of /some-id/some-device/EDID
  profiles=()

  for item in $(xfconf-query -l -c displays); do
    # if the item does not match the pattern, skip it
    # must not contain the word "Default" or "Fallback"
    if [[ "$item" =~ Default|Fallback ]]; then
      continue
    fi

    # must end in /EDID
    if [[ ! "$item" =~ EDID$ ]]; then
      continue
    fi

    item=$(echo "$item" | tr '/' ' ')
    id=$(echo "$item" | awk '{print $1}')

    # test if the id is already in the array
    # if it is, skip it
    if [[ "${profiles[*]}" =~ ${id} ]]; then
      continue
    fi
    
    # split the item into id and device and EDID
    device=$(echo "$item" | awk '{print $2}')
    active=$(xfconf-query -c displays -p "/$id/$device/Active")
    name=$(xfconf-query -c displays -p "/$id")

    profiles+=("${id}:${name}:${active}\n")

  done

  # print 
  for item in "${profiles[@]}"; do
    echo -en "$item"
  done
  }


cmd_switch_to_profile(){
  local profile_id
  profile_id="$1"

  coproc bash -c "xfconf-query --create --type string -c displays -p /Schemes/Apply -s $profile_id"
}

# Loop through the profiles and print them
# in the format expected by rofi
# this will be: 
# [icon] name { info: id }

cmd_list_profiles(){

  get_display_profiles |
  while IFS=':' read -r id name active; do
    # NAME, icon: display, info: ID
    icon=""
    if [ "$active" = "true" ]; then
      icon="checkmark"
    fi
    echo -en "${name}\x0icon\x1f${icon}\x1finfo\x1f${id}\n"
  done
}

requires_command xfconf-query

# if there's no arguments, list the profiles
if [[ $# -eq 0 ]]; then
  cmd_list_profiles
  exit 0
fi


# if we 'quit' then exit
if [[ "$*" = "quit" ]]; then
    exit 0
fi

# if rofi provides a profile id, switch to it
if [  -n "$ROFI_INFO" ]; then
  cmd_switch_to_profile "$ROFI_INFO"
fi
