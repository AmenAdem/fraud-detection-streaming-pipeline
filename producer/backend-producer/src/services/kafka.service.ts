import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { Kafka, Producer } from 'kafkajs';
import { randomTransaction } from '../utils/random';

@Injectable()
export class KafkaService implements OnModuleDestroy {
  private kafka?: Kafka;
  private producer?: Producer;
  private streamTimer?: NodeJS.Timeout;
  private topic = process.env.KAFKA_TOPIC || 'transactions';
  private brokers = (process.env.KAFKA_BROKERS || 'kafka:9092').split(',');

  async init() {
    if (this.kafka && this.producer) return;
    this.kafka = new Kafka({ brokers: this.brokers, clientId: 'fraud-producer' });
    this.producer = this.kafka.producer();
    await this.producer.connect();
    console.log(`Connected to Kafka brokers: ${this.brokers.join(', ')}, topic: ${this.topic}`);
  }

  async sendTransaction(tx: Record<string, any>) {
    const message = JSON.stringify(tx);
    if (!this.producer) throw new Error('Producer not initialized');
    await this.producer.send({ topic: this.topic, messages: [{ value: message }] });
  }

  startStream(rateMs = 1000) {
    if (this.streamTimer) return; // already streaming
    console.log(`Starting transaction stream at ${rateMs} ms interval`);
    this.streamTimer = setInterval(async () => {
      try {
        const tx = randomTransaction();
        await this.sendTransaction(tx);
      } catch (err) {
        console.error('Stream send error', err);
      }
    }, Math.max(200, rateMs));
  }

  stopStream() {
    if (this.streamTimer) {
      clearInterval(this.streamTimer);
      this.streamTimer = undefined;
      console.log('Stopped transaction stream');
    }
  }

  async onModuleDestroy() {
    this.stopStream();
    if (this.producer) {
      await this.producer.disconnect();
    }
  }
}

