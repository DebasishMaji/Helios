import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import java.util.Properties;

public class StreamProcessingJob {
    public static void main(String[] args) throws Exception {
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        Properties properties = new Properties();
        properties.setProperty("bootstrap.servers", "localhost:9092");
        properties.setProperty("group.id", "test");

        FlinkKafkaConsumer<String> consumer = new FlinkKafkaConsumer<>("events-topic", new SimpleStringSchema(), properties);
        DataStream<String> stream = env.addSource(consumer);

        stream.map(new MapFunction<String, String>() {
            @Override
            public String map(String value) throws Exception {
                return "Processed: " + value;
            }
        }).addSink(new ElasticsearchSink.Builder<>()).print();

        env.execute("Flink Streaming Job");
    }
}
