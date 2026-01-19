#!/usr/bin/env bash

get_emoji() {
    hour=$1
    if (( hour >= 9 && hour < 18 )); then
        echo "💻"  # Computer emoji for working hours
    elif (( hour >= 18 && hour < 24 )); then
        echo "🛋️"  # Relaxing emoji for evening hours
    elif (( hour >= 0 && hour < 9 )); then
        echo "😴"  # Sleeping emoji for early morning hours
    fi
}

echo "Singapore      (SGT):  $(TZ='Asia/Singapore' date +'%d/%m/%Y  %H:%M:%S')  $(get_emoji $(TZ='Asia/Singapore' date +'%k'))"
echo "Raleigh         (ET):  $(TZ='America/New_York' date +'%d/%m/%Y  %H:%M:%S')  $(get_emoji $(TZ='America/New_York' date +'%k'))"
echo "Heilbronn (CET/CEST):  $(TZ='Europe/Berlin' date +'%d/%m/%Y  %H:%M:%S')  $(get_emoji $(TZ='Europe/Berlin' date +'%k'))"
echo "UTC            (UTC):  $(TZ='UTC' date +'%d/%m/%Y  %H:%M:%S')  $(get_emoji $(TZ='UTC' date +'%k'))"
