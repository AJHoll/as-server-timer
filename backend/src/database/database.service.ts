import { Injectable } from '@nestjs/common';
import { Client, ClientConfig } from 'pg';
import { ICallbackMessage, ICallbackMessageStatus } from '../interfaces';
import { Request } from '../interfaces';

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
  client: Client;

  constructor() {
    this.client = new Client(DB_CONNECT_CONFIG);
    this.client.connect(() => {
      console.log('database connected', DB_CONNECT_CONFIG);
    });
  }

  chainingQuery(bindingParams: any, prevPayload: any) {
    const regexp = /\$\((.*)\)/;
    const bindings = bindingParams;
    const parentPayload = prevPayload;
    for (let key in bindings) {
      if (bindings[key]) {
        if (bindings[key].toString().match(regexp)) {
          const synKey = bindings[key].toString().match(regexp)[1];
          bindings[key] = [];
          if (parentPayload.length > 1) {
            for (let data of parentPayload) {
              bindings[key] = [...bindings[key], data[synKey]];
            }
          } else {
            bindings[key] = parentPayload[0][synKey];
          }
        }
      }
    }
    return bindings;
  }

  transpileQuery(query: any, bindingParams: any) {
    const regexp = /\$\((\w*)\)/gim;
    const queryBindKeys = (query as string).match(regexp);
    const bindingKeys = Object.keys(bindingParams);
    let transParams: any[] = [];
    let transQuery: string = query;
    if (queryBindKeys) {
      // пробегаемся по запросу с ключами
      let isNeedPush: boolean = false;
      for (let key of bindingKeys) {
        for (let queryKey of queryBindKeys) {
          if (queryKey === `$(${key})`) {
            transQuery = transQuery.replaceAll(
              queryKey,
              `$${transParams.length + 1}`,
            );
            isNeedPush = true;
          }
        }
        if (isNeedPush) {
          transParams.push(bindingParams[key]);
          isNeedPush = false;
        }
      }
    }

    // console.log({ query: transQuery, bindingParams: transParams });
    // пробегаемся по запросу и меняем наши ключи на индексы

    return { query: transQuery, bindingParams: transParams };
  }

  async query(req: Request[]): Promise<ICallbackMessage> {
    if (this.client) {
      console.log('client', this.client);
      try {
        let data: any[] = [];
        if (req[0].useTransaction) {
          console.log('use-transaction');
          try {
            await this.client.query('BEGIN');
            for (let request of req) {
              request.bindingParams = this.chainingQuery(
                request.bindingParams,
                data,
              );
              const transQuery = this.transpileQuery(
                request.operation.query,
                request.bindingParams,
              );
              const unitData = await this.client.query(
                transQuery.query,
                transQuery.bindingParams,
              );
              data = [...data, ...unitData.rows];
            }
            await this.client.query('COMMIT');
          } catch (err) {
            try {
              await this.client.query('ROLLBACK');
            } catch (err) {
              console.error(err);
            }
            console.error(err);
            return { status: ICallbackMessageStatus.QueryError, error: err };
          }
        } else {
          console.log('not_use_transaction');
          for (let request of req) {
            request.bindingParams = this.chainingQuery(
              request.bindingParams,
              data,
            );
            const transQuery = this.transpileQuery(
              request.operation.query,
              request.bindingParams,
            );
            try {
              const queryRes = this.client.query(
                transQuery.query,
                transQuery.bindingParams,
              );

              console.log(await queryRes);
              data = [...data, (await queryRes).rows];
            } catch (err) {
              console.error(err);
              throw err;
            }
          }
        }
        console.log(data);
        return { status: ICallbackMessageStatus.Done, data: data };
      } catch (err) {
        return { status: ICallbackMessageStatus.QueryError, error: err };
      }
    }
    return {
      status: ICallbackMessageStatus.PoolError,
      error: 'Не удалось получить объект клиента!',
    };
  }
}
