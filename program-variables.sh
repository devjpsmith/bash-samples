#!/bin/sh

echo "I was called with $# parameters"
echo "My name is $(basename $0)"
echo "My first parameter is $1"
echo "All parameters are $@"
echo "My PID is $$"

echo "The Internal Field Separator is $IFS"
old_IFS="$IFS"
IFS=:
echo "Enter thre values separated by colons"
read x y z
IFS="$old_IFS"
echo "x is $x, y is $y, and z is $z"