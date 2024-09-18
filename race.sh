#!/bin/bash

CYAN='\033[1;36m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
NC='\033[0m'
PACE_MODE="pace"
TIME_MODE="time"
CALC_MODE="calc"

mode=$PACE_MODE
distance=0

usage() {
  printf "  race ${YELLOW}[OPTIONS]${NC} [time args]\n\n"
  printf "  ${CYAN}Options${NC}\n"
  printf "\t-d\tdistance\n"
  printf "\t\tprovide a distance in kms\n"
  printf "\t-m\tmode <pace|time|calc>\n"
  printf "\t\tpace mode - calculate the average pace per km to run a distance in a specific time\n"
  printf "\t\ttime mode - calculate the resulting time running a distance at the provided pace\n\n"
  printf "\t\tcalc mode - takes two times and adds them together\n\n"
  printf "  ${CYAN}Examples${NC}\n"
  printf "    race -d 10 40:00\t# will calculate the average pace to run 10km in 40 minutes\n"
  printf "    >>> Average Pace: ${GREEN}4:00${NC}\n"
  printf "    race -d 10 -m time 4:00\t# will calculate the final time for 10 km at 4:00/km\n"
  printf "    >>> Final Time: ${GREEN}40:00${NC}\n"
  printf "    race -m calc 40:45 5:25\t# will add the two times together\n"
  printf "    >>> 46:10\n"
}

zeroPad() {
  if [ $1 -lt 10 ]; then
    echo "0${1}"
  else
    echo $1
  fi
}

formatTime() {
  secsArg=$1
  hours=0
  
  secs=$((secsArg % 60))
  minutes=$((secsArg / 60))

  if [ $minutes -gt 60 ]; then
    hours=$((minutes / 60))
    minutes=$((minutes % 60))
  fi

  time=''
  if [ $hours -gt 0 ]; then
    time="$hours:"
  fi
  time+="$(zeroPad $minutes):$(zeroPad $secs)"
  echo "$time"
}

getSecondsFromTime() {
  IFS=':' read -ra timeParts <<< "$1"
  unset IFS
  len=${#timeParts[@]}
  power=1
  secs=0
  for ((i=len-1; i >= 0; i--));
  do
    secs=$((${timeParts[$i]} * power + secs))
    power=$((power * 60))
  done
  echo $secs
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
          mode=$TIME_MODE
          ;;
        calc)
          mode=$CALC_MODE
          ;;
        *)
          usage
          exit 1
          ;;
      esac
      ;;
    d)
      # distance
      distance=$((${OPTARG}))
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

# get time argument
shift $(($OPTIND - 1))
secs=$(getSecondsFromTime $1)

if [ $mode = $PACE_MODE ]; then
  paceTotal=$((secs/distance))
  printf "Average Pace: ${GREEN}$(formatTime $paceTotal)${NC} per km\n"
fi

if [ $mode = $TIME_MODE ]; then
  targetSeconds=$((secs*distance))
  printf "Final Time: ${GREEN}$(formatTime $targetSeconds)${NC}\n"
fi

if [ $mode = $CALC_MODE ]; then
  b_secs=$(getSecondsFromTime $2)
  t_secs=$((secs + b_secs))
  printf "$(formatTime $t_secs)\n"
fi