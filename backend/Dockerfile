FROM node:22-slim

# dependencies for Oracle Instant Client
RUN apt-get update && apt-get install -y \
    libaio1 \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Oracle Instant Client installation ลองเทสแล้ว 19.30 ใช้กับของอาจารย์ได้ 
RUN mkdir -p /opt/oracle && \
    cd /opt/oracle && \
    wget https://github.com/Nut06/detect-phantom-inventory/releases/download/v1.0.0/instantclient-basic-linux.x64-19.30.0.0.0dbru.zip && \
    unzip instantclient-basic-linux.x64-19.30.0.0.0dbru.zip && \
    rm instantclient-basic-linux.x64-19.30.0.0.0dbru.zip && \
    echo /opt/oracle/instantclient_19_30 > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

WORKDIR /app

COPY package*.json ./
RUN npm install 

COPY . .
RUN npx tsc

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_19_30

EXPOSE 3000

CMD ["node", "dist/index.js"]