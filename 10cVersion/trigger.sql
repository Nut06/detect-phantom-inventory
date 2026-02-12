-- 1. Part
CREATE OR REPLACE TRIGGER trg_part_id BEFORE INSERT ON Part FOR EACH ROW
BEGIN SELECT part_seq.NEXTVAL INTO :NEW.partID FROM dual; END;
/
-- 2. Province
CREATE OR REPLACE TRIGGER trg_province_id BEFORE INSERT ON Province FOR EACH ROW
BEGIN SELECT province_seq.NEXTVAL INTO :NEW.provinceID FROM dual; END;
/
-- 3. Supplier
CREATE OR REPLACE TRIGGER trg_supplier_id BEFORE INSERT ON Supplier FOR EACH ROW
BEGIN SELECT supplier_seq.NEXTVAL INTO :NEW.supplierID FROM dual; END;
/
-- 4. Category
CREATE OR REPLACE TRIGGER trg_category_id BEFORE INSERT ON Category FOR EACH ROW
BEGIN SELECT category_seq.NEXTVAL INTO :NEW.categoryID FROM dual; END;
/
-- 5. CustomerType
CREATE OR REPLACE TRIGGER trg_custtype_id BEFORE INSERT ON CustomerType FOR EACH ROW
BEGIN SELECT custtype_seq.NEXTVAL INTO :NEW.customerTypeID FROM dual; END;
/
-- 6. Promotion
CREATE OR REPLACE TRIGGER trg_promotion_id BEFORE INSERT ON Promotion FOR EACH ROW
BEGIN SELECT promotion_seq.NEXTVAL INTO :NEW.promotionID FROM dual; END;
/
-- 7. Brand
CREATE OR REPLACE TRIGGER trg_brand_id BEFORE INSERT ON Brand FOR EACH ROW
BEGIN SELECT brand_seq.NEXTVAL INTO :NEW.brandID FROM dual; END;
/
-- 8. Branch
CREATE OR REPLACE TRIGGER trg_branch_id BEFORE INSERT ON Branch FOR EACH ROW
BEGIN SELECT branch_seq.NEXTVAL INTO :NEW.branchID FROM dual; END;
/
-- 9. Customer
CREATE OR REPLACE TRIGGER trg_customer_id BEFORE INSERT ON Customer FOR EACH ROW
BEGIN SELECT customer_seq.NEXTVAL INTO :NEW.customerID FROM dual; END;
/
-- 10. Package
CREATE OR REPLACE TRIGGER trg_package_id BEFORE INSERT ON Package FOR EACH ROW
BEGIN SELECT package_seq.NEXTVAL INTO :NEW.packageID FROM dual; END;
/
-- 11. Product
CREATE OR REPLACE TRIGGER trg_product_id BEFORE INSERT ON Product FOR EACH ROW
BEGIN SELECT product_seq.NEXTVAL INTO :NEW.productID FROM dual; END;
/
-- 12. PurchaseOrder
CREATE OR REPLACE TRIGGER trg_po_id BEFORE INSERT ON PurchaseOrder FOR EACH ROW
BEGIN SELECT po_seq.NEXTVAL INTO :NEW.purchaseOrderID FROM dual; END;
/
-- 13. Receipt
CREATE OR REPLACE TRIGGER trg_receipt_id BEFORE INSERT ON Receipt FOR EACH ROW
BEGIN SELECT receipt_seq.NEXTVAL INTO :NEW.receiptID FROM dual; END;
/
-- 14. PurchaseOrderDetail
CREATE OR REPLACE TRIGGER trg_po_detail_id BEFORE INSERT ON PurchaseOrderDetail FOR EACH ROW
BEGIN SELECT po_detail_seq.NEXTVAL INTO :NEW.poDetailID FROM dual; END;
/
-- 15. ReceiptDetail
CREATE OR REPLACE TRIGGER trg_receipt_detail_id BEFORE INSERT ON ReceiptDetail FOR EACH ROW
BEGIN SELECT receipt_detail_seq.NEXTVAL INTO :NEW.receiptDetailID FROM dual; END;
/

-- DROP TRIGGER trigger_name cmd for drop trigger