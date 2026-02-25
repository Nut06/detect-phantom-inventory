import { Router } from 'express';
import * as dataController from '../controllers/data.controller.js';
import { getAllDataController } from '../controllers/data.controller.js';

const router = Router();

router.get('/all', getAllDataController);
router.get('/products', dataController.getProducts);
router.get('/customers', dataController.getCustomers);
router.get('/receipts', dataController.getReceipts);
router.get('/purchase-orders', dataController.getPurchaseOrders);
router.get('/receipt-details', dataController.getReceiptDetails);
router.get('/purchase-order-details', dataController.getPurchaseOrderDetails);
router.get('/suppliers', dataController.getSuppliers);
router.get('/categories', dataController.getCategories);
router.get('/brands', dataController.getBrands);
router.get('/branches', dataController.getBranches);
router.get('/provinces', dataController.getProvinces);
router.get('/parts', dataController.getParts);
router.get('/packages', dataController.getPackages);
router.get('/customer-types', dataController.getCustomerTypes);
router.get('/customer-phones', dataController.getCustomerPhones);
router.get('/promotions', dataController.getPromotions);
router.get('/promotion-details', dataController.getPromotionDetails);

//DW
router.get('/dw/fact-sales', dataController.getFactSales);
router.get('/dw/fact-purchase', dataController.getFactPurchase);
router.get('/dw/fact-phantom-inventory', dataController.getFactPhantomInventory);

export default router;