-- ==========================================
-- 04_products.sql (Mass Product Catalog)
-- ==========================================

DECLARE
    TYPE string_array IS TABLE OF VARCHAR2(100);
    v_basenames string_array := string_array(
        'บะหมี่กึ่งสำเร็จรูป รสต้มยำกุ้ง', 'บะหมี่กึ่งสำเร็จรูป รสหมูสับ', 'น้ำดื่ม ตราสิงห์', 'น้ำดื่ม ตราช้าง',
        'นมสดรสจืด', 'นมช็อคโกแลต', 'ครีมอาบน้ำสูตรเย็น', 'แชมพูขจัดรังแค', 'ผงซักฟอกสูตรเข้มข้น', 'น้ำยาปรับผ้านุ่ม',
        'มันฝรั่งทอดกรอบ รสออริจินัล', 'มันฝรั่งทอดกรอบ รสบาร์บีคิว', 'น้ำอัดลม รสโคล่า', 'น้ำอัดลม รสส้ม',
        'กาแฟสำเร็จรูป 3in1', 'กาแฟคั่วบด', 'ยาสีฟันสูตรเกลือ', 'แปรงสีฟันขนอ่อน', 'เนื้อไก่แช่แข็ง', 'เนื้อหมูสไลด์',
        'เบเกอรี่ ขนมปังแถว', 'เค้กช็อคโกแลต', 'ชาเขียว รสต้นตำรับ', 'ชาเขียว รสข้าวญี่ปุ่น', 'เบียร์กระป๋อง'
    );
    
    v_brand_id NUMBER;
    v_cat_id NUMBER;
    v_branch_id NUMBER;
    v_pkg_id NUMBER;
    v_cost NUMBER;
    v_price NUMBER;
    v_qty NUMBER;
    v_name VARCHAR2(200);
BEGIN
    -- We want to generate products for multiple branches so each branch has an inventory
    -- 15 Branches * 25 Base Products = 375 Product records total
    
    FOR b_id IN 1..15 LOOP
        FOR p_idx IN 1..v_basenames.COUNT LOOP
            v_name := v_basenames(p_idx);
            
            -- Assign realistic category and brand based on index to look nice, or just random
            v_cat_id := TRUNC(DBMS_RANDOM.VALUE(1, 11));
            v_brand_id := TRUNC(DBMS_RANDOM.VALUE(1, 21));
            v_pkg_id := TRUNC(DBMS_RANDOM.VALUE(1, 5));
            
            -- Random Cost from 10 to 500
            v_cost := TRUNC(DBMS_RANDOM.VALUE(10, 500));
            -- Markup 20% - 50%
            v_price := v_cost * DBMS_RANDOM.VALUE(1.2, 1.5);
            -- Initial qty is 0. We will fill it via POs in the next script!
            v_qty := 0; 
            
            INSERT INTO Product (productName, price, cost, qty, brandID, categoryID, branchID, packageID, createUser)
            VALUES (
                v_name || ' (Branch '|| b_id ||')',
                v_price,
                v_cost,
                v_qty,
                v_brand_id,
                v_cat_id,
                b_id,
                v_pkg_id,
                'sys_seed'
            );
        END LOOP;
    END LOOP;
END;
/
COMMIT;
