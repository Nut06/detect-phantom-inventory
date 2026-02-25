-- ==========================================
-- 05_generate_transactions.sql
-- Leveraging PL/SQL to simulate realistic business 
-- operations (Stock-In and Stock-Out) for Analytics
-- ==========================================

DECLARE
    CURSOR c_prods IS SELECT productID, branchID, cost, price FROM Product;
    
    v_supplier_id NUMBER;
    v_customer_id NUMBER;
    v_po_qty NUMBER;
    v_rcpt_qty NUMBER;
    
    v_po_count NUMBER := 0;
    v_rcpt_count NUMBER := 0;
BEGIN
    -- PHASE 1: INITIAL STOCK UP (Purchase Orders)
    -- Loop through every single product and restock them from random suppliers
    -- We'll do 3 POs per product to simulate different delivery batches
    FOR p IN c_prods LOOP
        FOR i IN 1..3 LOOP
            v_supplier_id := TRUNC(DBMS_RANDOM.VALUE(1, 11));
            v_po_qty := TRUNC(DBMS_RANDOM.VALUE(50, 500)); -- Buy 50-500 items per batch
            
            -- Call our Stock-In Procedure
            BEGIN
                SELECT supplierID INTO v_supplier_id 
                FROM (SELECT supplierID FROM Supplier ORDER BY DBMS_RANDOM.VALUE) 
                WHERE ROWNUM = 1;
                
                SP_CREATE_PO(
                    p_supplierID => v_supplier_id,
                    p_branchID => p.branchID,
                    p_productID => p.productID,
                    p_qty => v_po_qty,
                    p_costPerUnit => p.cost * DBMS_RANDOM.VALUE(0.9, 1.1) -- Cost fluctuates +-10%
                );
                
                -- Hack: Randomize the Purchase Date for the last inserted PO (since SP defaults to SYSDATE)
                UPDATE PurchaseOrder SET purchaseDate = SYSDATE - TRUNC(DBMS_RANDOM.VALUE(0, 90))
                WHERE purchaseOrderID = (SELECT MAX(purchaseOrderID) FROM PurchaseOrder);
                
                v_po_count := v_po_count + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;
        END LOOP;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Generated ' || v_po_count || ' Purchase Orders (Restocked)');

    -- PHASE 2: SALES (Receipts)
    -- Now that branches have stock, let's simulate customers buying them!
    -- We do 5 sales receipts per product
    FOR p IN c_prods LOOP
        FOR i IN 1..5 LOOP
            -- dynamically fetch a valid customerID
            SELECT customerID INTO v_customer_id 
            FROM (SELECT customerID FROM Customer ORDER BY DBMS_RANDOM.VALUE) 
            WHERE ROWNUM = 1;
            
            -- Customers usually buy fewer items than POs
            v_rcpt_qty := TRUNC(DBMS_RANDOM.VALUE(1, 25)); 
            
            BEGIN
                -- Call our Stock-Out procedure. We wrap in block because 
                -- stock might run out from RNG, we just want to ignore errors and continue.
                SP_PROCESS_RECEIPT(
                    p_customerID => v_customer_id,
                    p_branchID => p.branchID,
                    p_productID => p.productID,
                    p_qty => v_rcpt_qty
                );
                
                -- Hack: Randomize the Receipt Date for the last inserted Receipt
                UPDATE Receipt SET receiptDate = SYSDATE - TRUNC(DBMS_RANDOM.VALUE(0, 90))
                WHERE receiptID = (SELECT MAX(receiptID) FROM Receipt);
                
                v_rcpt_count := v_rcpt_count + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    -- Ignore Insufficient Stock application errors and just continue
                    NULL; 
            END;
        END LOOP;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Generated ' || v_rcpt_count || ' Successful Receipts (Sales)');
    COMMIT;
END;
/
