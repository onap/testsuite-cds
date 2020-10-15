#!/bin/bash

if [ "$(wc -c $FAILED_TESTS_DIRECTORY/*|awk '/total/ {print $1}')" -gt 0 ]
then
 echo "exiting due to presence of files in FAILED_TESTS_DIRECTORY"
 wc -c $FAILED_TESTS_DIRECTORY/*
 exit 1;
fi
