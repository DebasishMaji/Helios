#!/bin/bash

# Define base directory
BASE_DIR="/Users/priyakumari/Projects/Helios/helios"

# Function to print and execute a command
run_command() {
    echo "Running: $1"
    eval $1
    if [ $? -ne 0 ]; then
        echo "Error encountered while running: $1"
        exit 1
    fi
}

# Create all necessary directories with necessary permissions and logs
setup_directories() {
    echo "Setting up project directories..."
    mkdir -p $BASE_DIR/\
        dashboard/grafana-setup \
        etl/debezium-setup \
        etl/nifi-setup \
        ingestion/consumer \
        ingestion/kafka-setup \
        ingestion/producer \
        monitoring/elk-setup \
        monitoring/grafana-dashboards \
        monitoring/prometheus-setup \
        orchestration/kubernetes-setup \
        processing/flink-jobs \
        processing/utils \
        storage/cassandra-setup \
        storage/elasticsearch-setup \
        storage/indexer

    echo "Directories setup complete."
}

# Initialize scripts in each subdirectory for production
create_setup_scripts() {
    echo "Creating setup scripts..."

    # Setup Grafana
    echo "#!/bin/bash\necho 'Setting up Grafana...'\n\n# Update system packages\nsudo apt-get update\n\n# Install Grafana\nsudo apt-get install -y grafana\n\n# Enable and start Grafana service\nsudo systemctl enable grafana-server\nsudo systemctl start grafana-server\n\n# Install necessary plugins\ngrafana-cli plugins install grafana-piechart-panel\ngrafana-cli plugins install grafana-clock-panel\n\n# Configure data sources\ncat <<EOF | sudo tee /etc/grafana/provisioning/datasources/datasource.yml\napiVersion: 1\ndatasources:\n  - name: Prometheus\n    type: prometheus\n    url: http://localhost:9090\n    access: proxy\n    isDefault: true\nEOF\n\nsudo systemctl restart grafana-server\n\necho 'Grafana setup complete. Access it at http://localhost:3000'" > $BASE_DIR/dashboard/grafana-setup/setup.sh

    # Setup Debezium
    echo "#!/bin/bash\necho 'Setting up Debezium...'\n\n# Download and setup Kafka Connect with Debezium\nwget https://downloads.apache.org/kafka/2.8.1/kafka_2.13-2.8.1.tgz\ntar -xzf kafka_2.13-2.8.1.tgz\nmv kafka_2.13-2.8.1 /usr/local/kafka\n\n# Download Debezium connector plugins\ncurl -L -o /usr/local/kafka/connect/debezium-connector-mysql.tar.gz https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/1.9.5.Final/debezium-connector-mysql-1.9.5.Final-plugin.tar.gz\ntar -xzf /usr/local/kafka/connect/debezium-connector-mysql.tar.gz -C /usr/local/kafka/connect\n\necho 'Debezium setup complete.'" > $BASE_DIR/etl/debezium-setup/setup.sh

    # Setup NiFi
    echo "#!/bin/bash\necho 'Setting up Apache NiFi...'\n\n# Download and extract NiFi\nwget https://downloads.apache.org/nifi/1.15.3/nifi-1.15.3-bin.tar.gz\ntar -xzf nifi-1.15.3-bin.tar.gz\nsudo mv nifi-1.15.3 /usr/local/nifi\n\n# Start NiFi service\n/usr/local/nifi/bin/nifi.sh install\nsudo service nifi start\n\necho 'NiFi setup complete. Access it at http://localhost:8080/nifi'" > $BASE_DIR/etl/nifi-setup/setup.sh

    # Setup Kafka
    echo "#!/bin/bash\necho 'Setting up Kafka...'\n\n# Install Java (Kafka prerequisite)\nsudo apt-get install -y openjdk-11-jdk\n\n# Download and extract Kafka\nwget https://downloads.apache.org/kafka/2.8.1/kafka_2.13-2.8.1.tgz\ntar -xzf kafka_2.13-2.8.1.tgz\nsudo mv kafka_2.13-2.8.1 /usr/local/kafka\n\n# Start Zookeeper\n/usr/local/kafka/bin/zookeeper-server-start.sh -daemon /usr/local/kafka/config/zookeeper.properties\n\n# Start Kafka server\n/usr/local/kafka/bin/kafka-server-start.sh -daemon /usr/local/kafka/config/server.properties\n\necho 'Kafka setup complete.'" > $BASE_DIR/ingestion/kafka-setup/setup.sh

    # Setup Consumer
    echo "#!/bin/bash\necho 'Starting Kafka Consumer...'\n\n# Start a Kafka consumer\n/usr/local/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test-topic --from-beginning\n\necho 'Kafka Consumer started.'" > $BASE_DIR/ingestion/consumer/start.sh

    # Setup Producer
    echo "#!/bin/bash\necho 'Starting Kafka Producer...'\n\n# Start a Kafka producer\n/usr/local/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test-topic\n\necho 'Kafka Producer started.'" > $BASE_DIR/ingestion/producer/start.sh

    # Setup ELK Stack
    echo "#!/bin/bash\necho 'Setting up ELK Stack...'\n\n# Install Elasticsearch\nwget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-amd64.deb\nsudo dpkg -i elasticsearch-7.15.2-amd64.deb\nsudo systemctl enable elasticsearch\nsudo systemctl start elasticsearch\n\n# Install Logstash\nwget https://artifacts.elastic.co/downloads/logstash/logstash-7.15.2.deb\nsudo dpkg -i logstash-7.15.2.deb\nsudo systemctl enable logstash\nsudo systemctl start logstash\n\n# Install Kibana\nwget https://artifacts.elastic.co/downloads/kibana/kibana-7.15.2-amd64.deb\nsudo dpkg -i kibana-7.15.2-amd64.deb\nsudo systemctl enable kibana\nsudo systemctl start kibana\n\necho 'ELK Stack setup complete. Access Kibana at http://localhost:5601'" > $BASE_DIR/monitoring/elk-setup/setup.sh

    # Setup Prometheus
    echo "#!/bin/bash\necho 'Setting up Prometheus...'\n\n# Download and extract Prometheus\nwget https://github.com/prometheus/prometheus/releases/download/v2.30.3/prometheus-2.30.3.linux-amd64.tar.gz\ntar -xzf prometheus-2.30.3.linux-amd64.tar.gz\nsudo mv prometheus-2.30.3.linux-amd64 /usr/local/prometheus\n\n# Start Prometheus\n/usr/local/prometheus/prometheus --config.file=/usr/local/prometheus/prometheus.yml &\n\necho 'Prometheus setup complete. Access it at http://localhost:9090'" > $BASE_DIR/monitoring/prometheus-setup/setup.sh

    # Setup Kubernetes
    echo "#!/bin/bash\necho 'Setting up Kubernetes...'\n\n# Install kubectl\ncurl -LO 'https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl'\nchmod +x kubectl\nsudo mv kubectl /usr/local/bin/\n\n# Install Minikube\ncurl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64\nchmod +x minikube-linux-amd64\nsudo mv minikube-linux-amd64 /usr/local/bin/minikube\n\n# Start Minikube cluster\nminikube start\n\necho 'Kubernetes setup complete.'" > $BASE_DIR/orchestration/kubernetes-setup/setup.sh

    # Setup Flink Jobs
    echo "#!/bin/bash\necho 'Setting up Flink Jobs...'\n\n# Download and extract Apache Flink\nwget https://archive.apache.org/dist/flink/flink-1.14.4/flink-1.14.4-bin-scala_2.12.tgz\ntar -xzf flink-1.14.4-bin-scala_2


