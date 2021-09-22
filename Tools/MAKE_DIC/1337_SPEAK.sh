#!/bin/bash

word=$1
file=DIC_$word.txt
#nc=$(echo "$word"| tr -d '[[:space:]]' | wc -c)
nc=$(echo ${#word})
path_mp64=~/Tools/maskprocessor/src/mp64.bin

function lette(){
	a=$1
	if [[ "$a" = "a"  ||  "$a" = "A" ]]
	then 
		la=$(echo $a | sed 's/[a|A]/[a,A,@,4]/g')
		echo "$la "
	elif [[ "$a" = "b" || "$a" = "B" ]]
	then
		la=$(echo $a | sed 's/[b|B]/[b,B,8]/g')
		echo "$la "
	elif [[ "$a" = "e" || "$a" = "E" ]]
	then
		la=$(echo $a | sed 's/[e|E]/[e,E,3,w,W]/g')
		echo "$la "
	elif [[ "$a" = "i" || "$a" = "I" || "$a" = "l" || "$a" = "L" || "$a" = "t" || "$a" = "T" ]]
	then 
		la=$(echo $a | sed 's/[i|I|l|L|t|T]/[1,i,I,L,7,L,l,T,t]/g')
		echo "$la "
	elif [[ "$a" = "s" || "$a" = "S" ]]
	then
		la=$(echo $a | sed 's/[s|s]/[5,$,s,S]/g')
		echo "$la "
	elif [[ "$a" = "z" || "$a" = "Z" ]]
	then
		la=$(echo $a | sed 's/[z|Z]/[z,Z,2]/g')
		echo "$la "
	elif [[ "$a" = "o" || "$a" = "O" ]]
	then
		la=$(echo $a | sed 's/[o|O]/[o,O,0]/g')
		echo "$la "
	elif [[ "$a" = "u" || "$a" = "U" || "$a" = "v" || "$a" = "V" ]]
	then 
		la=$(echo $a | sed 's/[u|U|v|V]/[u,U,v,V]/g')
		echo "$la "
	else
		Upper=$(echo "$a"|sed 's/'$a'/\U&/g')
		Lower=$(echo "$a"|sed 's/'$a'/\L&/g')
		la=$(echo "[$Upper,$Lower]")
		echo "$la "
	fi
}

function crea(){
	for i in $(echo $word | grep -o .)
	do
		lette $i | tr -d '\n' 
	done
}

declare -a A1=()
declare -a A2=()
declare -a A3=()
declare -a A4=()
declare -a charac=()
declare -a B1=()
declare -a B2=()
declare -a B3=()
declare -a B4=()
declare -a res=()
declare -a sint=()

for i in  $(crea $word | sed 's/[\[|,]//g' | sed 's/\]//g')
do 
	a=$(echo ${#i})
	if [ $a == 2 ] 
	then 
		A1+=("$i")
	elif [ $a == 3 ]
	then 
		A2+=("$i")
	elif [ $a == 4 ]
	then 
		A3+=("$i")
	elif [ $a > 5 ]
	then 
		A4+=("$i")
	fi
done 


for o in $(seq 1 4)
do 
	eval 'j=( "${'A"$o"'[@]}" )'
	if [ ${#j[@]} != "0" ]
	then 
		((n=n+1))
		eval 'B'"$n"'=("${j[@]}")'
		f=$(echo "${j[@]}" | grep -o . | sort -u | sed 's/ //g')
		flags=$(echo "-$n.$f " | tr -d '\n')
		sint+=("$flags")
	fi
done 

for w in $(echo $word | grep -o .)
do
	if [[ "${B1[@]}" =~ $w  ]]; 
	then
		m=?1
		charac+=("$m")
	elif [[ "${B2[@]}" =~ $w  ]];
	then 
		m=?2
		charac+=("$m")
	elif [[ "${B3[@]}" =~ $w  ]];
	then 
		m=?3
		charac+=("$m")
	elif [[ "${B4[@]}" =~ $w  ]];	
	then 
		m=?4
		charac+=("$m")
	fi
done

starts=$(echo "$path_mp64 " | tr -d '\n')
cha=$(echo "${charac[@]}" | sed 's/ //g')
special_car="$cha?d?d?d?d?d"
end=$(echo "${sint[@]/./ }")

echo "$starts $end $cha | egrep \"^`crea $word| sed 's/ //g'`\""
#echo "$starts $end $special_car | egrep \"^`crea $word| sed 's/ //g'`\""
$starts $end $cha | egrep "^`crea $word| sed 's/ //g'`"  >> $file
#$starts $end $special_car | egrep "^`crea $word| sed 's/ //g'`"  >> $file
