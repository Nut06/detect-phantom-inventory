import oracledb from 'oracledb';
import { env } from './env.config.js';

//oracledb.initOracleClient({ libDir: 'C:\\instantclient_19_30' }); //local dev
oracledb.initOracleClient({ libDir: '/opt/oracle/instantclient_19_30' });

oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

export const initPool = async () => {
  await oracledb.createPool({
    user: env.db.user,
    password: env.db.password,
    connectString: `${env.db.host}:${env.db.port}/${env.db.serviceName}`,
    poolMin: 1,
    poolMax: 4,
    poolIncrement: 1,
  });
};

export const getConnection = async () => {
  return await oracledb.getConnection();
};