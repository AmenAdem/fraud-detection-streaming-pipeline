import 'dotenv/config';
import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';
import { KafkaService } from './services/kafka.service';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { logger: ['log', 'error', 'warn'] });
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));

  const kafka = app.get(KafkaService);
  await kafka.init();

  const streamEnabled = (process.env.STREAM_ENABLED || '').toLowerCase() === 'true';
  const rateMs = Number.parseInt(process.env.STREAM_RATE_MS || '1000', 10);
  if (streamEnabled) {
    kafka.startStream(rateMs);
  }

  const port = process.env.PORT ? Number(process.env.PORT) : 3000;
  await app.listen(port, '0.0.0.0');
  console.log(`Producer service listening on http://0.0.0.0:${port}`);
}

bootstrap().catch((err) => {
  console.error('Fatal error on bootstrap', err);
  process.exit(1);
});
