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
modified=$(git status -s 2> /dev/null | sed 's/[M\?{2}]//g' )
if [ -z "$modified" ]
then
	echo "##############################################"
        echo "## There are no changes to this repository! ##"
        echo "##############################################"
        exit 0	
#else
#	echo "Nice changes bro. Time to commit"
#	printf "%s\n" $modified
fi

# Next prompt user to 'git add' all or 'git add' selectively
# Define needed functions for the 'git add' stage
# Define special colours needed
COLOUR='\033[1;33m'
END='\033[0m'

function interactive_add {
	for file in ${modified[@]}
	do
		read -p "Add $(echo -e ${COLOUR}$file${END}) to staging? [y/n]: " addyn
		case $addyn in
		  [Yy]* ) git add $file;;
		  [Nn]* ) ;;
		esac
	done
}

function add_all {
	git add --all
}

function commit {
        echo "Now it is time to commit some changes"
}

read -p "Do you wish to add all unstaged files? [y/n]: " yn 

case $yn in
 [Yy]* ) add_all; commit;;
 [Nn]* ) interactive_add;;
esac


