import { Request, Response } from 'express';
import { getAllData } from '../services/data.service.js';

export const getAllDataController = async (req: Request, res: Response) => {
  try {
    const data = await getAllData();
    res.json({ status: 'success', data });
  } catch (err: any) {
    res.status(500).json({ status: 'error', message: err.message });
  }
};