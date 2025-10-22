#!/bin/bash

echo "=== Monitoring Fraud Alerts ==="
echo "Listening for fraud alerts on the fraud-alerts topic..."
echo "Press Ctrl+C to stop monitoring"
echo ""

docker exec -it kafka kafka-console-consumer.sh \
    --bootstrap-server kafka:9092 \
    --topic fraud-alerts \
    --from-beginning \
    --formatter kafka.tools.DefaultMessageFormatter \
    --property print.key=false \
    --property print.value=true \
    --property print.timestamp=true
