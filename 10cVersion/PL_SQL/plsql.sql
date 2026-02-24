SET SERVEROUTPUT ON;

-- -----------------------------------------------------------------------------
-- 1. SP_CREATE_PO (Stock IN)
-- -----------------------------------------------------------------------------
-- Purpose: Creates a Purchase Order and immediately adds quantity to Product stock.
CREATE OR REPLACE PROCEDURE SP_CREATE_PO (
    p_supplierID  IN NUMBER,
    p_branchID    IN NUMBER,
    p_productID   IN NUMBER,
    p_qty         IN NUMBER,
    p_costPerUnit IN NUMBER
)
AS
    v_po_id NUMBER;
BEGIN
    -- 1. Insert Header (PurchaseOrder)
    INSERT INTO PurchaseOrder (supplierID, branchID) 
    VALUES (p_supplierID, p_branchID)
    RETURNING purchaseOrderID INTO v_po_id;

    -- 2. Insert Detail (PurchaseOrderDetail)
    INSERT INTO PurchaseOrderDetail (purchaseOrderID, productID, qty, costPerUnit)
    VALUES (v_po_id, p_productID, p_qty, p_costPerUnit);

    -- 3. Update PO Total
    UPDATE PurchaseOrder 
    SET total = p_qty * p_costPerUnit
    WHERE purchaseOrderID = v_po_id;

    -- 4. Update Stock (Product)
    -- This simulates receiving the goods immediately upon PO creation.
    UPDATE Product
    SET qty = qty + p_qty,
        cost = p_costPerUnit,
        updateAt = SYSDATE,
        updateUser = 'SP_CREATE_PO'
    WHERE productID = p_productID;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('PO ID ' || v_po_id || ' created successfully. Stock updated.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error in SP_CREATE_PO_AND_RECEIVE: ' || SQLERRM);
        RAISE;
END;
/

-- -----------------------------------------------------------------------------
-- 2. SP_PROCESS_RECEIPT (Stock OUT)
-- -----------------------------------------------------------------------------
-- Purpose: Creates a Sales Receipt and immediately deducts quantity from Product stock.
CREATE OR REPLACE PROCEDURE SP_PROCESS_RECEIPT (
    p_customerID IN NUMBER,
    p_branchID   IN NUMBER,
    p_productID  IN NUMBER,
    p_qty        IN NUMBER
)
AS
    v_receipt_id NUMBER;
    v_current_qty NUMBER;
    v_sale_price  NUMBER;
BEGIN
    -- 1. Check current stock and get price
    SELECT qty, price INTO v_current_qty, v_sale_price 
    FROM Product 
    WHERE productID = p_productID FOR UPDATE; -- Lock the row

    IF v_current_qty < p_qty THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient stock for Product ID: ' || p_productID);
    END IF;

    -- 2. Insert Header (Receipt)
    INSERT INTO Receipt (customerID, branchID) 
    VALUES (p_customerID, p_branchID)
    RETURNING receiptID INTO v_receipt_id;

    -- 3. Insert Detail (ReceiptDetail)
    INSERT INTO ReceiptDetail (receiptID, productID, qty, sale_price)
    VALUES (v_receipt_id, p_productID, p_qty, v_sale_price);

    -- 4. Update Receipt Total
    UPDATE Receipt 
    SET total = p_qty * v_sale_price,
        vat = (p_qty * v_sale_price) * 0.07 -- Assuming 7% VAT
    WHERE receiptID = v_receipt_id;

    -- 5. Deduct Stock (Product)
    UPDATE Product
    SET qty = qty - p_qty,
        updateAt = SYSDATE,
        updateUser = 'SP_PROCESS_RECEIPT'
    WHERE productID = p_productID;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Receipt ID ' || v_receipt_id || ' processed successfully. Stock deducted.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error in SP_PROCESS_RECEIPT: ' || SQLERRM);
        RAISE;
END;
/

-- -----------------------------------------------------------------------------
-- 3. TRG_PREVENT_NEGATIVE_STOCK (Safeguard)
-- -----------------------------------------------------------------------------
-- Purpose: Prevents any operation (even manual ones) from pushing stock below zero.
CREATE OR REPLACE TRIGGER TRG_PREVENT_NEGATIVE_STOCK
BEFORE UPDATE OF qty ON Product
FOR EACH ROW
BEGIN
    IF :NEW.qty < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Stock transaction denied. Product ID ' || :NEW.productID || ' cannot have a negative quantity (' || :NEW.qty || ').');
    END IF;
END;
/
