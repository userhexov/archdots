#!/usr/bin/env bash
export TZ="Etc/GMT-4"

current_time=$(date +"%H:%M")
current_date=$(date +"%d/%m/%y")
today=$(date +"%e")
month_year=$(date +"%B %Y")

calendar=$(cal | sed -e "s/$today/<span class='current-day'>$today<\/span>/")

echo "{\"text\": \" $current_time  $current_date\", \"tooltip\": \"<span class='calendar-header'>$month_year</span>\n$calendar\"}"
