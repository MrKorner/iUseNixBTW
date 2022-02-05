while true
do
 volume=$(pactl list sinks | grep '^[[:space:]]Volume:' | \
    head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
 battery=$(acpi| sed -e 's/\<0\>//g' |sed -e 's/\<Battery\>//g' |sed 's/ ://')
 date=$(date +'%H:%M:%S -- %a:%d-%B')
 separator=$(printf "[==]")
 echo "🔋$battery $separator $date $separator 🔈$volume%"
 sleep 0.5
done
