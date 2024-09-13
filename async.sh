#!/bin/bash

func() {
  delay=$((1 + $RANDOM % 10))
  sleep $delay
  echo "Slept for $delay seconds"
}

for _ in {1..10}
do
  func &
done

echo "Waiting for all to finish"

wait

echo "All done"