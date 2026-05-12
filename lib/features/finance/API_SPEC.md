# Finance Feature API Specification

These are the proposed APIs to be implemented in the backend (`C:\Users\Bhanuprakash\Documents\kirana-master-backend\`) to support the Finance tab.

## 1. Finance Overview Stats
**Endpoint:** `GET /kirana/finance/overview`
**Auth:** Bearer Token

**Response:**
```json
{
  "today_sales": {
    "amount": 12500.0,
    "sku_count": 45
  },
  "udhaar_stats": {
    "total_pending": 85000.0,
    "total_recovered": 12000.0,
    "customer_count": 18
  }
}
```

## 2. Udhaar List
**Endpoint:** `GET /kirana/finance/udhaar`
**Auth:** Bearer Token
**Query Params:** `include_recovered=true|false`

**Response:**
```json
[
  {
    "khata_id": 1,
    "customer_id": 10,
    "customer_name": "Rajesh Kumar",
    "phone": "+919876543210",
    "balance": 1500.0,
    "date_taken": "2026-05-01T10:00:00Z",
    "days_pending": 7
  },
  ...
]
```

## 3. Record Udhaar Recovery
**Endpoint:** `POST /kirana/finance/udhaar/recovery`
**Auth:** Bearer Token

**Request:**
```json
{
  "khata_id": 1,
  "amount": 500.0
}
```

**Response:** Updated Udhaar record.

## 4. Sync Customers (from Mobile Contacts)
**Endpoint:** `POST /kirana/finance/customers/sync`
**Auth:** Bearer Token

**Request:**
```json
[
  {
    "name": "Amit Sharma",
    "phone": "+919988776655"
  },
  ...
]
```
**Action:** Provision `customer` and `khata` rows for these contacts if they don't exist for the store.
