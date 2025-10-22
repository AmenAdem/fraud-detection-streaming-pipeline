import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import {TransactionsController} from "./controllers/transactions.controller";
import {KafkaService} from "./services/kafka.service";

@Module({
  imports: [],
  controllers: [AppController,TransactionsController],
  providers: [AppService,KafkaService],
})
export class AppModule {}
