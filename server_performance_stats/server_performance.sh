#!/bin/bash

function print_header {
    echo "CPU Usage   : $cpuUsage%"
    echo "Memory Free : $percentFree% ($memFree MB)"
    echo "Memory Used : $percentUsed% ($memUsed MB)"
    echo "Disk Free   : $percentDiskFree% ($diskFree GB)"
    echo "Disk Used   : $percentDiskUsed% ($diskUsed GB)"
    echo "OS Version  : $osVersion"
    echo "Uptime      :$upTime"
}

function update_dynamic_values {
  # Current CPU Usage
  cpuIdle=$(top -bn1 | grep "Cpu(s)" | sed -n 's/.*, *\([0-9.,]*\)[ ]*id.*/\1/p' | sed 's|,|.|g')
  cpuUsage=$(echo "100-$cpuIdle" | bc)
  memTotal=$(free -m | grep "Mem" | awk '{print $2}')
  memFree=$(free -m | grep "Mem" | awk '{print $4}')
  memUsed=$(free -m | grep "Mem" | awk '{print $3}')
  percentFree=$(echo "scale=2; $memFree/$memTotal*100" | bc)
  percentUsed=$(echo "scale=2; $memUsed/$memTotal*100" | bc)
  diskSize=$(df -h / | tail -n 1 | awk '{print $2}')
  diskFree=$(df -h / | tail -n 1 | awk '{print $4}')
  diskUsed=$(df -h / | tail -n 1 | awk '{print $3}')
  percentDiskFree=$(echo "scale=2; $diskFree/$diskSize*100" | bc)
  percentDiskUsed=$(echo "scale=2; $diskUsed/$diskSize*100" | bc)
  osVersion=$(grep "^PRETTY_NAME=" /etc/os-release | cut -d= -f2| tr -d '"')
  upTime=$(uptime -p)

  # Update fields
  tput cup 0 13; echo -n "$cpuUsage%"
  tput cup 1 13; echo -n "$percentFree% ($memFree MB)"
  tput cup 2 13; echo -n "$percentUsed% ($memUsed MB)"
  tput cup 3 13; echo -n "$percentDiskFree% ($diskFree MB)"
  tput cup 4 13; echo -n "$percentDiskUsed% ($diskUsed MB)"
  tput cup 5 13; echo -n "$osVersion"
  tput cup 6 13; echo -n "$upTime"
  tput cup 7 0; echo -n "==================================================================================================="
  tput cup 8 0; echo -n

  # Update top 5 CPU and Memory
  topCpu=$(top -bn1 -o %CPU | head -n 12 | tail -n 5)
  topMem=$(top -bn1 -o %MEM | head -n 12 | tail -n 5)

  # Logged in users
  loggedUsr=$(who -H)

  # Print top 5 Processes by CPU Usage
  tput cup 9 0; echo -n "                        -= Top 5 Processes by CPU Usage =-"
  tput cup 10 0; echo -n "$(top -bn1 | head -n 7 | tail -n 1)"
  tput cup 11 0; echo "$topCpu"
  tput cup 16 0; echo -n "==================================================================================================="
  tput cup 17 0; echo -n

  # Print top 5 Processes by Memory Usage
  tput cup 18 0; echo -n "                      -= Top 5 Processes by Memory Usage =-"
  tput cup 19 0; echo -n "$(top -bn1 | head -n 7 | tail -n 1)"
  tput cup 20 0; echo -n "$topMem"
  tput cup 25 0; echo -n "==================================================================================================="
  tput cup 26 0; echo -n

  #Print Logged in users
  tput cup 27 0; echo -n "             -= Logged in users =-"
  tput cup 28 0; echo "$loggedUsr"
}
  tput clear
  print_header

while true
do

  update_dynamic_values
  sleep 2
done
