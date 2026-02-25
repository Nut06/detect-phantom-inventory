-- ==========================================
-- 06_generate_phantom_inventory.sql
-- Purpose: สร้างข้อมูล "สต็อกผี" แบบจงใจ (เพื่อทดสอบ ETL Dashboard)
-- โดยปกติระบบจะทำงานถูกต้องเป๊ะ ทำให้ไม่มีส่วนต่าง
-- สคริปต์นี้จะแอบไป "แฮ็ก" ตัวเลขหน้าจอให้ไม่ตรงกับบิลซื้อ/ขาย
-- ==========================================

DECLARE
    v_stolen_count NUMBER := 0;
    v_found_count NUMBER := 0;
BEGIN
    -- โจรขโมยของ Case 1: แอบหยิบสินค้า ID 1 ถึง 10 ออกไปอย่างละ 5 ชิ้น (สต็อกลบ แต่ไม่มีบิล)
    UPDATE Product 
    SET qty = qty - 5,
        updateAt = SYSDATE - TRUNC(DBMS_RANDOM.VALUE(0, 90)),
        updateUser = 'THIEF_SIMULATOR'
    WHERE productID IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) AND qty >= 5;
    
    v_stolen_count := SQL%ROWCOUNT;
    
    -- ของเกิน Case 2: นับสต็อกแล้วเจอของโผล่มาจากไหนไม่รู้อย่างละ 2 ชิ้น ในสินค้า ID 11 ถึง 15 (สต็อกบวก แต่ไม่มี PO)
    UPDATE Product 
    SET qty = qty + 2,
        updateAt = SYSDATE - TRUNC(DBMS_RANDOM.VALUE(0, 90)),
        updateUser = 'MAGIC_BOX_SIMULATOR'
    WHERE productID IN (11, 12, 13, 14, 15);
    
    v_found_count := SQL%ROWCOUNT;
    
    -- โจรขโมยของ Case 3: แรนดอมขโมยของชิ้นละ 1-10 อันกระจายๆ ไปอีก 10 รายการ
    FOR i IN 1..10 LOOP
        UPDATE Product
        SET qty = GREATEST(qty - TRUNC(DBMS_RANDOM.VALUE(1, 10)), 0),
            updateAt = SYSDATE - TRUNC(DBMS_RANDOM.VALUE(0, 90)),
            updateUser = 'RANDOM_THIEF_SIMULATOR'
        WHERE productID = (SELECT productID FROM (SELECT productID FROM Product ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1);
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- Phantom Inventory Simulation Completed! ---');
    DBMS_OUTPUT.PUT_LINE('>> Stolen exactly 5 units from ' || v_stolen_count || ' products.');
    DBMS_OUTPUT.PUT_LINE('>> Magically found 2 units in ' || v_found_count || ' products.');
    DBMS_OUTPUT.PUT_LINE('>> Randomly adjusted 10 more products.');
    DBMS_OUTPUT.PUT_LINE('Now run: EXEC PKG_ETL_PIPELINE.SP_RUN_FULL_ETL; to catch them in the Data Warehouse!');
END;
/
