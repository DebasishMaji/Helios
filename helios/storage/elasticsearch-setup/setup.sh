#!/bin/bash
echo 'Setting up Elasticsearch...'

# Install Elasticsearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-amd64.deb
sudo dpkg -i elasticsearch-7.15.2-amd64.deb
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

echo 'Elasticsearch setup complete.'
