# PowerShell script to test fraud detection pipeline
Write-Host "=== Testing Fraud Detection Pipeline ===" -ForegroundColor Green
Write-Host "Sending test transactions to Kafka..." -ForegroundColor Yellow

# Normal transactions
Write-Host "Sending normal transactions..." -ForegroundColor Cyan
'{"id":"tx001","amount":50,"user":"john","timestamp":"2024-10-10T10:00:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions
'{"id":"tx002","amount":250,"user":"alice","timestamp":"2024-10-10T10:01:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions
'{"id":"tx003","amount":1200,"user":"bob","timestamp":"2024-10-10T10:02:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions

Write-Host "Normal transactions sent!" -ForegroundColor Green

# Suspicious transactions (should trigger fraud alerts)
Write-Host "Sending suspicious transactions..." -ForegroundColor Red
'{"id":"tx004","amount":15000,"user":"charlie","timestamp":"2024-10-10T10:03:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions
'{"id":"tx005","amount":500,"user":"suspicious_user","timestamp":"2024-10-10T10:04:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions
'{"id":"tx006","amount":10000,"user":"dave","timestamp":"2024-10-10T10:05:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions
'{"id":"tx007","amount":300,"user":"fraud_attempt","timestamp":"2024-10-10T10:06:00Z"}' | docker exec -i kafka kafka-console-producer.sh --bootstrap-server kafka:9092 --topic transactions

Write-Host "Suspicious transactions sent!" -ForegroundColor Green
Write-Host "Check the fraud-alerts topic to see detected fraud cases." -ForegroundColor Yellow
