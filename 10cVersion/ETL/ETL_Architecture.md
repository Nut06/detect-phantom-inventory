# Database-Driven ETL Architecture

เอกสารนี้จะอธิบายสถาปัตยกรรม ETL (Extract, Transform, Load) ที่ทำงานบนฐานข้อมูล Oracle ผ่าน PL/SQL ซึ่งเป็นโครงข่ายหลักในการส่งข้อมูลจากระบบหน้าร้าน (OLTP) ไปสูบลง Data Warehouse เพื่อให้ Power BI วิเคราะห์ `Phantom Inventory` ต่อได้

---

## 1. แผนภาพสถาปัตยกรรมการไหลของข้อมูล (Architecture Flow Diagram)

แผนภาพด้านล่างนี้จะแสดงให้เห็นชัดเจนว่า **OLTP -> ETL -> Staging DB -> ETL -> Data Warehouse** เชื่อมต่อกันอย่างไร

```mermaid
graph TD
    classDef oltp fill:#f9f,stroke:#333,stroke-width:2px;
    classDef etl fill:#bfb,stroke:#333,stroke-width:2px;
    classDef stg fill:#ffd,stroke:#333,stroke-width:2px;
    classDef dwh fill:#fdf,stroke:#333,stroke-width:2px;
    classDef cons fill:#9ff,stroke:#333,stroke-width:2px;

    subgraph 1. OLTP System (ระบบเบื้องหน้า/ฐานข้อมูลหลัก)
        A[(ตาราง Product, Receipt, PO)]:::oltp
    end

    subgraph 2. ETL (Extract - ดูดข้อมูล)
        B[[PKG_ETL_PIPELINE<br>SP_EXTRACT_TO_STG]]:::etl
    end

    subgraph 3. Staging DB (จุดพักข้อมูลดิบ)
        C[(ตาราง STG_RECEIPT<br>STG_PO<br>STG_INVENTORY_SNAPSHOT)]:::stg
    end

    subgraph 4. ETL (Transform - แปลงร่างและรวมร่าง)
        D[[PKG_ETL_PIPELINE<br>SP_TRANSFORM_TO_DWH]]:::etl
    end

    subgraph 5. Data Warehouse (คลังข้อมูล Star Schema)
        E[(ตาราง FACT_...<br>ตาราง DIM_...)]:::dwh
    end

    subgraph 6. Data Consumers (ผู้ใช้งานปลายทาง)
        F[Power BI Dashboard]:::cons
        G(((Node.js API - Read Only))):::cons
    end

    A -- "อ่านข้อมูล Transaction" --> B
    B -- "เทข้อมูลดิบ (TRUNCATE/INSERT)" --> C
    C -- "อ่านและทำความสะอาด" --> D
    D -- "MERGE รวบยอดเข้า Star Schema" --> E
    E -- "ดึงข้อมูลโดยตรง (DirectQuery / Import)" --> F
    E -- "เรียกดูข้อมูล (SELECT JSON)" --> G
```

---

## 2. เช็คลิสต์: ไฟล์ โค้ดไหน อยู่ส่วนไหนของ Architecture?

สคริปต์ที่เราเพิ่งสร้างไปทั้งหมด 3 ไฟล์ ถูกแบ่งหน้าที่ประจำแต่ละ Layer ของสถาปัตยกรรมด้านบนอย่างชัดเจนครับ:

### Layer 1: OLTP System (ต้นทางข้อมูลดิบ)

- **หน้าที่:** ตารางที่ทำงานกับระบบ Point of Sale หรือระบบ Inventory โดยตรง เช่น เวลาของเข้าหรือลูกค้าจ่ายเงิน ระบบจะ Insert ลงตารางนี้
- **ไฟล์ที่เกี่ยวข้อง:** `10cVersion/DDL/ddl.sql` และข้อมูล DML ทั้งหลาย
- **ตารางในระบบ:** `Receipt`, `PurchaseOrder`, `Product`, ฯลฯ

### Layer 3: Staging DB (จุดพักสินค้า หรือ โกดังดิบ)

- **หน้าที่:** แหล่งรวมข้อมูลดิบที่ได้จากการกวาด (Extract) มาจาก OLTP อย่างรวดเร็ว ตัด Foreign Key ทิ้งทั้งหมดเพื่อให้การรับของเข้ามา (Insert) เลื่อนไหลที่สุด
- **ไฟล์ที่เกี่ยวข้อง:** `10cVersion/ETL/01_ddl_staging.sql`
- **ตารางในระบบ:** `STG_RECEIPT`, `STG_PO`, `STG_INVENTORY_SNAPSHOT`

### Layer 5: Data Warehouse (หน้าร้านสวยหรูพร้อมเสิร์ฟ)

- **หน้าที่:** ตารางหลักชิ้นโบว์แดง (Star Schema) ที่เก็บตัวเลขทางการเงินและสต็อกที่ผ่านการบวกลบคูณหารมาแล้ว (Fact Tables) และล้อมรอบด้วยมิติคำอธิบาย (Dimension Tables) เช่น ชื่อสาขา, ชื่อแบรนด์แบบง่ายๆ
- **ไฟล์ที่เกี่ยวข้อง:** `10cVersion/ETL/02_ddl_data_warehouse.sql`
- **ตารางที่เป็นตัวเลข:** `FACT_SALES`, `FACT_PURCHASE`, `FACT_PHANTOM_INVENTORY`
- **ตารางที่เป็นคำอธิบาย:** `DIM_PRODUCT`, `DIM_LOCATION`, `DIM_CUSTOMER`, `DIM_DATETIME`, `DIM_SUPPLIER`

### Layer 2 & 4: กระบวนการ ETL (ห้องเครื่องยนต์ PL/SQL)

- **หน้าที่:** สมองกลที่สั่งให้ข้อมูลวิ่งจาก Layer 1 ไป 3 และจาก 3 ไป 5
- **ไฟล์ที่เกี่ยวข้อง:** `10cVersion/ETL/03_etl_engine.sql`
- **คำสั่งสับวิตช์ภายใน:**
  - `EXEC PKG_ETL_PIPELINE.SP_EXTRACT_TO_STG;` (เดินเครื่อง Layer 2 ยิงไป 3)
  - `EXEC PKG_ETL_PIPELINE.SP_TRANSFORM_TO_DWH;` (เดินเครื่อง Layer 4 ยิงไป 5)

---

## 3. วิธีใช้งาน (How to Use)

ถ้าต้องการอัปเดตข้อมูล Data Warehouse ให้มีข้อมูลยอดขายล่าสุดเสมอ เพียงแค่สั่งรันคำสั่งเดียวเบ็ดเสร็จ (ใช้รันเอง หรือจะให้ Backend ยิง Execute SQL คำสั่งนี้มาก็ได้):

```sql
EXEC PKG_ETL_PIPELINE.SP_RUN_FULL_ETL;
```
