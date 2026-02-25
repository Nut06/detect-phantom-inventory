// import { ProductData } from '@/types/product.type';
import express, { type Request, type Response} from 'express';

import { initPool } from './config/db.config.js';
import dataRouter from './routes/data.route.js';
import iotRouter from './routes/iot.route.js';

const app = express();
const PORT = 3000;


app.use('/api/data', dataRouter);
app.use('/api/iot', iotRouter);

await initPool();

app.listen(PORT, () => {
    console.log(`Server is running at ${PORT}`);
 })