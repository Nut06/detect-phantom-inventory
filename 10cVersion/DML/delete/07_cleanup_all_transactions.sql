-- ==========================================
-- 07_cleanup_all_transactions.sql
-- Purpose: ล้างข้อมูลกระแสรายวันทั้งหมด (Transactions & ETL Data)
-- เพื่อรีเซ็ตระบบให้กลับไปเหลือแค่ Master Data พร้อมเริ่มรันเทสใหม่
-- (ไม่ลบข้อมูลหลักอย่าง Product, Location, Customer)
-- ==========================================

BEGIN
    -- 1. ล้างข้อมูลฝั่ง Data Warehouse (Fact Tables)
    -- ใช้ DELETE แทน TRUNCATE เพื่อป้องกันปัญหา Foreign Key (ถ้ามี)
    EXECUTE IMMEDIATE 'DELETE FROM FACT_SALES';
    EXECUTE IMMEDIATE 'DELETE FROM FACT_PURCHASE';
    EXECUTE IMMEDIATE 'DELETE FROM FACT_PHANTOM_INVENTORY';
    -- DBMS_OUTPUT.PUT_LINE('>> Cleared Data Warehouse (FACT tables)');

    -- 2. ล้างข้อมูลฝั่ง Staging Area
    EXECUTE IMMEDIATE 'TRUNCATE TABLE STG_RECEIPT';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE STG_PO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE STG_INVENTORY_SNAPSHOT';
    -- DBMS_OUTPUT.PUT_LINE('>> Cleared Staging Area (STG tables)');

    -- 3. ล้างระเบียนข้อมูล (Logs and Junction tables if necessary for transactions)
    -- ในสคริปต์นี้เราไม่ยุ่งกับ Master data นะครับ ลบเฉพาะเอกสาร

    -- 4. ล้างข้อมูลฝั่ง OLTP (ใบเสร็จ และ ใบสั่งซื้อ)
    EXECUTE IMMEDIATE 'DELETE FROM ReceiptDetail';
    EXECUTE IMMEDIATE 'DELETE FROM Receipt';
    EXECUTE IMMEDIATE 'DELETE FROM PurchaseOrderDetail';
    EXECUTE IMMEDIATE 'DELETE FROM PurchaseOrder';
    -- DBMS_OUTPUT.PUT_LINE('>> Cleared OLTP Transactions (Receipts and POs)');

    -- 5. รีเซ็ตสต็อกสินค้าในตาราง Product กลับเป็น 0 ให้หมด
    -- และลบ cost กลับเป็น 0 เพื่อเริ่มใหม่สะอาดๆ
    UPDATE Product 
    SET qty = 0, 
        cost = 0,
        updateAt = SYSDATE,
        updateUser = 'SYSTEM_CLEANUP';
    -- DBMS_OUTPUT.PUT_LINE('>> Reset ALL Product Quantities to 0');

    -- กดยืนยันการเคลียร์ข้อมูล
    COMMIT;
    -- DBMS_OUTPUT.PUT_LINE('--- ALL TRANSACTION AND ETL DATA CLEARED SUCCESSFULLY ---');
    -- DBMS_OUTPUT.PUT_LINE('Ready to run 05_generate_transactions.sql again!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error during cleanup: ' || SQLERRM);
        RAISE;
END;
/
