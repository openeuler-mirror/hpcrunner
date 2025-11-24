items=( $(grep  -R "hpckit25.1.0.SPC001-bisheng4.2.0.2.B002" ./top50 | awk -F: '{print $1}'| uniq | xargs echo) )
#echo $items
for item in  "${items[@]}"
do
	[ -z "${item}" ] && continue
	if [ "./top50/config_def_2025.1.0.SPC001.sh" == "$item" ]; then
		continue
	fi
	echo "do:$item"
	#sed -n "s/hpckit25.1.0.SPC001-bisheng4.2.0.2.B002/%#MYKBSVER#%/gp" $item
	#sed -i "s/hpckit25.1.0.SPC001-bisheng4.2.0.2.B002/%#MYKBSVER#%/g" $item
done


items=( $(grep  -R "hmpi25.1.0.SPC001" ./top50 | awk -F: '{print $1}'| uniq | xargs echo) )
#echo $items
for item in "${items[@]}"
do
	[ -z "${item}" ] && continue
	if [ "./top50/config_def_2025.1.0.SPC001.sh" == "$item" ]; then
		continue
	fi
	echo "do:$item"
	#sed -n "s/hpckit25.1.0.SPC001-bisheng4.2.0.2.B002/%#MYKBSVER#%/gp" $item
	#sed -i "s/hmpi25.1.0.SPC001/%#MYKMPIVER#%/g" $item
done


items=( $(grep  -R "hpckit25.1.0.SPC001-gcc12.3.1" ./top50 | awk -F: '{print $1}'| uniq | xargs echo) )
#echo $items
for item in "${items[@]}"
do
	[ -z "${item}" ] && continue
	if [ "./top50/config_def_2025.1.0.SPC001.sh" == "$item" ]; then
		continue
	fi
	echo "do:$item"
	#sed -n "s/hpckit25.1.0.SPC001-bisheng4.2.0.2.B002/%#MYKBSVER#%/gp" $item
	#sed -i "s/hpckit25.1.0.SPC001-gcc12.3.1/%#MYKGCCVER#%/g" $item
done
