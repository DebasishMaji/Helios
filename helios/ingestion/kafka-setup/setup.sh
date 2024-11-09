#!/bin/bash
echo 'Setting up Kafka...'

# Install Java (Kafka prerequisite)
sudo apt-get install -y openjdk-11-jdk

# Download and extract Kafka
wget https://downloads.apache.org/kafka/2.8.1/kafka_2.13-2.8.1.tgz
tar -xzf kafka_2.13-2.8.1.tgz
sudo mv kafka_2.13-2.8.1 /usr/local/kafka

# Start Zookeeper
/usr/local/kafka/bin/zookeeper-server-start.sh -daemon /usr/local/kafka/config/zookeeper.properties

# Start Kafka server
/usr/local/kafka/bin/kafka-server-start.sh -daemon /usr/local/kafka/config/server.properties

echo 'Kafka setup complete.'
