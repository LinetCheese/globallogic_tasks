#!/bin/bash

DISP_MODE=$1
DISP_COMM=""
CURRENT_PATH=`pwd`

if [[ -z $DISP_MODE ]]; then
	echo "Please enter a display mode!"
	exit 1
else
	if [[ $DISP_MODE == "f" ]]; then 
		DISP_COMM="ls -a"
	elif [[ $DISP_MODE == "s" ]]; then 
		DISP_COMM="ls"
	else
		echo 'Please enter a valid display mode!'
		echo 'f - display with hidden files,'
		echo 's - short display (without hidden files).'
	fi
fi


# In-app commands
change_directory() {
	TEMP_PATH=`realpath "./$2"`
	if [[ ! -e $TEMP_PATH ]]; then
		main_screen $CURRENT_PATH "Please select a valid directory."
		return
	elif [[ -f $TEMP_PATH ]]; then
		TEMP_PATH=`realpath "./$2"`
		main_screen $CURRENT_PATH "Can't move to given path - it is a file."
		return
	else
		CURRENT_PATH=$TEMP_PATH
		cd $CURRENT_PATH
		main_screen $CURRECT_PATH "OK: Moved to another directory"
	fi	
}

copy_file() {
	SOURCE=`realpath ./$2`
	DESTINATION=`dirname $3`
	COMMAND=""
	FILE_NAME=`basename $SOURCE`
	
	#checking if source file/directory exists
	if [[ ! -e $SOURCE ]]; then
		main_screen $CURRENT_PATH "Such source doesn't exist"
		return
	fi

	#checking if destination parent directory exists
	if [[ ! -e $DESTINATION || ! -d $DESTINATION ]]; then
		main_screen $CURRENT_PATH "Can't copy to this destination $DESTINATION."
		return
	fi

	# setting command
	if [[ -f $SOURCE ]]; then
		COMMAND='cp'
	elif [[ -d $SOURCE ]]; then
		COMMAND='cp -r'
	fi

	$COMMAND $SOURCE $DESTINATION/$FILE_NAME
	main_screen $CURRENT_PATH "OK: Copied $FILE_NAME to $DESTINATION"
		
}

replace_file() {
	SOURCE=`realpath ./$2`
	DESTINATION=`dirname $3`
	FILE_NAME=`basename $SOURCE`

	if [[ ! -e $SOURCE ]]; then
		main_screen $CURRENT_PATH "Such source doesn't exist"
		return
	fi

	if [[ ! -e $DESTINATION || ! -d $DESTINATION ]]; then
		main_screen $CURRENT_PATH "Can't move to this destination $DESTINATION."
		return
	fi

	mv $SOURCE $DESTINATION/$FILENAME
	main_screen $CURRENT_PATH "OK: Moved $FILE_NAME to $DESTINATION"	
}

delete_file() {
	SOURCE=`realpath ./$2`
	COMMAND=""
	FILE_NAME=`basename $SOURCE`

	if [[ ! -e $SOURCE ]]; then
		main_screen $CURRENT_PATH "Such source doesn't exist"
		return
	fi

	if [[ -f $SOURCE ]]; then
		COMMAND="rm"
	elif [[ -d $SOURCE ]]; then
		COMMAND="rm -r"
	fi

	$COMMAND $SOURCE
	main_screen $CURRENT_PATH "OK: delelted $SOURCE"
}

exit_app() {
	exit 0
}

# Main screen function displaying files and giving the user
# menu with commands.
# Accepts current path as a parameter.
# Accepts status message as a second parameter that is displayed at the top
main_screen() {
	echo $2
	echo ''
	echo "Location: $CURRENT_PATH"
	echo 'Files :'
	echo '----------------------------------------------------'	
	$DISP_COMM $CURRENT_PATH
	echo '----------------------------------------------------'
	echo ''
	echo '[Change directory: cd][Copy: cp]'
	echo '[Replace/rename: mv][Delete: rm]'
	echo '[exit: q]'

	read -p "command: " COMM
	case $COMM in
		cd* ) change_directory $COMM;;
		cp* ) copy_file $COMM;;
		mv* ) replace_file $COMM;;
		rm* ) delete_file $COMM;; 
		q ) exit_app;;
		* ) echo ""; main_screen $CURRENT_PATH "Please enter a valid command!";;
	esac
}

main_screen
