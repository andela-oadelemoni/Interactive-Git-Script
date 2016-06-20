#!/bin/bash

echo "===================================="
echo "=========== Script Starts =========="

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
modified=$(git status -s 2> /dev/null | sed -E 's/^.{2}//g')
if [ -z "$modified" ]
then
	echo "##############################################"
        echo "## There are no changes to this repository! ##"
        echo "##############################################"
        exit 0	
fi

# Next prompt user to 'git add' all or 'git add' selectively
# Define needed functions for the 'git add' stage
# Define special colours needed
YELLOW='\033[1;33m'
RED='\033[0;31m'
END='\033[0m'

function push {
	read -p "Do you want to push to a remote branch? [y/n]: " pushOption
	case $pushOption in
	  [Yy]* ) read -e -p "Enter name of branch: " branch;;
	  [Nn]* ) echo "===========  Script Ends  ==========";
		echo "===================================="exit 0;;
	esac
	
	if [ -z "$branch" ]
	then
		push
	else
		git push origin "$branch"
		echo "===========  Script Ends  =========="
		echo "===================================="
	fi
}

function commit {
        read -e -p "Enter your commit message: " msg
        if [ -z "$msg" ]
        then
                echo -e "${RED}You know commit message shouldn't be empty right?${END}"
                commit
        else
                git commit -m "$msg"
        fi
	push
}

function show_added_files {
	echo "Added files:"
	param=("${@}")
	for file in ${param[@]}
	do
		echo -e "${YELLOW}$file${END}"
	done
}

function interactive_add {
	added=()
	for file in ${modified[@]}
	do
		read -p "Add $(echo -e ${YELLOW}$file${END}) to staging? [y/n]: " addyn
		case $addyn in
		  [Yy]* ) git add $file; added+=($file);;
		  [Nn]* ) ;;
		esac
	done
	show_added_files ${added[@]}
}

function add_all {
	git add --all
	show_added_files $modified
}

read -p "Do you wish to add all unstaged files? [y/n]: " yn 

case $yn in
 [Yy]* ) add_all;;
 [Nn]* ) interactive_add;;
esac

commit

# Next is to ask the user if they'd like to push to a remote branch
# And prompt them for the branch


