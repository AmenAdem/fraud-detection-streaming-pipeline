# Real-time fraud detection (apache flink + kafka)

Purpose: a minimal setup to validate Kafka locally and simulate real-time transaction traffic using a small NestJS backend. Flink and Flink Agents are separate concerns to be integrated later.

Learn more about Flink Agents (not used here yet): https://flink.apache.org/2025/10/15/apache-flink-agents-0.1.0-release-announcement/

## Services
- Kafka (Bitnami, KRaft)
- Kafka UI: http://localhost:8080
- Producer API (NestJS): http://localhost:3000 (mock transaction generator and publisher)
- Topics created on startup: `transactions` (producer output), `fraud-alerts` (reserved for later)

## Quick start
1) Start stack
```bash
docker compose up -d
```
- kafka-tools will create topics then exit with code 0 (expected).

2) Health check
```bash
curl -s http://localhost:3000/health
```

3) Publish a single transaction
```bash
curl -s -X POST http://localhost:3000/transactions \
  -H 'Content-Type: application/json' \
  -d '{"id":"tx_1","amount":123.45,"user":"alice","timestamp":"2025-01-01T00:00:00Z"}'
```

4) Start/stop synthetic stream
```bash
# start stream at 500ms
docker compose exec -T producer curl -s -X POST http://localhost:3000/stream/start \
  -H 'Content-Type: application/json' -d '{"rateMs":500}'

# stop stream
docker compose exec -T producer curl -s -X POST http://localhost:3000/stream/stop
```

5) Verify messages in Kafka (transactions topic)
```bash
docker compose exec kafka kafka-console-consumer.sh \
  --bootstrap-server kafka:9092 \
  --topic transactions \
  --from-beginning
```

Optionally use Kafka UI at http://localhost:8080 to browse topics and messages.

## Producer API
- GET /health
- POST /transactions  -> publish single transaction
- POST /stream/start  -> body: { rateMs?: number }
- POST /stream/stop

## Configuration (producer/backend-producer/.env)
- KAFKA_BROKERS: default "kafka:9092"
- KAFKA_TOPIC: default "transactions"
- PORT: default "3000"
- STREAM_ENABLED: default "false" (auto-start streaming on boot when true)
- STREAM_RATE_MS: default "1000"

That’s it: bring up Docker, send a transaction, and confirm it lands in the `transactions` topic. Flink integration and Flink Agents will come next, separately.

## Flink Agents
We will put Apache Flink Agents to the test with this project on a real-world fraud detection example in a future iteration. For now, see the official announcement: https://flink.apache.org/2025/10/15/apache-flink-agents-0.1.0-release-announcement/
