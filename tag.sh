#/bin/bash
read -p "Enter Key: " key
read -p "Enter value: " value
cat instances.txt | while read line
do
aws ec2 create-tags \
    --resources ${line} \
    --tags "Key=$key,Value=$value"
done
