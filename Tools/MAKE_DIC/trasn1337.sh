#!/bin/bash

word=$1
file=DIC_$word.txt
#nc=$(echo "$word"| tr -d '[[:space:]]' | wc -c)
nc=$(echo ${#word})

function lette(){
	a=$1
	if [[ "$a" = "a"  ||  "$a" = "A" ]]
	then 
		la=$(echo $a | sed 's/[a|A]/[a,A,@,4]/g')
		echo $la
	elif [[ "$a" = "b" || "$a" = "B" ]]
	then
		la=$(echo $a | sed 's/[b|B]/[b,B,8]/g')
		echo $la
	elif [[ "$a" = "e" || "$a" = "E" ]]
	then
		la=$(echo $a | sed 's/[e|E]/[e,E,3,m,w,M,W]/g')
		echo $la
	elif [[ "$a" = "i" || "$a" = "I" || "$a" = "l" || "$a" = "L" || "$a" = "t" || "$a" = "T" ]]
	then 
		la=$(echo $a | sed 's/[i|I|l|L|t|T]/[1,i,I,L,7,L,l,T,t]/g')
		echo $la
	elif [[ "$a" = "s" || "$a" = "S" ]]
	then
		la=$(echo $a | sed 's/[s|S]/[5,$,s,S]/g')
		echo $la
	elif [[ "$a" = "z" || "$a" = "Z" ]]
	then
		la=$(echo $a | sed 's/[z|Z]/[z,Z,2]/g')
		echo $la
	elif [[ "$a" = "o" || "$a" = "O" ]]
	then
		la=$(echo $a | sed 's/[o|O]/[o,O,0]/g')
		echo $la
	elif [[ "$a" = "u" || "$a" = "U" || "$a" = "v" || "$a" = "V" ]]
	then 
		la=$(echo $a | sed 's/[u|U|v|V]/[u,U,v,V]/g')
		echo $la
	else
		Upper=$(echo "$a"|sed 's/'$a'/\U&/g')
		Lower=$(echo "$a"|sed 's/'$a'/\L&/g')
		la=$(echo "[$Upper,$Lower]")
		echo $la
	fi
}

function crea(){
	for i in $(echo $word | grep -o .)
	do
		lette $i | tr -d '\n' 
	done
}

ch=$(crea $word| sed 's/[\[|,]//g'|sed 's/\]//g'| grep -o . |  tr -d '\n')
echo "Run: crunch $nc $nc  $ch | grep \"^`crea $word`\""
#crunch $nc $nc $ch |grep "^`crea $word`" >> $file
