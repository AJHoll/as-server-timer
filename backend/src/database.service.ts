import { Injectable } from '@nestjs/common';
import { promises as fs } from 'fs';
import * as path from 'path';

export class TimerClient {
  id: string;
  token?: string;
}

const FILE_ENCODING_CFG = 'utf-8';

@Injectable()
export class DatabaseService {
  async getData<T>(dataSource: string) {
    const dataPath = path.resolve(process.env.DB_PATH, dataSource);
    const dataFileNames: string[] = await fs.readdir(dataPath);
    const data = [];
    for (let fileName of dataFileNames) {
      const filePath = path.resolve(dataPath, fileName);
      data.push(
        JSON.parse(
          await fs.readFile(filePath, { encoding: FILE_ENCODING_CFG }),
        ),
      );
    }
    return data as T[];
  }

  async setData(dataSource: string, fileName: string, newData: any) {
    const filePath = path.resolve(process.env.DB_PATH, dataSource, fileName);
    await fs.writeFile(filePath, JSON.stringify(newData), {
      encoding: FILE_ENCODING_CFG,
    });
  }
}
