#SECURITY_GROUP=$(ec2-metadata -s | awk '{ print $2 }')
#export AWS_REGION=$(ec2-metadata -z | awk '{ print $2 }' | sed 's/[a-z]$//')
#aws --region $AWS_REGION ec2 authorize-security-group-ingress --group-name $SECURITY_GROUP --protocol tcp --port 80 --cidr '0.0.0.0/0'
#aws --region $AWS_REGION ec2 authorize-security-group-ingress --group-name $SECURITY_GROUP --protocol tcp --port 443 --cidr '0.0.0.0/0'
#mkdir -p /var/task
#curl -o /var/task/server.js https://gist.githubusercontent.com/unshift/5c14f58fb8e497a3a98663e4c5c6d7c7/raw/fcf30f7eaaeac8fda5916e8842baeae09c79cc9c/server.js
