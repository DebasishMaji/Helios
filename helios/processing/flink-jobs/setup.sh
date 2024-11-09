#!/bin/bash
echo 'Setting up Apache Flink Jobs...'

# Download and extract Apache Flink
wget https://archive.apache.org/dist/flink/flink-1.14.4/flink-1.14.4-bin-scala_2.12.tgz
tar -xzf flink-1.14.4-bin-scala_2.12.tgz
sudo mv flink-1.14.4 /usr/local/flink

# Start Flink cluster
/usr/local/flink/bin/start-cluster.sh

echo 'Flink Jobs setup complete.'
