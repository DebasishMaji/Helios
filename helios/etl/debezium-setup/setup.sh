#!/bin/bash
echo 'Setting up Debezium...'

# Download and setup Kafka Connect with Debezium
wget https://downloads.apache.org/kafka/2.8.1/kafka_2.13-2.8.1.tgz
tar -xzf kafka_2.13-2.8.1.tgz
mv kafka_2.13-2.8.1 /usr/local/kafka

# Download Debezium connector plugins
curl -L -o /usr/local/kafka/connect/debezium-connector-mysql.tar.gz https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/1.9.5.Final/debezium-connector-mysql-1.9.5.Final-plugin.tar.gz
tar -xzf /usr/local/kafka/connect/debezium-connector-mysql.tar.gz -C /usr/local/kafka/connect

echo 'Debezium setup complete.'
