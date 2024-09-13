#!/bin/sh

X=0
while [ -n "$X" ]
do
  echo "Enter some text (RETURN to quit)"
  read X
  [ -n "$X" ] && echo "You said: $X"
done