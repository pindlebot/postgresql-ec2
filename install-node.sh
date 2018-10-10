#!/bin/bash -v

su ec2-user -c "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash"
su ec2-user -c "source /home/ec2-user/.nvm/nvm.sh && nvm install node"
su ec2-user -c "source /home/ec2-user/.nvm/nvm.sh && nvm use node"
ln -s /home/ec2-user/.nvm/versions/node/v10.11.0/bin/node /usr/bin/node
ln -s /home/ec2-user/.nvm/versions/node/v10.11.0/bin/npm /usr/bin/npm