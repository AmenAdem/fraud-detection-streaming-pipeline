import { IsNumber, IsOptional, IsString, IsISO8601, IsObject } from 'class-validator';

export class TransactionDto {
  @IsOptional()
  @IsString()
  id?: string;

  @IsNumber()
  amount!: number;

  @IsString()
  user!: string;

  @IsOptional()
  @IsISO8601()
  timestamp?: string;

  @IsOptional()
  @IsObject()
  extra?: Record<string, any>;
}

