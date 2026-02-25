-- ==========================================
-- 01_locations.sql (Locations & Branches)
-- ==========================================

-- 1. Part
INSERT INTO Part (partName) VALUES ('ภาคเหนือ');
INSERT INTO Part (partName) VALUES ('ภาคตะวันออกเฉียงเหนือ');
INSERT INTO Part (partName) VALUES ('ภาคกลาง');
INSERT INTO Part (partName) VALUES ('ภาคตะวันออก');
INSERT INTO Part (partName) VALUES ('ภาคใต้');

-- 2. Province (Sample of 10 major provinces)
-- Note: Assuming IDs match the insert order above (1-5)
INSERT INTO Province (provinceName, partID, createUser) VALUES ('เชียงใหม่', 1, 'admin');
INSERT INTO Province (provinceName, partID, createUser) VALUES ('ขอนแก่น', 2, 'admin');
INSERT INTO Province (provinceName, partID, createUser) VALUES ('นครราชสีมา', 2, 'admin');
INSERT INTO Province (provinceName, partID, createUser) VALUES ('กรุงเทพมหานคร', 3, 'admin');
INSERT INTO Province (provinceName, partID, createUser) VALUES ('พระนครศรีอยุธยา', 3, 'admin');
INSERT INTO Province (provinceName, partID, createUser) VALUES ('ชลบุรี', 4, 'admin');
INSERT INTO Province (provinceName, partID, createUser) VALUES ('ระยอง', 4, 'admin');
INSERT INTO Province (provinceName, partID, createUser) VALUES ('ภูเก็ต', 5, 'admin');
INSERT INTO Province (provinceName, partID, createUser) VALUES ('สงขลา', 5, 'admin');
INSERT INTO Province (provinceName, partID, createUser) VALUES ('สุราษฎร์ธานี', 5, 'admin');

-- 3. Branch (15 Branches)
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขาเซ็นทรัลเฟส เชียงใหม่', 1, 'admin');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขานิมมาน', 1, 'admin');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขามข. ขอนแก่น', 2, 'admin');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขาโคราช เทอร์มินอล', 3, 'admin');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขาสยามพารากอน', 4, 'admin');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขาอโศก (Wholesale)', 4, 'admin');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขาอยุธยาปาร์ค', 5, 'admin');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขาพัทยาเหนือ', 6, 'admin');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขาบางแสน', 6, 'admin');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขามาบตาพุด', 7, 'admin');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขาป่าตอง', 8, 'admin');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขาหาดใหญ่', 9, 'admin');
INSERT INTO Branch (branchName, provinceID, createUser) VALUES ('สาขาสมุย', 10, 'admin');

COMMIT;
