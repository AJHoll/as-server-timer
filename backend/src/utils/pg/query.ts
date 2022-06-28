import { Client } from 'pg';
import { ICallbackMessage, ICallbackMessageStatus } from '../../interfaces';
import { Request } from '../classes';

const chainingQuery = (bindingParams: any, prevPayload: any) => {
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
};
//q: select cmn_doc.doc_type__find_by_name($(name)) as idDocType { name: 'stk_doc_in' }
const transpileQuery = (query: any, bindingParams: any) => {
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
};

const query = async (
  req: Request[],
  client: Client,
): Promise<ICallbackMessage> => {
  if (client) {
    try {
      let data: any[] = [];
      if (req[0].useTransaction) {
        try {
          await client.query('BEGIN');
          for (let request of req) {
            request.bindingParams = chainingQuery(request.bindingParams, data);
            const transQuery = transpileQuery(
              request.operation.query,
              request.bindingParams,
            );
            const unitData = await client.query(
              transQuery.query,
              transQuery.bindingParams,
            );
            data = [...data, ...unitData.rows];
          }
          await client.query('COMMIT');
        } catch (err) {
          try {
            await client.query('ROLLBACK');
          } catch (err) {
            console.error(err);
          }
          console.error(err);
          return { status: ICallbackMessageStatus.QueryError, error: err };
        }
      } else {
        for (let request of req) {
          request.bindingParams = chainingQuery(request.bindingParams, data);
          const transQuery = transpileQuery(
            request.operation.query,
            request.bindingParams,
          );
          const unitData = await client.query(
            transQuery.query,
            transQuery.bindingParams,
          );
          data = [...data, ...unitData.rows];
        }
      }
      return { status: ICallbackMessageStatus.Done, data: data };
    } catch (err) {
      return { status: ICallbackMessageStatus.QueryError, error: err };
    }
  }
  return {
    status: ICallbackMessageStatus.PoolError,
    error: 'Не удалось получить объект клиента!',
  };
};

export { query };
