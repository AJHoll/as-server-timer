import { Injectable } from '@nestjs/common';
import { Client, ClientConfig } from 'pg';
import { ICallbackMessage } from './interfaces';
import { Request } from './utils/classes';
import { query } from './utils/pg/query';

export class TimerClient {
  id: string;
  token?: string;
}

const DB_CONNECT_CONFIG: ClientConfig = {
  host: process.env.DB_TIMER_HOST || 'localhost',
  port: +process.env.DB_TIMER_PORT || 5432,
  user: process.env.DB_TIMER_USER || 'timer-user',
  password: process.env.DB_TIMER_PASSWORD || 'timer-user-password',
  database: process.env.DB_TIMER_DATABASE || 'server-timer',
};

@Injectable()
export class DatabaseService {
  client: Client = new Client(DB_CONNECT_CONFIG);

  async query(req: Request[]): Promise<ICallbackMessage> {
    return query(req, this.client);
  }
}
