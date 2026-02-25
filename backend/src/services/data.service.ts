import { getConnection } from '../config/db.config.js';

//เทสแบบ รวมทุกตาราง
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


//เทสแบบแยกตาราง
const queryAll = async (table: string) => {
  const connection = await getConnection();
  try {
    const result = await connection.execute(`SELECT * FROM ${table}`);
    return result.rows;
  } finally {
    await connection.close();
  }
};

export const getProducts = () => queryAll('PRODUCT');
export const getCustomers = () => queryAll('CUSTOMER');
export const getReceipts = () => queryAll('RECEIPT');
export const getPurchaseOrders = () => queryAll('PURCHASEORDER');
export const getReceiptDetails = () => queryAll('RECEIPTDETAIL');
export const getPurchaseOrderDetails = () => queryAll('PURCHASEORDERDETAIL');
export const getSuppliers = () => queryAll('SUPPLIER');
export const getCategories = () => queryAll('CATEGORY');
export const getBrands = () => queryAll('BRAND');
export const getBranches = () => queryAll('BRANCH');
export const getProvinces = () => queryAll('PROVINCE');
export const getParts = () => queryAll('PART');
export const getPackages = () => queryAll('PACKAGE');
export const getCustomerTypes = () => queryAll('CUSTOMERTYPE');
export const getCustomerPhones = () => queryAll('CUSTOMERPHONE');
export const getPromotions = () => queryAll('PROMOTION');
export const getPromotionDetails = () => queryAll('PROMOTIONDETAIL');


//From DW
export const getFactSales = () => queryAll('FACT_SALES');
export const getFactPurchase = () => queryAll('FACT_PURCHASE');
export const getFactPhantomInventory = () => queryAll('FACT_PHANTOM_INVENTORY');

export const getDimProduct = () => queryAll('DIM_PRODUCT');
export const getDimLocation = () => queryAll('DIM_LOCATION');
export const getDimCustomer = () => queryAll('DIM_CUSTOMER');
export const getDimSupplier = () => queryAll('DIM_SUPPLIER');
export const getDimDatetime = () => queryAll('DIM_DATETIME');