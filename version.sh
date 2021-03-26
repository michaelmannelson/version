#!/bin/bash

#git clone https://github.com/michaelmannelson/getversion.git
#cd getversion
#chmod +x version.sh
#cd <PATH TO YOUR PROJECT>
#<PATH TO YOUR PROJECT>/version.sh

declare -r df="%Y-%m-%d %H:%M:%S%z"
declare -r now=$(date -u +"$df")
declare -r pwd="$PWD"
declare -r file="VERSION"
declare -r path="$pwd/$file"

if [ ! -s "$path" ]; then
  echo $now > "$path"
fi
read -r date < "$path"
date -d "$date" 2>/dev/null 1>/dev/null; declare -r check=$(echo $?)
if [ $check -ne 0 ]; then
  echo "ERROR: Invalid date value from \"$path\""
  cat "$path"
  exit 1
fi

declare -r start=$(date -d "$date")
declare total=$(($(date -d "$now" "+%s") - $(date -d "$start" "+%s")))
declare -r year=$(($total / 31557600)); total=$(($total % 31557600))
declare -r month=$(($total / 2629800)); total=$(($total % 2629800))
declare -r day=$(($total / 86400)); total=$(($total % 86400))
declare -r second=$(printf "%.0f\n" $(echo "$(echo "$total/86400" | bc -l) * 65535" | bc -l))
declare -r version="$year.$month.$day.$second" #declare -r v="$(printf "%02d" $year).$(printf "%02d" $month).$(printf "%02d" $day).$(printf "%05d" $second)"

echo "$date" > "$path"
echo "$now" >> "$path"
echo "$version" >> "$path"
cat "$path"
