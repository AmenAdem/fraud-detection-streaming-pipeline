#!/bin/bash

echo "=== Testing Fraud Detection Pipeline ==="
echo "Sending test transactions to Kafka..."

# Normal transactions
echo "Sending normal transactions..."
echo '{"id":"tx001","amount":50,"user":"john","timestamp":"2024-10-10T10:00:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions
echo '{"id":"tx002","amount":250,"user":"alice","timestamp":"2024-10-10T10:01:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions
echo '{"id":"tx003","amount":1200,"user":"bob","timestamp":"2024-10-10T10:02:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions

echo "Normal transactions sent!"

# Suspicious transactions (should trigger fraud alerts)
echo "Sending suspicious transactions..."
echo '{"id":"tx004","amount":15000,"user":"charlie","timestamp":"2024-10-10T10:03:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions
echo '{"id":"tx005","amount":500,"user":"suspicious_user","timestamp":"2024-10-10T10:04:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions
echo '{"id":"tx006","amount":10000,"user":"dave","timestamp":"2024-10-10T10:05:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions
echo '{"id":"tx007","amount":300,"user":"fraud_attempt","timestamp":"2024-10-10T10:06:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions

echo "Suspicious transactions sent!"
echo "Check the fraud-alerts topic to see detected fraud cases."
