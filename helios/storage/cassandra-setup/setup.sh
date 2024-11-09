#!/bin/bash
echo 'Setting up Cassandra...'

# Add the Apache Cassandra repository and install
echo 'deb http://www.apache.org/dist/cassandra/debian 311x main' | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl https://downloads.apache.org/cassandra/KEYS | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y cassandra

# Start Cassandra service
sudo systemctl enable cassandra
sudo systemctl start cassandra

echo 'Cassandra setup complete.'