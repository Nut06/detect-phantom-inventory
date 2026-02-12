-- Master table No foreign key table
-- 1. Part (ภาค)
INSERT INTO Part (partName) VALUES ('ภาคกลาง');
INSERT INTO Part (partName) VALUES ('ภาคเหนือ');
INSERT INTO Part (partName) VALUES ('ภาคใต้');

-- 2. Supplier (ซัพพลายเออร์รายใหญ่)
INSERT INTO Supplier (supplierName) VALUES ('สหพัฒนพิบูล (Mama, Pao)');
INSERT INTO Supplier (supplierName) VALUES ('ไทยเบฟเวอเรจ (Chang, Oishi)');
INSERT INTO Supplier (supplierName) VALUES ('ยูนิลีเวอร์ (Dove, Sunsilk)');

-- 3. Category (หมวดหมู่สินค้าในห้าง)
INSERT INTO Category (categoryName) VALUES ('อาหารแห้งและบะหมี่กึ่งสำเร็จรูป');
INSERT INTO Category (categoryName) VALUES ('เครื่องดื่มและน้ำดื่ม');
INSERT INTO Category (categoryName) VALUES ('ของใช้ส่วนตัวและเครื่องสำอาง');

-- 4. Brand (แบรนด์ยอดนิยม)
INSERT INTO Brand (brandName, discountRate) VALUES ('มาม่า (Mama)', 0);
INSERT INTO Brand (brandName, discountRate) VALUES ('สิงห์ (Singha)', 1);
INSERT INTO Brand (brandName, discountRate) VALUES ('เลย์ (Lay''s)', 0);

-- 5. CustomerType (ประเภทสมาชิก)
INSERT INTO CustomerType (customerTypeName, discountRate) VALUES ('ลูกค้าทั่วไป', 0);
INSERT INTO CustomerType (customerTypeName, discountRate) VALUES ('สมาชิก', 2);
INSERT INTO CustomerType (customerTypeName, discountRate) VALUES ('ผู้ประกอบการ/ขายส่ง', 5);

-- 6. Promotion (โปรโมชั่นหลัก)
INSERT INTO Promotion (promotionName, startDate, endDate) 
VALUES ('Welcome Summer Sale', TO_DATE('2026-03-01','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'));

-- 7. Package (รูปแบบแพ็กเกจ)
INSERT INTO Package (packageName, price) VALUES ('Standard Box', 20);
INSERT INTO Package (packageName, price) VALUES ('Bundle Set', 150);

-- Master data with foreign key table
-- 7. Province (จังหวัด - ไม่มีคอลัมน์ region แล้ว)
-- สมมติภาคกลาง ID=1, ภาคตะวันออก ID=2
INSERT INTO Province (provinceName, partID, createUser) VALUES ('กรุงเทพมหานคร', 1, 'system_admin');
INSERT INTO Province (provinceName, partID, createUser) VALUES ('ชลบุรี', 2, 'system_admin');

-- 8. Branch (สาขา)
-- สมมติ กทม ID=1, ชลบุรี ID=2
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('Lotus''s Go Fresh สุขุมวิท', 1, 'manager_01');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('7-Eleven สาขาหน้าหาดบางแสน', 2, 'manager_02');

-- 9. Customer (ลูกค้า)
-- สมมติสมาชิกทั่วไป ID=1, All Member ID=2
INSERT INTO Customer (firstName, lastName, address, customerTypeID, createUser) 
VALUES ('กมล', 'ใจดี', '123/4 เขตวัฒนา กทม.', 2, 'pos_01');
INSERT INTO Customer (firstName, lastName, address, customerTypeID, createUser) 
VALUES ('วิชัย', 'ขยันเรียน', '55 ม.2 ต.แสนสุข จ.ชลบุรี', 1, 'pos_01');

-- 10. CustomerPhone (เบอร์โทรศัพท์ - Weak Entity)
INSERT INTO CustomerPhone (customerID, phoneNumber) VALUES (1, '0812345678');
INSERT INTO CustomerPhone (customerID, phoneNumber) VALUES (1, '029998888');
INSERT INTO CustomerPhone (customerID, phoneNumber) VALUES (2, '0890001111');

-- 11. Product (สินค้า)
-- ค่า ID อ้างอิงตามลำดับการ Insert ด้านบน
-- Product 1: มาม่าคัพ (Brand=1, Cat=1, Branch=1, Pkg=1)
INSERT INTO Product (productName, price, cost, qty, brandID, categoryID, branchID, packageID, createUser) 
VALUES ('มาม่าคัพ รสหมูสับ 60ก.', 15.00, 11.50, 200, 1, 1, 1, 1, 'inventory_mgr');

-- Product 2: น้ำดื่มสิงห์ (Brand=2, Cat=2, Branch=1, Pkg=1)
INSERT INTO Product (productName, price, cost, qty, brandID, categoryID, branchID, packageID, createUser) 
VALUES ('น้ำดื่มสิงห์ 600มล.', 7.00, 4.25, 500, 2, 2, 1, 1, 'inventory_mgr');