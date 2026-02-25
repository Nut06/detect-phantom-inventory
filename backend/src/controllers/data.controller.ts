import { Request, Response } from 'express';
import { getAllData } from '../services/data.service.js';
import * as dataService from '../services/data.service.js';

export const getAllDataController = async (req: Request, res: Response) => {
  try {
    const data = await getAllData();
    res.json({ status: 'success', data });
  } catch (err: any) {
    res.status(500).json({ status: 'error', message: err.message });
  }
};

// เขียน controller แบบแยกตาราง generic handler #ลองดูเฉยๆ  by Peat
const handleQuery = (serviceFn: () => Promise<any>) => async (req: Request, res: Response) => {
  try {
    const data = await serviceFn();
    res.json(data); // ส่งกลับเป็น JSON ตรงๆ by Peat v.2
  } catch (err: any) {
    res.status(500).json({ status: 'error', message: err.message });
  }
};

export const getProducts = handleQuery(dataService.getProducts);
export const getCustomers = handleQuery(dataService.getCustomers);
export const getReceipts = handleQuery(dataService.getReceipts);
export const getPurchaseOrders = handleQuery(dataService.getPurchaseOrders);
export const getReceiptDetails = handleQuery(dataService.getReceiptDetails);
export const getPurchaseOrderDetails = handleQuery(dataService.getPurchaseOrderDetails);
export const getSuppliers = handleQuery(dataService.getSuppliers);
export const getCategories = handleQuery(dataService.getCategories);
export const getBrands = handleQuery(dataService.getBrands);
export const getBranches = handleQuery(dataService.getBranches);
export const getProvinces = handleQuery(dataService.getProvinces);
export const getParts = handleQuery(dataService.getParts);
export const getPackages = handleQuery(dataService.getPackages);
export const getCustomerTypes = handleQuery(dataService.getCustomerTypes);
export const getCustomerPhones = handleQuery(dataService.getCustomerPhones);
export const getPromotions = handleQuery(dataService.getPromotions);
export const getPromotionDetails = handleQuery(dataService.getPromotionDetails);

//from DW
export const getFactSales = handleQuery(dataService.getFactSales);
export const getFactPurchase = handleQuery(dataService.getFactPurchase);
export const getFactPhantomInventory = handleQuery(dataService.getFactPhantomInventory);