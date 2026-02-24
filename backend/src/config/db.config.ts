import oracledb from 'oracledb';
import { env } from './env.config.js';

oracledb.initOracleClient({ libDir: 'C:\\instantclient_19_30' });
oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

export const getConnection = async () => {
  const connection = await oracledb.getConnection({
    user: env.db.user,
    password: env.db.password,
    connectString: `${env.db.host}:${env.db.port}/${env.db.serviceName}`
  });
  return connection;
};