# random number generating function
random_number() {
	BOUNDARY=$1
	echo $(($RANDOM % $BOUNDARY ))
}

# checking the parameters
if [[ -z $1 ]]; then
	echo "Give me any number from 0 to 4 as first parameter and see if you guessed!"
	exit 0
fi

if [[ -z $2 ]]; then
	echo "Give me any number from 1 to 100 as second parameter to use as ceiling for generation"
	exit 0
fi

if [[ -z $3 ]]; then
	echo "Give me a number of attempts as third parameter!"
	exit 0
fi

# assigning parameter values to variables
NUMBER=$1
BOUND_ARG=$2
ATTEMPTS=$3

# checking the validity of the values in variables - if invalid, setting default
if (( $BOUND_ARG > 1 )) && (( $BOUND_ARG < 100 )); then
	GEN_NUMBER=`random_number $BOUND_ARG`
else
	GEN_NUMBER=`random_number 5`
fi

if (( $3 > 0 )); then
	ATTEMPTS=$3
else 
	ATTEMPTS=1
fi		


# variable we use to store the NUMBER value we change in attempts (imo easier to read)
ARG_NUMBER=$NUMBER

# variable to use to check for new game to enter a value in the first loop iteration
NEW_GAME=0
# attempts loop, on every iteration comparing generated number with the user's and
# if they aren't equal - letting user pick another number (except for the last attempt)
for (( i = $ATTEMPTS; i > 0; i--)); do
	if [[ $NEW_GAME == 1 ]]; then
		read -p "Pick a number: " NUMBER
	elif [[ $NEW_GAME == 0 ]]; then
		ARG_NUMBER=$NUMBER
	fi
	if [[ $GEN_NUMBER > $ARG_NUMBER ]]; then
		echo "My number is bigger than your number :^)"
		if (( $i != 0 )); then	
			read -p "Pick another number: " NUMBER
		fi
		continue
	elif [[ $GEN_NUMBER < $ARG_NUMBER ]]; then
		echo "Your number is bigger than mine :^)"
		if (( $i != 0 )); then	
			read -p "Pick another number: " NUMBER
		fi
		continue
	elif [[ $GEN_NUMBER == $ARG_NUMBER ]]; then
		echo "Our numbers are equal."
		read -p "Want to try again? y/n " TRY
		case $TRY in
			y* ) GEN_NUMBER=`random_number $BOUND_ARG`
			i=$ATTEMPTS
			NEW_GAME=1;;
			n* ) exit 0;;
		esac
	fi
done
