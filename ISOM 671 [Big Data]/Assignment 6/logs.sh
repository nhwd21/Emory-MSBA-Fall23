#!/bin/bash

# run pig script
echo "Running Pig script..."
pig /home/hadoop/logs.pig

# run hive script
echo "Running Hive script..."
hive -f /home/hadoop/logs.hql

echo "Script execution completed."