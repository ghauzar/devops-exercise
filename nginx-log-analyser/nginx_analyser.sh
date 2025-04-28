#!/bin/bash

log_file="$1" # First parameter

if [[ ! -f "$log_file" ]]; then
    echo " Sorry, $log_file not found"
    exit 1
fi

topIpad=$( awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | head -n 5 | awk '{printf "%s - %d requests\n", $2, $1}')
topPath=$(awk -F'"' '{print $2}' "$log_file" | awk '{print $2}' | sort | uniq -c | sort -nr | head -n 5 | awk '{printf "%s - %d requests\n", $2, $1}')
topResponseStat=$(awk -F '"' '{print $3}' "$log_file" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 5 | awk '{printf "%s - %d requests\n", $2, $1}')
topUserAgent=$(awk -F '"' '{print $6}' "$log_file" | sort | uniq -c | sort -nr | head -n 5 | awk '{printf "%s - %d requests\n", $2, $1}')

echo "========================================="
echo "|  Top 5 IP addresses (most requests)   |"
echo "========================================="
while IFS= read -r line; do
    echo "$line"
done <<< "$topIpad"
echo ""

echo "========================================="
echo "|     Top 5 Most Requested Paths        |"
echo "========================================="
while IFS= read -r line; do
    echo "$line"
done <<< "$topPath"
echo ""

echo "========================================="
echo "|      Top 5 Response Status Codes      |"
echo "========================================="
while IFS= read -r line; do
    echo "$line"
done <<< "$topResponseStat"
echo ""

echo "========================================="
echo "|           Top 5 User Agents           |"
echo "========================================="
while IFS= read -r line; do
    echo "$line"
done <<< "$topUserAgent"


