#!/bin/bash
echo 'Setting up Apache NiFi...'

# Download and extract NiFi
wget https://downloads.apache.org/nifi/1.15.3/nifi-1.15.3-bin.tar.gz
tar -xzf nifi-1.15.3-bin.tar.gz
sudo mv nifi-1.15.3 /usr/local/nifi

# Start NiFi service
/usr/local/nifi/bin/nifi.sh install
sudo service nifi start

echo 'NiFi setup complete. Access it at http://localhost:8080/nifi'
