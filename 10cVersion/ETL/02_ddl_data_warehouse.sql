-- ==========================================
-- 02_ddl_data_warehouse.sql
-- Purpose: สร้าง Data Warehouse แบบ Star Schema (ยุบรวมตาราง)
-- เพื่อให้ Power BI สามารถดึงข้อมูลไปแสดงผลได้อย่างรวดเร็ว
-- ==========================================

-- 1. DROP TABLES (เพื่อรันซ้ำได้)
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FACT_SALES CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FACT_PURCHASE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FACT_PHANTOM_INVENTORY CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DIM_PRODUCT CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DIM_LOCATION CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DIM_CUSTOMER CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DIM_SUPPLIER CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DIM_DATETIME CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- 2. CREATE DIMENSION TABLES (ตารางมิติคำอธิบาย)
-- ใช้ Surrogate Key (SK) เป็น Primary Key เพื่อประสิทธิภาพสูงสุด

CREATE TABLE DIM_PRODUCT (
    product_sk NUMBER PRIMARY KEY, -- SK
    productID NUMBER,              -- Business Key จากระบบ OLTP
    productName VARCHAR2(100),
    categoryName VARCHAR2(100),
    brandName VARCHAR2(100),
    packageName VARCHAR2(100)
);

CREATE TABLE DIM_LOCATION (
    location_sk NUMBER PRIMARY KEY,
    branchID NUMBER,
    branchName VARCHAR2(100),
    provinceName VARCHAR2(100),
    partName VARCHAR2(100)
);

CREATE TABLE DIM_CUSTOMER (
    customer_sk NUMBER PRIMARY KEY,
    customerID NUMBER,
    firstName VARCHAR2(50),
    lastName VARCHAR2(50),
    customerTypeName VARCHAR2(50)
);

CREATE TABLE DIM_SUPPLIER (
    supplier_sk NUMBER PRIMARY KEY,
    supplierID NUMBER,
    supplierName VARCHAR2(100)
);

CREATE TABLE DIM_DATETIME (
    datetime_key NUMBER PRIMARY KEY, -- รูปแบบ YYYYMMDDHH24MI เช่น 202602251030
    full_datetime DATE,
    cal_year NUMBER,
    cal_quarter NUMBER,
    cal_month NUMBER,
    cal_day NUMBER,
    cal_hour NUMBER,
    cal_minute NUMBER,
    day_of_week VARCHAR2(20)
);


-- 3. CREATE FACT TABLES (ตารางตัวเลข)

CREATE TABLE FACT_SALES (
    sales_sk NUMBER PRIMARY KEY,
    product_sk NUMBER REFERENCES DIM_PRODUCT(product_sk),
    location_sk NUMBER REFERENCES DIM_LOCATION(location_sk),
    customer_sk NUMBER REFERENCES DIM_CUSTOMER(customer_sk),
    datetime_key NUMBER REFERENCES DIM_DATETIME(datetime_key),
    qty_sold NUMBER,
    sale_price NUMBER,
    total_revenue NUMBER, -- คำนวณมาจาก qty * price ล่วงหน้า
    etl_timestamp DATE DEFAULT SYSDATE
);

CREATE TABLE FACT_PURCHASE (
    purchase_sk NUMBER PRIMARY KEY,
    product_sk NUMBER REFERENCES DIM_PRODUCT(product_sk),
    location_sk NUMBER REFERENCES DIM_LOCATION(location_sk),
    supplier_sk NUMBER REFERENCES DIM_SUPPLIER(supplier_sk),
    datetime_key NUMBER REFERENCES DIM_DATETIME(datetime_key),
    qty_received NUMBER,
    cost_per_unit NUMBER,
    total_cost NUMBER,
    etl_timestamp DATE DEFAULT SYSDATE
);

-- ตารางคีย์แมนสำหรับวิเคราะห์ว่าสต็อกหายไปไหน
CREATE TABLE FACT_PHANTOM_INVENTORY (
    phantom_sk NUMBER PRIMARY KEY,
    product_sk NUMBER REFERENCES DIM_PRODUCT(product_sk),
    location_sk NUMBER REFERENCES DIM_LOCATION(location_sk),
    datetime_key NUMBER REFERENCES DIM_DATETIME(datetime_key),
    expected_qty NUMBER, -- ยอดที่ควรจะเป็น (ซื้อเข้า - ขายออก)
    actual_system_qty NUMBER, -- ยอดคงเหลือในตาราง STG_SNAPSHOT
    variance_qty NUMBER, -- ส่วนต่าง (actual - expected) ถ้าติดลบ = ของหาย!,
    etl_timestamp DATE DEFAULT SYSDATE
);

-- 4. SEQUENCES
DROP SEQUENCE SEQ_DWH_SK;
CREATE SEQUENCE SEQ_DWH_SK START WITH 1 INCREMENT BY 1;
-- (เราจะใช้ Sequence เดียวนี่แหละ จ่ายเลขรันยาวๆ ให้ SK เวลา Insert ด้วยมือผ่าน PL/SQL เพื่อความสะดวก)

-- PROMPT === DATA WAREHOUSE (STAR SCHEMA) CREATED SUCCESSFULLY ===
