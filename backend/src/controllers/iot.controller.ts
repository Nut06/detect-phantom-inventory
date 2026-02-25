import { Request, Response } from 'express';
import { getIotTemperature } from '../services/iot.service.js';

export const getTemperature = async (req: Request, res: Response) => {
  try {
    const data = await getIotTemperature();
    res.json(data);
  } catch (err: any) {
    res.status(500).json({ status: 'error', message: err.message });
  }
};