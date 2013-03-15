#!/bin/sh
output=`gem list --local | grep -c win32console`
if [ $output -lt 1 ]
then
    gem install win32console
fi
bundle install

