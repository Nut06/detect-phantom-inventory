-- ==========================================
-- 03_etl_engine.sql
-- Purpose: PL/SQL Package (PKG_ETL_PIPELINE) 
-- โค้ดห้องเครื่องยนต์สำหรับดูดข้อมูลจาก OLTP -> STG -> DWH
-- สามารถเรียกใช้งานได้แบบ On-Demand
-- ==========================================

CREATE OR REPLACE PACKAGE PKG_ETL_PIPELINE AS
    PROCEDURE SP_EXTRACT_TO_STG;
    PROCEDURE SP_TRANSFORM_TO_DWH;
    PROCEDURE SP_RUN_FULL_ETL;
END PKG_ETL_PIPELINE;
/

CREATE OR REPLACE PACKAGE BODY PKG_ETL_PIPELINE AS

    ---------------------------------------------------------
    -- 1. ดูดข้อมูลจากระบบขายสด (OLTP) ลงตารางพัก (STG)
    ---------------------------------------------------------
    PROCEDURE SP_EXTRACT_TO_STG IS
    BEGIN
        -- 1.1 ล้างตาราง STG เดิมก่อนเสมอ (เพราะมันคือตารางพักชั่วคราว)
        EXECUTE IMMEDIATE 'TRUNCATE TABLE STG_RECEIPT';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE STG_PO';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE STG_INVENTORY_SNAPSHOT';

        -- 1.2 โหลดข้อมูล Receipts ปัจจุบัน
        INSERT INTO STG_RECEIPT (receiptID, receiptDate, branchID, customerID, productID, qty, sale_price, etl_status)
        SELECT 
            r.receiptID, 
            r.receiptDate, 
            r.branchID, 
            r.customerID, 
            rd.productID, 
            rd.qty, 
            rd.sale_price, 
            'PENDING'
        FROM Receipt r
        JOIN ReceiptDetail rd ON r.receiptID = rd.receiptID;
        
        -- 1.3 โหลดข้อมูล Purchase Orders ปัจจุบัน
        INSERT INTO STG_PO (poID, poDate, branchID, supplierID, productID, qty, costPerUnit, etl_status)
        SELECT 
            p.purchaseOrderID, 
            p.purchaseDate, 
            p.branchID, 
            p.supplierID, 
            pd.productID, 
            pd.qty, 
            pd.costPerUnit, 
            'PENDING'
        FROM PurchaseOrder p
        JOIN PurchaseOrderDetail pd ON p.purchaseOrderID = pd.purchaseOrderID;

        -- 1.4 โหลดข้อมูล Stock Snapshot สำหรับหา Phantom
        INSERT INTO STG_INVENTORY_SNAPSHOT (snapshot_date, productID, branchID, current_oltp_qty, etl_status)
        SELECT TRUNC(SYSDATE), productID, branchID, qty, 'PENDING'
        FROM Product;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('STG Extract Completed.');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error in SP_EXTRACT_TO_STG: ' || SQLERRM);
            RAISE;
    END SP_EXTRACT_TO_STG;


    ---------------------------------------------------------
    -- 2. แปลงข้อมูลจาก STG ผลักเข้า Data Warehouse แบบ Star Schema
    ---------------------------------------------------------
    PROCEDURE SP_TRANSFORM_TO_DWH IS
    BEGIN
        -- =====================================
        -- STEP A: อัปเดต Dimension Tables
        -- (ใช้ MERGE ยัดข้อมูล ถ้ามีอยู่แล้วให้ UPDATE, ถ้ายังไม่มีให้ INSERT)
        -- =====================================
        
        -- A.1 Date/Time Dimension (สร้างอัตโนมัติจากวันที่ใน STG)
        -- ดึงวันที่และเวลาไม่ซ้ำจาก STG ลง DIM_DATETIME
        MERGE INTO DIM_DATETIME d
        USING (
            SELECT 
                TO_NUMBER(TO_CHAR(dt, 'YYYYMMDDHH24MI')) as datetime_key,
                MIN(dt) as full_dt
            FROM (
                SELECT receiptDate as dt FROM STG_RECEIPT
                UNION ALL
                SELECT poDate FROM STG_PO
                UNION ALL
                SELECT snapshot_date FROM STG_INVENTORY_SNAPSHOT
            )
            GROUP BY TO_NUMBER(TO_CHAR(dt, 'YYYYMMDDHH24MI'))
        ) s
        ON (d.datetime_key = s.datetime_key)
        WHEN NOT MATCHED THEN
            INSERT (datetime_key, full_datetime, cal_year, cal_quarter, cal_month, cal_day, cal_hour, cal_minute, day_of_week)
            VALUES (
                s.datetime_key, s.full_dt, 
                TO_NUMBER(TO_CHAR(s.full_dt, 'YYYY')),
                TO_NUMBER(TO_CHAR(s.full_dt, 'Q')),
                TO_NUMBER(TO_CHAR(s.full_dt, 'MM')),
                TO_NUMBER(TO_CHAR(s.full_dt, 'DD')),
                TO_NUMBER(TO_CHAR(s.full_dt, 'HH24')),
                TO_NUMBER(TO_CHAR(s.full_dt, 'MI')),
                TO_CHAR(s.full_dt, 'DAY')
            );
            
        -- A.2 Product Dimension
        MERGE INTO DIM_PRODUCT d
        USING (
            SELECT p.productID, p.productName, c.categoryName, b.brandName, pk.packageName
            FROM Product p
            JOIN Category c ON p.categoryID = c.categoryID
            JOIN Brand b ON p.brandID = b.brandID
            JOIN Package pk ON p.packageID = pk.packageID
        ) s
        ON (d.productID = s.productID)
        WHEN MATCHED THEN
            UPDATE SET d.productName = s.productName, d.categoryName = s.categoryName, d.brandName = s.brandName
        WHEN NOT MATCHED THEN
            INSERT (product_sk, productID, productName, categoryName, brandName, packageName)
            VALUES (SEQ_DWH_SK.NEXTVAL, s.productID, s.productName, s.categoryName, s.brandName, s.packageName);

        -- A.3 Location Dimension
        MERGE INTO DIM_LOCATION d
        USING (
            SELECT b.branchID, b.branchName, p.provinceName, pa.partName
            FROM Branch b
            JOIN Province p ON b.provinceID = p.provinceID
            JOIN Part pa ON p.partID = pa.partID
        ) s
        ON (d.branchID = s.branchID)
        WHEN MATCHED THEN
            UPDATE SET d.branchName = s.branchName, d.provinceName = s.provinceName
        WHEN NOT MATCHED THEN
            INSERT (location_sk, branchID, branchName, provinceName, partName)
            VALUES (SEQ_DWH_SK.NEXTVAL, s.branchID, s.branchName, s.provinceName, s.partName);

        -- A.4 Customer Dimension
        MERGE INTO DIM_CUSTOMER d
        USING (
            SELECT c.customerID, c.firstName, c.lastName, ct.customerTypeName
            FROM Customer c
            JOIN CustomerType ct ON c.customerTypeID = ct.customerTypeID
        ) s
        ON (d.customerID = s.customerID)
        WHEN MATCHED THEN
            UPDATE SET d.firstName = s.firstName, d.lastName = s.lastName
        WHEN NOT MATCHED THEN
            INSERT (customer_sk, customerID, firstName, lastName, customerTypeName)
            VALUES (SEQ_DWH_SK.NEXTVAL, s.customerID, s.firstName, s.lastName, s.customerTypeName);

        -- A.5 Supplier Dimension
        MERGE INTO DIM_SUPPLIER d
        USING (SELECT supplierID, supplierName FROM Supplier) s
        ON (d.supplierID = s.supplierID)
        WHEN MATCHED THEN
            UPDATE SET d.supplierName = s.supplierName
        WHEN NOT MATCHED THEN
            INSERT (supplier_sk, supplierID, supplierName)
            VALUES (SEQ_DWH_SK.NEXTVAL, s.supplierID, s.supplierName);


        -- =====================================
        -- STEP B: เพิ่มข้อมูล Fact Tables
        -- (เราจะล้าง Fact เดิมที่เป็นของวันเดียวกันออกก่อน แล้วลงใหม่เพื่อความชัวร์ หรือใช้การ Insert ทับก็แล้วแต่ดีไซน์ 
        -- ในที่นี้ขอ Truncate Load เพื่อการทำซ้ำง่ายสำหรับเดโม่)
        -- =====================================
        EXECUTE IMMEDIATE 'TRUNCATE TABLE FACT_SALES';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE FACT_PURCHASE';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE FACT_PHANTOM_INVENTORY';

        -- B.1 โหลด FACT_SALES
        INSERT INTO FACT_SALES (sales_sk, product_sk, location_sk, customer_sk, datetime_key, qty_sold, sale_price, total_revenue)
        SELECT 
            SEQ_DWH_SK.NEXTVAL,
            dp.product_sk,
            dl.location_sk,
            dc.customer_sk,
            TO_NUMBER(TO_CHAR(s.receiptDate, 'YYYYMMDDHH24MI')),
            s.qty,
            s.sale_price,
            (s.qty * s.sale_price)
        FROM STG_RECEIPT s
        JOIN DIM_PRODUCT dp ON s.productID = dp.productID
        JOIN DIM_LOCATION dl ON s.branchID = dl.branchID
        JOIN DIM_CUSTOMER dc ON s.customerID = dc.customerID
        WHERE s.etl_status = 'PENDING';

        -- B.2 โหลด FACT_PURCHASE
        INSERT INTO FACT_PURCHASE (purchase_sk, product_sk, location_sk, supplier_sk, datetime_key, qty_received, cost_per_unit, total_cost)
        SELECT 
            SEQ_DWH_SK.NEXTVAL,
            dp.product_sk,
            dl.location_sk,
            ds.supplier_sk,
            TO_NUMBER(TO_CHAR(s.poDate, 'YYYYMMDDHH24MI')),
            s.qty,
            s.costPerUnit,
            (s.qty * s.costPerUnit)
        FROM STG_PO s
        JOIN DIM_PRODUCT dp ON s.productID = dp.productID
        JOIN DIM_LOCATION dl ON s.branchID = dl.branchID
        JOIN DIM_SUPPLIER ds ON s.supplierID = ds.supplierID
        WHERE s.etl_status = 'PENDING';

        -- B.3 โหลด FACT_PHANTOM_INVENTORY 
        -- คำนวณ (Stock สรุปตั้งต้น) vs (ของเข้า - ของออก)
        INSERT INTO FACT_PHANTOM_INVENTORY (phantom_sk, product_sk, location_sk, datetime_key, expected_qty, actual_system_qty, variance_qty)
        SELECT 
            SEQ_DWH_SK.NEXTVAL,
            dp.product_sk,
            dl.location_sk,
            TO_NUMBER(TO_CHAR(s.snapshot_date, 'YYYYMMDDHH24MI')),
            -- (ยอดยกมาสมมติ 0) + (ซื้อเข้าทั้งหมด) - (ขายออกทั้งหมด)
            NVL((SELECT SUM(qty) FROM STG_PO p WHERE p.productID = s.productID AND p.branchID = s.branchID), 0) - 
            NVL((SELECT SUM(qty) FROM STG_RECEIPT r WHERE r.productID = s.productID AND r.branchID = s.branchID), 0) AS expected_qty,
            s.current_oltp_qty AS actual_system_qty,
            s.current_oltp_qty - (
                NVL((SELECT SUM(qty) FROM STG_PO p WHERE p.productID = s.productID AND p.branchID = s.branchID), 0) - 
                NVL((SELECT SUM(qty) FROM STG_RECEIPT r WHERE r.productID = s.productID AND r.branchID = s.branchID), 0)
            ) AS variance_qty
        FROM STG_INVENTORY_SNAPSHOT s
        JOIN DIM_PRODUCT dp ON s.productID = dp.productID
        JOIN DIM_LOCATION dl ON s.branchID = dl.branchID;

        -- เปลี่ยนสถานะ STG เป็น PROCESSED
        UPDATE STG_RECEIPT SET etl_status = 'PROCESSED' WHERE etl_status = 'PENDING';
        UPDATE STG_PO SET etl_status = 'PROCESSED' WHERE etl_status = 'PENDING';
        UPDATE STG_INVENTORY_SNAPSHOT SET etl_status = 'PROCESSED' WHERE etl_status = 'PENDING';

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('DWH Transform and Load Completed.');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error in SP_TRANSFORM_TO_DWH: ' || SQLERRM);
            RAISE;
    END SP_TRANSFORM_TO_DWH;

    ---------------------------------------------------------
    -- 3. เรียกใช้งานทั้งกระบวนการ (Master Call)
    ---------------------------------------------------------
    PROCEDURE SP_RUN_FULL_ETL IS
    BEGIN
        SP_EXTRACT_TO_STG;
        SP_TRANSFORM_TO_DWH;
        DBMS_OUTPUT.PUT_LINE('--- FULL ETL PIPELINE EXECUTED SUCCESSFULLY ---');
    END SP_RUN_FULL_ETL;

END PKG_ETL_PIPELINE;
/
-- PROMPT === PKG_ETL_PIPELINE COMPILED SUCCESSFULLY ===
