import fs from 'fs';
import path from 'path';
import csv from 'csv-parser';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export interface IotTemp {
  id: string;
  room_id: string;
  noted_date: string;
  temp: number;
  location: string;
}

export const getIotTemperature = (): Promise<IotTemp[]> => {
  return new Promise((resolve, reject) => {
    const results: IotTemp[] = [];
    const csvPath = path.join(__dirname, '../../mock/IOT-temp.csv');

    fs.createReadStream(csvPath)
      .pipe(csv())
      .on('data', (row: any) => {
        results.push({
          id: row['id'],
          room_id: row['room_id/id'],
          noted_date: row['noted_date'],
          temp: parseFloat(row['temp']),
          location: row['out/in'],
        });
      })
      .on('end', () => resolve(results))
      .on('error', (err) => reject(err));
  });
};