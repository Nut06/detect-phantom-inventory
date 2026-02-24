import oracledb from 'oracledb';
import { env } from './env.config.js';

export const getConnection = async () => {
  const connection = await oracledb.getConnection({
    user: env.db.user,
    password: env.db.password,
    connectString: `${env.db.host}:${env.db.port}/${env.db.serviceName}`
  });
  return connection;
};