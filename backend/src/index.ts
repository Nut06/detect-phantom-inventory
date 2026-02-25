// import { ProductData } from '@/types/product.type';
import express, { type Request, type Response} from 'express';
import fs from 'fs';
import path from 'path';
import csv from 'csv-parser';
// import { ProductData } from './types/product.type.js';
import { initPool } from './config/db.config.js';
import dataRouter from './routes/data.route.js';

const app = express();
const PORT = 3000;

//  app.get('/api/data', (req: Request, res:Response) => {
//     const results: ProductData [] = [];
//     const csvFilePath = path.join(__dirname, '../mock/data.csv');

//     fs.createReadStream(csvFilePath)
//     .pipe(csv())
//     .on('data', (data: ProductData) => results.push(data))
//     .on('end', () => {
//       res.json({
//         status: 'success',
//         count: results.length,
//         data: results
//       });
//     })
//     .on('error', (err: any) => {
//       res.status(500).json({ status: 'error', message: err.message });
//     });
//  });

app.use('/api/data', dataRouter);
await initPool();

app.listen(PORT, () => {
    console.log(`Server is running at ${PORT}`);
 })