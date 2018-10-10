#!/bin/bash -v

su ec2-user -c "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash"
su ec2-user -c "source /home/ec2-user/.nvm/nvm.sh && nvm install node"
su ec2-user -c "source /home/ec2-user/.nvm/nvm.sh && nvm use node"
ln -s /home/ec2-user/.nvm/versions/node/v10.11.0/bin/node /usr/bin/node
ln -s /home/ec2-user/.nvm/versions/node/v10.11.0/bin/npm /usr/bin/npm

INSTANCE_ID=$(ec2-metadata -i | awk '{ print $2 }')
SECURITY_GROUP=$(ec2-metadata -s | awk '{ print $2 }')

aws ec2 authorize-security-group-ingress --group-name $SECURITY_GROUP --protocol tcp --port 80 --cidr '0.0.0.0/0'
aws ec2 authorize-security-group-ingress --group-name $SECURITY_GROUP --protocol tcp --port 443 --cidr '0.0.0.0/0'
mkdir -p /var/task
curl -o /var/task/server.js https://gist.githubusercontent.com/unshift/5c14f58fb8e497a3a98663e4c5c6d7c7/raw/fcf30f7eaaeac8fda5916e8842baeae09c79cc9c/server.js
