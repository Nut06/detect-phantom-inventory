import { Router } from 'express';
import { getAllDataController } from '../controllers/data.controller.js';

const router = Router();

router.get('/all', getAllDataController);

export default router;