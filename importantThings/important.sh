iificador () {
	while read text; do
		echo $text | sed 's/[aeou]/i/g' | sed 's/[AEOU]/I/g';
	done
}

spongebobicador () {
	convert=""
	threshold=5
	while read text; do
		for e in $(echo $text | sed 's/ /_/g' | sed 's/\(.\)/\1 /g'); do
			rand=$(( ( $RANDOM % 10 )  + 1 ))
			if [ "${rand}" -gt "$threshold" ]; then
				convert=${convert}$(echo $e | tr '[:lower:]' '[:upper:]');
				threshold=$((threshold + 1))
			else
				convert=${convert}${e};
				threshold=$((threshold - 1))
			fi
		done
	done
	echo ${convert} | sed 's/_/ /g'
}

bustrofedar () {
	lineLenght=80;
	currentLine="";
	currentLineIndex=0
	while read text; do
		i=0
		for e in $(echo $text); do
			if [ "$i" -lt "${lineLenght}" ]; then
				if [ $((currentLineIndex%2)) -eq 0 ]; then
					currentLine="${currentLine} ${e}"
				else
					rline=$(echo $e | rev)
					currentLine="${rline} ${currentLine}"
				fi
			else
				echo ${currentLine};
				currentLine=""
			fi
			i=$((i + ${#text}))
		done;
		lenght=${#myvar}
		currentLineIndex=$((currentLineIndex + 1))
	done
	echo $currentLine
}

rand() {
    awk 'BEGIN {
        srand()
        print int(1 + rand() * 100)
    }'
}

enigmatic () {

    times=`rand`
    s=90
    infinite=''
    for var in "$@"; do
        if [ "$var" = "-i" ]; then
            infinite=-1;
        elif [[ "$var" =~ ^[0-9]+$  ]]; then
            s=$var
        else
            echo "Error: accepted options -i for infinite and BPM"
            return
        fi
    done
    enigmatic.x $infinite $s
}

amin () {
    for var in "$@"; do
        if [ "$var" = "yashed" ]; then
            echo "I'm not in your shed you STUPID INFIDEL"
            command_not_found_handler () {
                echo "That command doesn't exist, you STUPID INFIDLE"
            }
            return
        else
            echo "STUPID INFIDEL"
            return
        fi
    done
}
