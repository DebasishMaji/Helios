#!/bin/bash
echo 'Setting up ELK Stack...'

# Install Elasticsearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-amd64.deb
sudo dpkg -i elasticsearch-7.15.2-amd64.deb
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

# Install Logstash
wget https://artifacts.elastic.co/downloads/logstash/logstash-7.15.2.deb
sudo dpkg -i logstash-7.15.2.deb
sudo systemctl enable logstash
sudo systemctl start logstash

# Install Kibana
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.15.2-amd64.deb
sudo dpkg -i kibana-7.15.2-amd64.deb
sudo systemctl enable kibana
sudo systemctl start kibana

echo 'ELK Stack setup complete. Access Kibana at http://localhost:5601'
