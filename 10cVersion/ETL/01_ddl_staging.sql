-- ==========================================
-- 01_ddl_staging.sql
-- Purpose: สร้างตารางพักข้อมูล (Staging Area) ที่ใช้รับข้อมูลดิบจากระบบ OLTP 
-- ตารางเหล่านี้จะไม่มีข้อจำกัด (Constraints) ซับซ้อน เพื่อให้ทำงานได้เร็วที่สุด
-- ==========================================

-- 1. ลบตารางเก่า (ถ้ามี)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE STG_RECEIPT CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE STG_PO CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE STG_INVENTORY_SNAPSHOT CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

-- 2. สร้างตาราง Staging 

-- ตารางพักข้อมูลรายการขาย (รวม Header และ Detail แล้ว)
CREATE TABLE STG_RECEIPT (
    stg_id NUMBER PRIMARY KEY,
    receiptID NUMBER,
    receiptDate DATE,
    branchID NUMBER,
    customerID NUMBER,
    productID NUMBER,
    qty NUMBER,
    sale_price NUMBER,
    etl_status VARCHAR2(20) DEFAULT 'PENDING', -- สถานะ: PENDING (รอประมวลผล), PROCESSED (นำเข้า DWH แล้ว)
    extract_date DATE DEFAULT SYSDATE
);

-- ตารางพักข้อมูลรายการรับของ (รวม Header และ Detail แล้ว)
CREATE TABLE STG_PO (
    stg_id NUMBER PRIMARY KEY,
    poID NUMBER,
    poDate DATE,
    branchID NUMBER,
    supplierID NUMBER,
    productID NUMBER,
    qty NUMBER,
    costPerUnit NUMBER,
    etl_status VARCHAR2(20) DEFAULT 'PENDING',
    extract_date DATE DEFAULT SYSDATE
);

-- ตารางพักข้อมูลสต็อกรายวัน (ใช้เพื่อเปรียบเทียบหา Phantom Inventory)
CREATE TABLE STG_INVENTORY_SNAPSHOT (
    stg_id NUMBER PRIMARY KEY,
    snapshot_date DATE DEFAULT TRUNC(SYSDATE),
    productID NUMBER,
    branchID NUMBER,
    current_oltp_qty NUMBER, -- สต็อกที่มีอยู่จริงในระบบตอนที่ดูดข้อมูลมา
    etl_status VARCHAR2(20) DEFAULT 'PENDING',
    extract_date DATE DEFAULT SYSDATE
);

-- 3. สร้าง Sequences ไว้ทำ Auto-increment ID สำหรับฝั่ง Staging
DROP SEQUENCE SEQ_STG_RECEIPT;
CREATE SEQUENCE SEQ_STG_RECEIPT START WITH 1 INCREMENT BY 1;

DROP SEQUENCE SEQ_STG_PO;
CREATE SEQUENCE SEQ_STG_PO START WITH 1 INCREMENT BY 1;

DROP SEQUENCE SEQ_STG_INV_SNAP;
CREATE SEQUENCE SEQ_STG_INV_SNAP START WITH 1 INCREMENT BY 1;

-- 4. Triggers สำหรับ Auto ID
CREATE OR REPLACE TRIGGER TRG_STG_RECEIPT_ID
BEFORE INSERT ON STG_RECEIPT
FOR EACH ROW
BEGIN
  IF :NEW.stg_id IS NULL THEN
    SELECT SEQ_STG_RECEIPT.NEXTVAL INTO :NEW.stg_id FROM dual;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_STG_PO_ID
BEFORE INSERT ON STG_PO
FOR EACH ROW
BEGIN
  IF :NEW.stg_id IS NULL THEN
    SELECT SEQ_STG_PO.NEXTVAL INTO :NEW.stg_id FROM dual;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_STG_INV_SNAP_ID
BEFORE INSERT ON STG_INVENTORY_SNAPSHOT
FOR EACH ROW
BEGIN
  IF :NEW.stg_id IS NULL THEN
    SELECT SEQ_STG_INV_SNAP.NEXTVAL INTO :NEW.stg_id FROM dual;
  END IF;
END;
/

-- PROMPT === STAGING TABLES CREATED SUCCESSFULLY ===