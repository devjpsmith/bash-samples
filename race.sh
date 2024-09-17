#!/bin/bash

paceMode=1
distance=0
L_CYAN='\033[1;36m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
NC='\033[0m'

usage() {
  printf "race ${YELLOW}[OPTIONS]${NC} [time]\n\n"
  printf "${L_CYAN}OPTIONS${NC}\n"
  printf "\t-d\tdistance\n"
  printf "\t\tprovide a distance in kms\n"
  printf "\t-m\tmode <pace|time>\n"
  printf "\t\tpace mode - find the pace per km to run the specified distance in the provided time\n"
  printf "\t\ttime mode - use the provided time as pace and calculate result time for provided distance\n"
}

formatTime() {
  input_seconds=$1
  hours=0
  
  seconds=$((input_seconds % 60))
  input_seconds=$((input_seconds - seconds))
  minutes=$((input_seconds / 60))

  if [ $minutes -gt 60 ]; then
    m=$((minutes % 60))
    hours=$(((minutes - m) / 60))
    minutes=$((m))
  fi

  if [ $minutes -lt 10 ]; then
    minutes="0$minutes"
  fi

  if [ $seconds -lt 10 ]; then
    seconds="0$seconds"
  fi

  time=''
  if [ $hours -gt 0 ]; then
    time="$hours:"
  fi
  time+="$minutes:$seconds"
  echo "$time"
}

# parse out our options
while getopts "hm:d:" opt; do
  case "${opt}" in
    m)
      # mode
      case "${OPTARG}" in
        pace)
          ;;
        time)
          paceMode=0
          ;;
      esac
      ;;
    d)
      # distance
      distance=$((${OPTARG}))
      ;;
    *)
      usage
      exit
      ;;
  esac
done

# get time argument
shift $(($OPTIND - 1))
time=$1

# 1:01:01
IFS=':' read -ra bits <<< "$time"
unset IFS
len=${#bits[@]}
multiplier=1
seconds=0
for ((i=len-1; i >= 0; i--));
do
  seconds=$((${bits[$i]} * multiplier + seconds))
  multiplier=$((multiplier * 60))
done

if [ $paceMode = 1 ]; then
  paceTotal=$((seconds/distance))
  printf "Target Pace: ${GREEN}$(formatTime $paceTotal)${NC}\n"
fi

if [ $paceMode = 0 ]; then
  targetSeconds=$((seconds*distance))
  printf "Final Time: ${GREEN}$(formatTime $targetSeconds)${NC}\n"
fi
