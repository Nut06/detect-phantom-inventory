-- ==========================================

-- 03_product_categories.sql (Categories, Brands, Promos, Packages)
-- ==========================================

-- 1. Category (10 Categories)
INSERT INTO Category (categoryName) VALUES ('อาหารสำเร็จรูปและเครื่องปรุง');
INSERT INTO Category (categoryName) VALUES ('เครื่องดื่มไม่มีแอลกอฮอล์');
INSERT INTO Category (categoryName) VALUES ('เครื่องดื่มแอลกอฮอล์');
INSERT INTO Category (categoryName) VALUES ('ขนมขบเคี้ยว');
INSERT INTO Category (categoryName) VALUES ('ผลิตภัณฑ์ดูแลร่างกาย');
INSERT INTO Category (categoryName) VALUES ('ผลิตภัณฑ์ซักล้างทำความสะอาด');
INSERT INTO Category (categoryName) VALUES ('ของใช้ในครัวเรือน (พลาสติก/อื่นๆ)');
INSERT INTO Category (categoryName) VALUES ('อาหารสดและอาหารแช่แข็ง');
INSERT INTO Category (categoryName) VALUES ('นมและผลิตภัณฑ์จากนม');
INSERT INTO Category (categoryName) VALUES ('เบเกอรี่และของหวาน');

-- 2. Brand (20 Brands)
INSERT INTO Brand (brandName, discountRate) VALUES ('มาม่า (Mama)', 0);
INSERT INTO Brand (brandName, discountRate) VALUES ('เลย์ (Lay''s)', 0);
INSERT INTO Brand (brandName, discountRate) VALUES ('โค้ก (Coca-Cola)', 2);
INSERT INTO Brand (brandName, discountRate) VALUES ('เป๊ปซี่ (Pepsi)', 2);
INSERT INTO Brand (brandName, discountRate) VALUES ('สิงห์ (Singha)', 1);
INSERT INTO Brand (brandName, discountRate) VALUES ('ช้าง (Chang)', 1);
INSERT INTO Brand (brandName, discountRate) VALUES ('เนสกาแฟ (Nescafe)', 0);
INSERT INTO Brand (brandName, discountRate) VALUES ('ซันซิล (Sunsilk)', 5);
INSERT INTO Brand (brandName, discountRate) VALUES ('โอโม (Omo)', 5);
INSERT INTO Brand (brandName, discountRate) VALUES ('คอลเกต (Colgate)', 0);
INSERT INTO Brand (brandName, discountRate) VALUES ('ซีพี (CP)', 0);
INSERT INTO Brand (brandName, discountRate) VALUES ('ดัชมิลล์ (Dutch Mill)', 3);
INSERT INTO Brand (brandName, discountRate) VALUES ('โฟร์โมสต์ (Foremost)', 0);
INSERT INTO Brand (brandName, discountRate) VALUES ('ไวไว (Wai Wai)', 0);
INSERT INTO Brand (brandName, discountRate) VALUES ('เถ้าแก่น้อย (Tao Kae Noi)', 0);
INSERT INTO Brand (brandName, discountRate) VALUES ('โออิชิ (Oishi)', 2);
INSERT INTO Brand (brandName, discountRate) VALUES ('แพนทีน (Pantene)', 5);
INSERT INTO Brand (brandName, discountRate) VALUES ('บรีส (Breeze)', 3);
INSERT INTO Brand (brandName, discountRate) VALUES ('ลีโอ (Leo)', 0);
INSERT INTO Brand (brandName, discountRate) VALUES ('เมจิ (Meiji)', 2);

-- 3. Promotion (4 Promos)
INSERT INTO Promotion (promotionName, startDate, endDate) VALUES ('Q1 Clear Clearance', TO_DATE('2026-01-01','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'));
INSERT INTO Promotion (promotionName, startDate, endDate) VALUES ('Summer Super Sale', TO_DATE('2026-04-01','YYYY-MM-DD'), TO_DATE('2026-06-30','YYYY-MM-DD'));
INSERT INTO Promotion (promotionName, startDate, endDate) VALUES ('Mid-Year Mega Sale', TO_DATE('2026-07-01','YYYY-MM-DD'), TO_DATE('2026-09-30','YYYY-MM-DD'));
INSERT INTO Promotion (promotionName, startDate, endDate) VALUES ('Year-End Festival Blast', TO_DATE('2026-10-01','YYYY-MM-DD'), TO_DATE('2026-12-31','YYYY-MM-DD'));

-- 4. Package (4 Packages)
INSERT INTO Package (packageName, price) VALUES ('Single / ชิ้นเดี่ยว', 0);
INSERT INTO Package (packageName, price) VALUES ('Pack / แพ็ค 6', 50);
INSERT INTO Package (packageName, price) VALUES ('Dozen / โหล 12', 100);
INSERT INTO Package (packageName, price) VALUES ('Box / ลัง', 300);

COMMIT;
