#!/bin/bash
echo 'Setting up Prometheus...'

# Download and extract Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.30.3/prometheus-2.30.3.linux-amd64.tar.gz
tar -xzf prometheus-2.30.3.linux-amd64.tar.gz
sudo mv prometheus-2.30.3.linux-amd64 /usr/local/prometheus

# Start Prometheus
/usr/local/prometheus/prometheus --config.file=/usr/local/prometheus/prometheus.yml &

echo 'Prometheus setup complete. Access it at http://localhost:9090'
