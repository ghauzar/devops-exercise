#!/bin/bash
curr_dir=$(pwd)
date=$(date +%G%m%d_%H%M%S)
cd ~
tar -czvf "logs_archive_$date.tar.gz" $1

if [ -d "$curr_dir/logs/" ]; then
    # Kalau direktori ada
    mv logs*.tar.gz $curr_dir/logs/
else
    # Kalau direktori tidak ada
    mkdir $curr_dir/logs
    mv logs*.tar.gz $curr_dir/logs/
fi

echo "Successful create compressed file 'logs_archive_$date.tar.gz' from $1"
