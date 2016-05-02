#!/bin/bash

battery_info=`ioreg -rc AppleSmartBattery`
current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')

percent="$((($current_charge * 100) / $total_charge))"

if [ $percent -ge 70 ]; then
  echo -n '#[fg=colour048]'
elif [ $percent -ge 50 ]; then
  echo -n '#[fg=colour184]'
elif [ $percent -ge 30 ]; then
  echo -n '#[fg=colour202]'
else
  echo -n '#[fg=colour196]'
fi

echo -n "♥︎ "

if [ $percent -le 20 ]; then
  echo -n '!'
fi

echo "$percent%"


