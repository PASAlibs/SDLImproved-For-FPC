#!/bin/bash
input="no"
fpc demo.pas -Fu.. &&\
read -p "Execute ? [Y/n] " input
input=`echo $input | tr '[:upper:]' '[:lower:]'`
if [ -z $input ] || [ $input = "y" ] || [ $input = "yes" ]
then
	./demo
fi
