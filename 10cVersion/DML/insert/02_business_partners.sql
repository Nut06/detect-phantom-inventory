-- ==========================================
-- 02_business_partners.sql (Suppliers & Customers)
-- ==========================================

-- 1. Supplier (10 Major Suppliers)
INSERT INTO Supplier (supplierName) VALUES ('บริษัท สหพัฒนพิบูล จำกัด (มหาชน)');
INSERT INTO Supplier (supplierName) VALUES ('บริษัท ไทยเบฟเวอเรจ จำกัด (มหาชน)');
INSERT INTO Supplier (supplierName) VALUES ('บริษัท ยูนิลีเวอร์ ไทย เทรดดิ้ง จำกัด');
INSERT INTO Supplier (supplierName) VALUES ('บริษัท เนสท์เล่ (ไทย) จำกัด');
INSERT INTO Supplier (supplierName) VALUES ('บริษัท โอสถสภา จำกัด (มหาชน)');
INSERT INTO Supplier (supplierName) VALUES ('บริษัท พรอคเตอร์ แอนด์ แกมเบิล (P&G)');
INSERT INTO Supplier (supplierName) VALUES ('บริษัท สิงห์ คอร์เปอเรชั่น จำกัด');
INSERT INTO Supplier (supplierName) VALUES ('บริษัท ซีพี เอฟแอนด์บี (ประเทศไทย)');
INSERT INTO Supplier (supplierName) VALUES ('บริษัท คอลเกต-ปาล์มโอลีฟ (ประเทศไทย)');
INSERT INTO Supplier (supplierName) VALUES ('บริษัท บุญรอดบริวเวอรี่ จำกัด');

-- 2. CustomerType (3 Types)
INSERT INTO CustomerType (customerTypeName, discountRate) VALUES ('Regular / ทั่วไป', 0);
INSERT INTO CustomerType (customerTypeName, discountRate) VALUES ('Member / สมาชิกหลัก', 5);
INSERT INTO CustomerType (customerTypeName, discountRate) VALUES ('Wholesale / ผู้จำหน่ายย่อย', 15);

-- 3. Customer & CustomerPhone (Generate 100 Customers using PL/SQL Block)
DECLARE
    TYPE string_array IS TABLE OF VARCHAR2(50);
    v_fnames string_array := string_array('สมชาย', 'สมหญิง', 'วิทยา', 'กมล', 'วิชัย', 'สุชาติ', 'นารี', 'อนันต์', 'อรทัย', 'ชัยยุทธ');
    v_lnames string_array := string_array('รักดี', 'ใจสู้', 'มีทรัพย์', 'ขยันยิ่ง', 'มั่งคั่ง', 'สุขศรี', 'ใจดี', 'ทองแท้', 'พูนผล', 'เจริญรัตน์');
    v_address VARCHAR2(100);
    v_type_id NUMBER;
    v_cust_id NUMBER;
    v_phone VARCHAR2(20);
BEGIN
    FOR i IN 1..100 LOOP
        -- Select random names
        v_address := 'เลขที่ ' || TRUNC(DBMS_RANDOM.VALUE(1, 999)) || ' ซอย ' || TRUNC(DBMS_RANDOM.VALUE(1, 50)) || ' ถนนสุขุมวิท';
        
        -- 60% Gen, 30% Member, 10% Wholesale
        v_type_id := CASE 
            WHEN i <= 60 THEN 1
            WHEN i <= 90 THEN 2
            ELSE 3
        END;

        INSERT INTO Customer (firstName, lastName, address, customerTypeID, createUser)
        VALUES (
            v_fnames(TRUNC(DBMS_RANDOM.VALUE(1, 11))), 
            v_lnames(TRUNC(DBMS_RANDOM.VALUE(1, 11))), 
            v_address, 
            v_type_id, 
            'sys_seed'
        ) RETURNING customerID INTO v_cust_id;

        -- Gen 1 Phone per customer
        v_phone := '08' || TRUNC(DBMS_RANDOM.VALUE(10000000, 99999999));
        INSERT INTO CustomerPhone (customerID, phoneNumber) VALUES (v_cust_id, v_phone);
        
        -- 20% have secondary phone
        IF DBMS_RANDOM.VALUE(0, 1) > 0.8 THEN
            v_phone := '09' || TRUNC(DBMS_RANDOM.VALUE(10000000, 99999999));
            INSERT INTO CustomerPhone (customerID, phoneNumber) VALUES (v_cust_id, v_phone);
        END IF;

    END LOOP;
END;
/
COMMIT;
