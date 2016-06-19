#!/bin/bash
# Use this script to write commit messages

# First check if the directory is a git repo
repo_check=$(git status 2>&1 /dev/null | grep 'Not a git repository')
if [ -n "$repo_check" ]
then
	echo "###################################"
	echo "## This is not a git repository! ##"
	echo "###################################"
	exit 0
fi

# Next step is to check if there are modified files in the repo
modified=$(git status -s 2> /dev/null | sed 's/[M\?{2}]//g' 2> /dev/null)
if [ -z "$modified" ]
then
	echo "##############################################"
        echo "## There are no changes to this repository! ##"
        echo "##############################################"
        exit 0	
else
	echo "Nice changes bro. Time to commit"
	printf "%s\n" $modified
fi


#read -p "Please enter your name: " name 
#echo The name you entered is $name

#case $name in
# [Kk]* )  echo Are you Kamiye?;;
# [Oo]* ) echo Are you Oluwakamie?;;
# [Aa]* ) echo Are you Ashekhame?;;
#esac

