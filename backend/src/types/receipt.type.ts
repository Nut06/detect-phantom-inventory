export interface Receipt {
  receiptId: number;
  receiptDate: Date;
  total: number;
  vat: number;
  customerId: number;
  branchId: number;
}