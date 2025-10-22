# PowerShell script to consume fraud alerts
Write-Host "=== Monitoring Fraud Alerts ===" -ForegroundColor Green
Write-Host "Listening for fraud alerts on the fraud-alerts topic..." -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop monitoring" -ForegroundColor Cyan
Write-Host ""

docker exec -it kafka kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic fraud-alerts --from-beginning --formatter kafka.tools.DefaultMessageFormatter --property print.key=false --property print.value=true --property print.timestamp=true
