aws sns list-topics | jq -r '.Topics[] | {TopicArn} | join(" ")' > topics.txt
kms=$(aws kms list-aliases | jq -r '.Aliases[] | {AliasArn} | join(" ")' | grep sns)
cat topics.txt | while read line
do
	aws sns set-topic-attributes \
  --topic-arn $line \
  --attribute-name KmsMasterKeyId \
  --attribute-value $kms

done
