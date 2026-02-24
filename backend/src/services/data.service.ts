import { getConnection } from '../config/db.config.js';

export const getAllData = async () => {
  const connection = await getConnection();
  try {
    const [
      products, customers, customerTypes, customerPhones,
      receipts, receiptDetails, purchaseOrders, purchaseOrderDetails,
      promotions, promotionDetails, suppliers, categories,
      brands, branches, provinces, parts, packages
    ] = await Promise.all([
      connection.execute(`SELECT * FROM PRODUCT`),
      connection.execute(`SELECT * FROM CUSTOMER`),
      connection.execute(`SELECT * FROM CUSTOMERTYPE`),
      connection.execute(`SELECT * FROM CUSTOMERPHONE`),
      connection.execute(`SELECT * FROM RECEIPT`),
      connection.execute(`SELECT * FROM RECEIPTDETAIL`),
      connection.execute(`SELECT * FROM PURCHASEORDER`),
      connection.execute(`SELECT * FROM PURCHASEORDERDETAIL`),
      connection.execute(`SELECT * FROM PROMOTION`),
      connection.execute(`SELECT * FROM PROMOTIONDETAIL`),
      connection.execute(`SELECT * FROM SUPPLIER`),
      connection.execute(`SELECT * FROM CATEGORY`),
      connection.execute(`SELECT * FROM BRAND`),
      connection.execute(`SELECT * FROM BRANCH`),
      connection.execute(`SELECT * FROM PROVINCE`),
      connection.execute(`SELECT * FROM PART`),
      connection.execute(`SELECT * FROM PACKAGE`),
    ]);

    return {
      products: products.rows,
      customers: customers.rows,
      customerTypes: customerTypes.rows,
      customerPhones: customerPhones.rows,
      receipts: receipts.rows,
      receiptDetails: receiptDetails.rows,
      purchaseOrders: purchaseOrders.rows,
      purchaseOrderDetails: purchaseOrderDetails.rows,
      promotions: promotions.rows,
      promotionDetails: promotionDetails.rows,
      suppliers: suppliers.rows,
      categories: categories.rows,
      brands: brands.rows,
      branches: branches.rows,
      provinces: provinces.rows,
      parts: parts.rows,
      packages: packages.rows,
    };
  } finally {
    await connection.close();
  }
};