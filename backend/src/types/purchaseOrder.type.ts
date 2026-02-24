export interface PurchaseOrder {
  purchaseOrderId: number;
  purchaseDate: Date;
  total: number;
  supplierId: number;
  branchId: number;
}