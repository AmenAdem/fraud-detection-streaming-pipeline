import { Body, Controller, Get, Post } from '@nestjs/common';
import { KafkaService } from '../services/kafka.service';
import { TransactionDto } from '../models/transactions.dto';

@Controller()
export class TransactionsController {
  constructor(private readonly kafka: KafkaService) {}

  @Get('health')
  health() {
    return { status: 'ok' };
  }

  @Post('transactions')
  async publish(@Body() dto: TransactionDto) {
    const tx = {
      id: dto.id ?? `tx_${Date.now()}`,
      amount: dto.amount,
      user: dto.user,
      timestamp: dto.timestamp ?? new Date().toISOString(),
      ...dto.extra,
    };
    await this.kafka.sendTransaction(tx);
    return { ok: true, published: tx };
  }

  @Post('stream/start')
  startStream(@Body() body: { rateMs?: number } = {}) {
    const rate = typeof body.rateMs === 'number' ? body.rateMs : Number.parseInt(process.env.STREAM_RATE_MS || '1000', 10);
    this.kafka.startStream(rate);
    return { ok: true, rateMs: rate };
  }

  @Post('stream/stop')
  stopStream() {
    this.kafka.stopStream();
    return { ok: true };
  }
}
