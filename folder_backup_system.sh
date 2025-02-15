#!/bin/bash

mem_limit=500
max_retry=3
backup_dir_name="backup"

dirs=("docs" "sheet" "file")

for dir in "${dirs[@]}"; do
    mkdir -p "$dir"
    touch "$dir/sample.text"
done

mkdir -p "$backup_dir_name"
for dir in "${dirs[@]}"; do
    mem=$((RANDOM%1000))
    retry=0

    until [ $retry -eq $max_retry ]; do
        if [ $mem -gt $mem_limit ]; then
            echo "Memory limit exceed! Memory Needed: ${mem} MB"
            exit 1
        fi

        isSuccess=$((RANDOM%2))

        if [ $isSuccess -eq 1 ]; then
            timestamp=$(date +%Y%m%d-%H%M%S)
            backupFileName="$backup_dir_name/backup_${timestamp}_${dir}.tar.gz"
            tar -czf "$backupFileName" "$dir"
            echo "backup done; dir name: $dir"
            break
        else
          echo "${dir} backup failed! retrying for $((retry+1)) time"
          ((retry++))
        fi
    done

    if [ $max_retry -eq $retry ]; then
        echo "Retry limit cross for dir: $dir"
    fi
done
