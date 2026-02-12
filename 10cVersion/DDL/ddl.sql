-- 1. Part
CREATE TABLE Part (
    partID NUMBER,
    partName VARCHAR2(100) CONSTRAINT nn_part_name NOT NULL,
    CONSTRAINT pk_part PRIMARY KEY (partID)
);

-- 2. Province
CREATE TABLE Province (
    provinceID NUMBER,
    provinceName VARCHAR2(100) CONSTRAINT nn_prov_name NOT NULL,
    partID NUMBER,
    createdAt DATE DEFAULT SYSDATE,
    createUser VARCHAR2(50),
    updatedAt DATE,
    updateUser VARCHAR2(50),
    CONSTRAINT pk_province PRIMARY KEY (provinceID),
    CONSTRAINT fk_province_part FOREIGN KEY (partID) REFERENCES Part(partID)
);

-- 3. Supplier
CREATE TABLE Supplier (
    supplierID NUMBER,
    supplierName VARCHAR2(100) CONSTRAINT nn_sup_name NOT NULL,
    CONSTRAINT pk_supplier PRIMARY KEY (supplierID)
);

-- 4. Category
CREATE TABLE Category (
    categoryID NUMBER,
    categoryName VARCHAR2(100) CONSTRAINT nn_cat_name NOT NULL,
    CONSTRAINT pk_category PRIMARY KEY (categoryID)
);

-- 5. CustomerType
CREATE TABLE CustomerType (
    customerTypeID NUMBER,
    customerTypeName VARCHAR2(50) CONSTRAINT nn_custtype_name NOT NULL,
    discountRate NUMBER(5, 2) DEFAULT 0,
    CONSTRAINT pk_customerType PRIMARY KEY (customerTypeID)
);

-- 6. Promotion
CREATE TABLE Promotion (
    promotionID NUMBER,
    promotionName VARCHAR2(100),
    startDate DATE,
    endDate DATE,
    CONSTRAINT pk_promotion PRIMARY KEY (promotionID)
);

-- 7. Brand
CREATE TABLE Brand (
    brandID NUMBER,
    brandName VARCHAR2(50) CONSTRAINT nn_brand_name NOT NULL,
    discountRate NUMBER(5, 2) DEFAULT 0,
    CONSTRAINT pk_brand PRIMARY KEY (brandID)
);

-- 8. Branch
CREATE TABLE Branch (
    branchID NUMBER,
    branchName VARCHAR2(100) CONSTRAINT nn_branch_name NOT NULL,
    createUser VARCHAR2(50),
    createAt DATE DEFAULT SYSDATE,
    updateAt DATE,
    provinceID NUMBER,
    CONSTRAINT pk_branch PRIMARY KEY (branchID),
    CONSTRAINT fk_branch_prov FOREIGN KEY (provinceID) REFERENCES Province(provinceID)
);

-- 9. Customer
CREATE TABLE Customer (
    customerID NUMBER,
    firstName VARCHAR2(50) CONSTRAINT nn_cust_fname NOT NULL,
    lastName VARCHAR2(50) CONSTRAINT nn_cust_lname NOT NULL,
    address VARCHAR2(100),
    createUser VARCHAR2(50),
    createAt DATE DEFAULT SYSDATE,
    customerTypeID NUMBER,
    CONSTRAINT pk_customer PRIMARY KEY (customerID),
    CONSTRAINT fk_cust_type FOREIGN KEY (customerTypeID) REFERENCES CustomerType(customerTypeID)
);

-- 10. Package
CREATE TABLE Package (
    packageID NUMBER,
    packageName VARCHAR2(70) CONSTRAINT nn_pkg_name NOT NULL,
    price NUMBER(15, 2) DEFAULT 0,
    CONSTRAINT pk_package PRIMARY KEY (packageID)
);

-- 11. Product (ย้ายมาสร้างหลัง Package เพื่อให้ Reference ได้)
CREATE TABLE Product (
    productID NUMBER,
    productName VARCHAR2(200) CONSTRAINT nn_prod_name NOT NULL,
    price NUMBER(15, 2) DEFAULT 0,
    cost NUMBER(15, 2) DEFAULT 0,
    qty NUMBER DEFAULT 0,
    createUser VARCHAR2(50),
    createAt DATE DEFAULT SYSDATE,
    updateUser VARCHAR2(50),
    updateAt DATE,
    brandID NUMBER,
    categoryID NUMBER,
    branchID NUMBER,
    packageID NUMBER,
    CONSTRAINT pk_product PRIMARY KEY (productID),
    CONSTRAINT fk_prod_brand FOREIGN KEY (brandID) REFERENCES Brand(brandID),
    CONSTRAINT fk_prod_cat FOREIGN KEY (categoryID) REFERENCES Category(categoryID),
    CONSTRAINT fk_prod_branch FOREIGN KEY (branchID) REFERENCES Branch(branchID),
    CONSTRAINT fk_prod_package FOREIGN KEY (packageID) REFERENCES Package(packageID)
);

-- 12. PurchaseOrder
CREATE TABLE PurchaseOrder (
    purchaseOrderID NUMBER,
    purchaseDate DATE DEFAULT SYSDATE,
    total NUMBER(15, 2) DEFAULT 0,
    supplierID NUMBER,
    branchID NUMBER,
    CONSTRAINT pk_purchaseOrder PRIMARY KEY (purchaseOrderID),
    CONSTRAINT fk_po_supplier FOREIGN KEY (supplierID) REFERENCES Supplier(supplierID),
    CONSTRAINT fk_po_branch FOREIGN KEY (branchID) REFERENCES Branch(branchID)
);

-- 13. Receipt
CREATE TABLE Receipt (
    receiptID NUMBER,
    receiptDate DATE DEFAULT SYSDATE,
    total NUMBER(15, 2) DEFAULT 0,
    vat NUMBER(15, 2) DEFAULT 0,
    customerID NUMBER,
    branchID NUMBER,
    CONSTRAINT pk_receipt PRIMARY KEY (receiptID),
    CONSTRAINT fk_receipt_cust FOREIGN KEY (customerID) REFERENCES Customer(customerID),
    CONSTRAINT fk_receipt_branch FOREIGN KEY (branchID) REFERENCES Branch(branchID)
);

-- 14. PurchaseOrderDetail (ปรับแก้ Syntax ที่พิมพ์ผิด)
CREATE TABLE PurchaseOrderDetail ( 
    poDetailID NUMBER, 
    purchaseOrderID NUMBER, 
    productID NUMBER, 
    qty NUMBER(10) NOT NULL, 
    costPerUnit NUMBER(15, 2), 
    CONSTRAINT pk_po_detail_new PRIMARY KEY (poDetailID), 
    CONSTRAINT fk_pod_header FOREIGN KEY (purchaseOrderID) REFERENCES PurchaseOrder(purchaseOrderID) ON DELETE CASCADE, 
    CONSTRAINT fk_pod_prod FOREIGN KEY (productID) REFERENCES Product(productID) 
);

-- 15. ReceiptDetail
CREATE TABLE ReceiptDetail ( 
    receiptDetailID NUMBER, 
    receiptID NUMBER, 
    productID NUMBER, 
    qty NUMBER(10) NOT NULL, 
    sale_price NUMBER(15, 2), 
    CONSTRAINT pk_receipt_detail_new PRIMARY KEY (receiptDetailID), 
    CONSTRAINT fk_rd_header FOREIGN KEY (receiptID) REFERENCES Receipt(receiptID) ON DELETE CASCADE, 
    CONSTRAINT fk_rd_prod FOREIGN KEY (productID) REFERENCES Product(productID) 
);

-- 16. PromotionDetail (Junction Table)
CREATE TABLE PromotionDetail ( 
    promotionID NUMBER, 
    productID NUMBER, 
    discountAmount NUMBER(10, 2), 
    CONSTRAINT pk_promo_detail PRIMARY KEY (promotionID, productID),
    CONSTRAINT fk_pd_promotion FOREIGN KEY (promotionID) REFERENCES Promotion(promotionID) ON DELETE CASCADE, 
    CONSTRAINT fk_pd_product FOREIGN KEY (productID) REFERENCES Product(productID) 
);

-- 17. CustomerPhone (Multi-valued Attribute)
CREATE TABLE CustomerPhone (
    customerID NUMBER, 
    phoneNumber VARCHAR2(20), 
    CONSTRAINT pk_cust_phone PRIMARY KEY (customerID, phoneNumber),
    CONSTRAINT fk_cp_customer FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON DELETE CASCADE 
);