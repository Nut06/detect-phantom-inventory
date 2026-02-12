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
INSERT INTO CustomerType (customerTypeName, discountRate) VALUES ('สมาชิก All Member', 2);
INSERT INTO CustomerType (customerTypeName, discountRate) VALUES ('ผู้ประกอบการ/ขายส่ง', 5);

-- 6. Promotion (โปรโมชั่นหลัก)
INSERT INTO Promotion (promotionName, startDate, endDate) 
VALUES ('Welcome Summer Sale', TO_DATE('2026-03-01','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'));

-- 7. Package (รูปแบบแพ็กเกจ)
INSERT INTO Package (packageName, price) VALUES ('Standard Box', 20);
INSERT INTO Package (packageName, price) VALUES ('Bundle Set', 150);

-- Master data with foreign key table
-- 8. Province (จังหวัด - ต้องใช้ partID)
INSERT INTO Province (provinceName, partID, region) VALUES ('กรุงเทพมหานคร', 1, 'Central');
INSERT INTO Province (provinceName, partID, region) VALUES ('เชียงใหม่', 2, 'North');

-- 9. Branch (สาขา - ต้องใช้ provinceID)
INSERT INTO Branch (branchName, provinceID) VALUES ('สาขาพารากอน', 1);
INSERT INTO Branch (branchName, provinceID) VALUES ('สาขานิมมาน', 2);

-- 10. Customer (ลูกค้า - ต้องใช้ customerTypeID)
INSERT INTO Customer (firstName, lastName, address, customerTypeID) 
VALUES ('สมชาย', 'สายคอม', '123 ถ.วิภาวดี กรุงเทพฯ', 3);
INSERT INTO Customer (firstName, lastName, address, customerTypeID) 
VALUES ('สมหญิง', 'นักพัฒนา', '456 ถ.ห้วยแก้ว เชียงใหม่', 2);

-- 11. Product (สินค้า - ต้องใช้ Brand, Category, Branch, Package)
INSERT INTO Product (productName, price, cost, qty, brandID, categoryID, branchID, packageID) 
VALUES ('ROG Zephyrus G14', 55000, 48000, 10, 1, 1, 1, 1);
INSERT INTO Product (productName, price, cost, qty, brandID, categoryID, branchID, packageID) 
VALUES ('Cisco Router C9200L', 120000, 95000, 5, 2, 2, 1, 2);