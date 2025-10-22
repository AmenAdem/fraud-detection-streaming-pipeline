package com.fraud.pipe;

import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.api.common.serialization.SimpleStringSchema;
import org.apache.flink.connector.kafka.sink.KafkaRecordSerializationSchema;
import org.apache.flink.connector.kafka.sink.KafkaSink;
import org.apache.flink.connector.kafka.source.KafkaSource;
import org.apache.flink.connector.kafka.source.enumerator.initializer.OffsetsInitializer;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.ProcessFunction;
import org.apache.flink.util.Collector;

public class FraudDetectionJob {

    public static void main(String[] args) throws Exception {
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        KafkaSource<String> source = KafkaSource.<String>builder()
                .setBootstrapServers("kafka:9092")
                .setTopics("transactions")
                .setGroupId("fraud-detection-group")
                .setStartingOffsets(OffsetsInitializer.earliest())
                .setValueOnlyDeserializer(new SimpleStringSchema())
                .build();

        KafkaSink<String> sink = KafkaSink.<String>builder()
                .setBootstrapServers("kafka:9092")
                .setRecordSerializer(KafkaRecordSerializationSchema.builder()
                        .setTopic("fraud-alerts")
                        .setValueSerializationSchema(new SimpleStringSchema())
                        .build()
                )
                .build();

        DataStream<String> transactions = env
                .fromSource(source, WatermarkStrategy.noWatermarks(), "Kafka Source");

        DataStream<String> fraudAlerts = transactions
                .process(new FraudDetectionFunction())
                .name("Fraud Detection");

        fraudAlerts.sinkTo(sink).name("Kafka Sink");
        env.execute("Fraud Detection Job");
    }


    //start with a simple rule-based fraud detection to check kafka integration is working

    public static class FraudDetectionFunction extends ProcessFunction<String, String> {

        @Override
        public void processElement(String transaction, Context ctx, Collector<String> out) throws Exception {
            if (transaction.toLowerCase().contains("fraud") ||
                transaction.toLowerCase().contains("suspicious") ||
                (transaction.contains("amount") && transaction.contains("10000"))) {
                String alert = "FRAUD ALERT: " + transaction + " - Timestamp: " + System.currentTimeMillis();
                out.collect(alert);
                System.out.println("Fraud detected: " + alert);
            } else {
                System.out.println("Normal transaction: " + transaction);
            }
        }
    }
}
