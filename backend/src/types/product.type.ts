export interface Product {
  productId: number;
  productName: string;
  price: number;
  cost: number;
  qty: number;
  createUser: string;
  createAt: Date;
  updateUser: string;
  updateAt: Date;
  brandId: number;
  categoryId: number;
  branchId: number;
  packageId: number;
}