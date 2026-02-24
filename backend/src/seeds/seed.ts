import { getConnection } from '../config/db.config.js';

const seed = async () => {
  const connection = await getConnection();
  console.log('connection established');

  try {
    // =============================================
    // 1. PURCHASEORDER (20 records)
    // =============================================
    console.log('insert PURCHASEORDER...');
    const purchaseOrders = [
      { purchaseDate: '2025-01-05', total: 5750.00, supplierId: 1, branchId: 1 },
      { purchaseDate: '2025-01-12', total: 3200.00, supplierId: 2, branchId: 1 },
      { purchaseDate: '2025-01-20', total: 4800.00, supplierId: 3, branchId: 2 },
      { purchaseDate: '2025-02-03', total: 6100.00, supplierId: 1, branchId: 2 },
      { purchaseDate: '2025-02-14', total: 2900.00, supplierId: 2, branchId: 1 },
      { purchaseDate: '2025-02-28', total: 7200.00, supplierId: 3, branchId: 1 },
      { purchaseDate: '2025-03-07', total: 4350.00, supplierId: 1, branchId: 2 },
      { purchaseDate: '2025-03-15', total: 5500.00, supplierId: 2, branchId: 2 },
      { purchaseDate: '2025-03-22', total: 3750.00, supplierId: 3, branchId: 1 },
      { purchaseDate: '2025-04-01', total: 6800.00, supplierId: 1, branchId: 1 },
      { purchaseDate: '2025-04-10', total: 4200.00, supplierId: 2, branchId: 2 },
      { purchaseDate: '2025-04-18', total: 5100.00, supplierId: 3, branchId: 1 },
      { purchaseDate: '2025-05-05', total: 3900.00, supplierId: 1, branchId: 2 },
      { purchaseDate: '2025-05-20', total: 7500.00, supplierId: 2, branchId: 1 },
      { purchaseDate: '2025-06-02', total: 4600.00, supplierId: 3, branchId: 2 },
      { purchaseDate: '2025-06-15', total: 5250.00, supplierId: 1, branchId: 1 },
      { purchaseDate: '2025-07-01', total: 3600.00, supplierId: 2, branchId: 2 },
      { purchaseDate: '2025-07-20', total: 8100.00, supplierId: 3, branchId: 1 },
      { purchaseDate: '2025-08-08', total: 4950.00, supplierId: 1, branchId: 2 },
      { purchaseDate: '2025-08-25', total: 6300.00, supplierId: 2, branchId: 1 },
    ];

    for (const po of purchaseOrders) {
      await connection.execute(
        `INSERT INTO PurchaseOrder (purchaseDate, total, supplierId, branchId) 
         VALUES (TO_DATE(:purchaseDate,'YYYY-MM-DD'), :total, :supplierId, :branchId)`,
        po
      );
    }
    console.log(`PURCHASEORDER: ${purchaseOrders.length} records`);

    // =============================================
    // 2. PURCHASEORDERDETAIL (40 records)
    // =============================================
    console.log('insert PURCHASEORDERDETAIL...');
    const poDetails = [
      { purchaseOrderId: 1,  productId: 1, qty: 200, costPerUnit: 11.50 },
      { purchaseOrderId: 1,  productId: 2, qty: 300, costPerUnit: 4.25  },
      { purchaseOrderId: 2,  productId: 1, qty: 150, costPerUnit: 11.50 },
      { purchaseOrderId: 2,  productId: 2, qty: 400, costPerUnit: 4.25  },
      { purchaseOrderId: 3,  productId: 1, qty: 250, costPerUnit: 11.50 },
      { purchaseOrderId: 3,  productId: 2, qty: 200, costPerUnit: 4.25  },
      { purchaseOrderId: 4,  productId: 1, qty: 300, costPerUnit: 11.50 },
      { purchaseOrderId: 4,  productId: 2, qty: 350, costPerUnit: 4.25  },
      { purchaseOrderId: 5,  productId: 1, qty: 100, costPerUnit: 11.50 },
      { purchaseOrderId: 5,  productId: 2, qty: 500, costPerUnit: 4.25  },
      { purchaseOrderId: 6,  productId: 1, qty: 400, costPerUnit: 11.50 },
      { purchaseOrderId: 6,  productId: 2, qty: 250, costPerUnit: 4.25  },
      { purchaseOrderId: 7,  productId: 1, qty: 200, costPerUnit: 11.50 },
      { purchaseOrderId: 7,  productId: 2, qty: 300, costPerUnit: 4.25  },
      { purchaseOrderId: 8,  productId: 1, qty: 350, costPerUnit: 11.50 },
      { purchaseOrderId: 8,  productId: 2, qty: 450, costPerUnit: 4.25  },
      { purchaseOrderId: 9,  productId: 1, qty: 150, costPerUnit: 11.50 },
      { purchaseOrderId: 9,  productId: 2, qty: 200, costPerUnit: 4.25  },
      { purchaseOrderId: 10, productId: 1, qty: 500, costPerUnit: 11.50 },
      { purchaseOrderId: 10, productId: 2, qty: 300, costPerUnit: 4.25  },
      { purchaseOrderId: 11, productId: 1, qty: 250, costPerUnit: 11.50 },
      { purchaseOrderId: 11, productId: 2, qty: 400, costPerUnit: 4.25  },
      { purchaseOrderId: 12, productId: 1, qty: 300, costPerUnit: 11.50 },
      { purchaseOrderId: 12, productId: 2, qty: 350, costPerUnit: 4.25  },
      { purchaseOrderId: 13, productId: 1, qty: 200, costPerUnit: 11.50 },
      { purchaseOrderId: 13, productId: 2, qty: 250, costPerUnit: 4.25  },
      { purchaseOrderId: 14, productId: 1, qty: 450, costPerUnit: 11.50 },
      { purchaseOrderId: 14, productId: 2, qty: 500, costPerUnit: 4.25  },
      { purchaseOrderId: 15, productId: 1, qty: 300, costPerUnit: 11.50 },
      { purchaseOrderId: 15, productId: 2, qty: 200, costPerUnit: 4.25  },
      { purchaseOrderId: 16, productId: 1, qty: 250, costPerUnit: 11.50 },
      { purchaseOrderId: 16, productId: 2, qty: 300, costPerUnit: 4.25  },
      { purchaseOrderId: 17, productId: 1, qty: 150, costPerUnit: 11.50 },
      { purchaseOrderId: 17, productId: 2, qty: 400, costPerUnit: 4.25  },
      { purchaseOrderId: 18, productId: 1, qty: 350, costPerUnit: 11.50 },
      { purchaseOrderId: 18, productId: 2, qty: 450, costPerUnit: 4.25  },
      { purchaseOrderId: 19, productId: 1, qty: 200, costPerUnit: 11.50 },
      { purchaseOrderId: 19, productId: 2, qty: 300, costPerUnit: 4.25  },
      { purchaseOrderId: 20, productId: 1, qty: 400, costPerUnit: 11.50 },
      { purchaseOrderId: 20, productId: 2, qty: 350, costPerUnit: 4.25  },
    ];

    for (const pod of poDetails) {
      await connection.execute(
        `INSERT INTO PurchaseOrderDetail (purchaseOrderId, productId, qty, costPerUnit) 
         VALUES (:purchaseOrderId, :productId, :qty, :costPerUnit)`,
        pod
      );
    }
    console.log(`PURCHASEORDERDETAIL: ${poDetails.length} records`);

    // =============================================
    // 3. RECEIPT (20 records)
    // =============================================
    console.log('insert RECEIPT...');
    const receipts = [
      { receiptDate: '2025-01-06', total: 107.00,  vat: 7.00,  customerId: 1, branchId: 1 },
      { receiptDate: '2025-01-13', total: 74.90,   vat: 4.90,  customerId: 2, branchId: 1 },
      { receiptDate: '2025-01-21', total: 160.50,  vat: 10.50, customerId: 1, branchId: 2 },
      { receiptDate: '2025-02-04', total: 214.00,  vat: 14.00, customerId: 2, branchId: 2 },
      { receiptDate: '2025-02-15', total: 53.50,   vat: 3.50,  customerId: 1, branchId: 1 },
      { receiptDate: '2025-02-28', total: 128.20,  vat: 8.40,  customerId: 2, branchId: 1 },
      { receiptDate: '2025-03-08', total: 96.30,   vat: 6.30,  customerId: 1, branchId: 2 },
      { receiptDate: '2025-03-16', total: 187.60,  vat: 12.60, customerId: 2, branchId: 1 },
      { receiptDate: '2025-03-23', total: 75.00,   vat: 4.90,  customerId: 1, branchId: 1 },
      { receiptDate: '2025-04-02', total: 245.70,  vat: 16.10, customerId: 2, branchId: 2 },
      { receiptDate: '2025-04-11', total: 112.40,  vat: 7.35,  customerId: 1, branchId: 1 },
      { receiptDate: '2025-04-19', total: 163.80,  vat: 10.71, customerId: 2, branchId: 2 },
      { receiptDate: '2025-05-06', total: 89.25,   vat: 5.84,  customerId: 1, branchId: 1 },
      { receiptDate: '2025-05-21', total: 320.50,  vat: 20.97, customerId: 2, branchId: 1 },
      { receiptDate: '2025-06-03', total: 145.60,  vat: 9.52,  customerId: 1, branchId: 2 },
      { receiptDate: '2025-06-16', total: 198.40,  vat: 12.98, customerId: 2, branchId: 1 },
      { receiptDate: '2025-07-02', total: 67.20,   vat: 4.40,  customerId: 1, branchId: 2 },
      { receiptDate: '2025-07-21', total: 278.90,  vat: 18.24, customerId: 2, branchId: 2 },
      { receiptDate: '2025-08-09', total: 134.75,  vat: 8.81,  customerId: 1, branchId: 1 },
      { receiptDate: '2025-08-26', total: 223.60,  vat: 14.62, customerId: 2, branchId: 1 },
    ];

    for (const receipt of receipts) {
      await connection.execute(
        `INSERT INTO Receipt (receiptDate, total, vat, customerId, branchId) 
         VALUES (TO_DATE(:receiptDate,'YYYY-MM-DD'), :total, :vat, :customerId, :branchId)`,
        receipt
      );
    }
    console.log(`RECEIPT: ${receipts.length} records`);

    // =============================================
    // 4. RECEIPTDETAIL (40 records)
    // =============================================
    console.log('insert RECEIPTDETAIL...');
    const receiptDetails = [
      { receiptId: 1,  productId: 1, qty: 5,  salePrice: 15.00 },
      { receiptId: 1,  productId: 2, qty: 8,  salePrice: 7.00  },
      { receiptId: 2,  productId: 1, qty: 3,  salePrice: 15.00 },
      { receiptId: 2,  productId: 2, qty: 6,  salePrice: 7.00  },
      { receiptId: 3,  productId: 1, qty: 8,  salePrice: 15.00 },
      { receiptId: 3,  productId: 2, qty: 10, salePrice: 7.00  },
      { receiptId: 4,  productId: 1, qty: 10, salePrice: 15.00 },
      { receiptId: 4,  productId: 2, qty: 15, salePrice: 7.00  },
      { receiptId: 5,  productId: 1, qty: 2,  salePrice: 15.00 },
      { receiptId: 5,  productId: 2, qty: 4,  salePrice: 7.00  },
      { receiptId: 6,  productId: 1, qty: 6,  salePrice: 15.00 },
      { receiptId: 6,  productId: 2, qty: 9,  salePrice: 7.00  },
      { receiptId: 7,  productId: 1, qty: 4,  salePrice: 15.00 },
      { receiptId: 7,  productId: 2, qty: 7,  salePrice: 7.00  },
      { receiptId: 8,  productId: 1, qty: 9,  salePrice: 15.00 },
      { receiptId: 8,  productId: 2, qty: 12, salePrice: 7.00  },
      { receiptId: 9,  productId: 1, qty: 3,  salePrice: 15.00 },
      { receiptId: 9,  productId: 2, qty: 5,  salePrice: 7.00  },
      { receiptId: 10, productId: 1, qty: 12, salePrice: 15.00 },
      { receiptId: 10, productId: 2, qty: 14, salePrice: 7.00  },
      { receiptId: 11, productId: 1, qty: 5,  salePrice: 15.00 },
      { receiptId: 11, productId: 2, qty: 8,  salePrice: 7.00  },
      { receiptId: 12, productId: 1, qty: 7,  salePrice: 15.00 },
      { receiptId: 12, productId: 2, qty: 11, salePrice: 7.00  },
      { receiptId: 13, productId: 1, qty: 4,  salePrice: 15.00 },
      { receiptId: 13, productId: 2, qty: 6,  salePrice: 7.00  },
      { receiptId: 14, productId: 1, qty: 15, salePrice: 15.00 },
      { receiptId: 14, productId: 2, qty: 20, salePrice: 7.00  },
      { receiptId: 15, productId: 1, qty: 6,  salePrice: 15.00 },
      { receiptId: 15, productId: 2, qty: 9,  salePrice: 7.00  },
      { receiptId: 16, productId: 1, qty: 8,  salePrice: 15.00 },
      { receiptId: 16, productId: 2, qty: 12, salePrice: 7.00  },
      { receiptId: 17, productId: 1, qty: 3,  salePrice: 15.00 },
      { receiptId: 17, productId: 2, qty: 5,  salePrice: 7.00  },
      { receiptId: 18, productId: 1, qty: 11, salePrice: 15.00 },
      { receiptId: 18, productId: 2, qty: 16, salePrice: 7.00  },
      { receiptId: 19, productId: 1, qty: 6,  salePrice: 15.00 },
      { receiptId: 19, productId: 2, qty: 8,  salePrice: 7.00  },
      { receiptId: 20, productId: 1, qty: 9,  salePrice: 15.00 },
      { receiptId: 20, productId: 2, qty: 13, salePrice: 7.00  },
    ];

    for (const rd of receiptDetails) {
      await connection.execute(
        `INSERT INTO ReceiptDetail (receiptId, productId, qty, sale_price) 
         VALUES (:receiptId, :productId, :qty, :salePrice)`,
        rd
      );
    }
    console.log(`RECEIPTDETAIL: ${receiptDetails.length} records`);

    // =============================================
    // 5. PROMOTIONDETAIL (2 records)
    // =============================================
    console.log('insert PROMOTIONDETAIL...');
    const promotionDetails = [
      { promotionId: 1, productId: 1, discountAmount: 3.00 },
      { promotionId: 1, productId: 2, discountAmount: 1.00 },
    ];

    for (const pd of promotionDetails) {
      await connection.execute(
        `INSERT INTO PromotionDetail (promotionId, productId, discountAmount) 
         VALUES (:promotionId, :productId, :discountAmount)`,
        pd
      );
    }
    console.log(`PROMOTIONDETAIL: ${promotionDetails.length} records`);

    // COMMIT ทุกอย่างพร้อมกัน
    await connection.commit();
    console.log('Seed data inserted successfully!');

  } catch (err) {
    // ถ้า error ให้ rollback 
    await connection.rollback();
    console.error('เกิดข้อผิดพลาด rollback :', err);
  } finally {
    await connection.close();
    console.log('connection closed');
  }
};

seed();