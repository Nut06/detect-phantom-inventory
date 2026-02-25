import { Router } from 'express';
import { getTemperature } from '../controllers/iot.controller.js';

const router = Router();

router.get('/temperature', getTemperature);

export default router;