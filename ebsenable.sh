#/bin/bash
cat regions.txt | while read line
do
          echo "enabling ${line}"
          aws ec2 enable-ebs-encryption-by-default
          export AWS_REGION="${line}"
done
