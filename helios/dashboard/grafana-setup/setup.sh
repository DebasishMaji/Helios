#!/bin/bash
echo 'Setting up Grafana...'

# Update system packages
sudo apt-get update

# Install Grafana
sudo apt-get install -y grafana

# Enable and start Grafana service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Install necessary plugins
grafana-cli plugins install grafana-piechart-panel
grafana-cli plugins install grafana-clock-panel

# Configure data sources
cat <<EOF | sudo tee /etc/grafana/provisioning/datasources/datasource.yml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    url: http://localhost:9090
    access: proxy
    isDefault: true
EOF

sudo systemctl restart grafana-server

echo 'Grafana setup complete. Access it at http://localhost:3000'