# BAQ Example: Purchase Order Tracking

## Business Scenario

This BAQ was designed to help purchasing and planning teams monitor open purchase orders.

The goal of this query is to provide visibility into purchase order lines that have not been fully received. This information helps the business follow up with suppliers, identify overdue materials, and support production planning.

## Business Question

Which purchase orders are still open, and what quantities are pending to be received?

## Epicor Tables Used

| Table | Purpose |
|---|---|
| Vendor | Stores supplier master information. |
| POHeader | Stores purchase order header information. |
| PODetail | Stores purchase order line detail information. |
| PORel | Stores purchase order release information, including due dates and received quantities. |

## Table Relationships

Vendor is related to POHeader by the vendor number.

POHeader is related to PODetail by the purchase order number.

PODetail is related to PORel by the purchase order number and purchase order line number.

The query starts from the purchase order header, connects each purchase order to its supplier, connects the purchase order to its detail lines, and then connects each line to its release information.

## Selected Fields

| Field | Description |
|---|---|
| Vendor.VendorID | Supplier identification code. |
| Vendor.Name | Supplier name. |
| POHeader.PONum | Purchase order number. |
| POHeader.OrderDate | Date when the purchase order was created. |
| PODetail.POLine | Purchase order line number. |
| PODetail.PartNum | Part number ordered from the supplier. |
| PODetail.LineDesc | Purchase order line description. |
| PORel.PORelNum | Purchase order release number. |
| PORel.DueDate | Expected receipt date for the purchase order release. |
| PORel.RelQty | Quantity ordered for the release. |
| PORel.ReceivedQty | Quantity already received. |

## Calculated Field

A calculated field is added to show the quantity that is still pending to receive.

Field name:

PendingReceiptQty

Formula:

PORel.RelQty - PORel.ReceivedQty

## Filter Criteria

The BAQ should only show purchase order releases where the received quantity is lower than the released quantity.

Suggested condition:

PORel.ReceivedQty < PORel.RelQty

This filter removes fully received purchase order releases and keeps only open purchase order lines that still have pending quantities.

## Sample Result

| Supplier ID | Supplier Name | PO Num | Order Date | Line | Part Num | Description | Due Date | Ordered Qty | Received Qty | Pending Qty |
|---|---|---:|---|---:|---|---|---|---:|---:|---:|
| SUP001 | Steel Supply Co. | 45001 | 2026-02-01 | 1 | RM-100 | Steel Sheet 10 mm | 2026-02-15 | 100 | 60 | 40 |
| SUP002 | Electrical Components MX | 45002 | 2026-02-03 | 1 | RM-250 | Electrical Connector | 2026-02-18 | 200 | 120 | 80 |
| SUP003 | Industrial Hardware Ltd. | 45003 | 2026-02-05 | 2 | RM-500 | Mounting Bracket | 2026-02-20 | 150 | 0 | 150 |

## Business Value

This BAQ provides a clear view of purchase order lines that are still pending receipt.

It helps purchasing teams follow up with suppliers, helps planners identify materials that may affect production, and helps warehouse teams prepare for expected receipts.

The main value of this BAQ is that it converts purchasing and receiving data into actionable information for supplier follow-up and material availability.

## Functional Area

Purchasing  
Supplier Management  
Material Planning  
Receiving Operations

## Complexity Level

Intermediate

This BAQ includes purchase order header data, purchase order detail data, supplier information, release-level quantities, and calculated pending receipt logic.

## Skills Demonstrated

### Epicor ERP Knowledge

- Purchase Order Management
- Supplier Management
- Receiving Process
- Material Planning

### BAQ Development Skills

- Multi-table joins
- Release-level analysis
- Calculated fields
- Query filtering
- Purchasing report design

### Business Analysis Skills

- Supplier follow-up analysis
- Material availability review
- Open purchase order monitoring
- Production planning support

### Technical Skills

- Epicor Kinetic BAQ Designer
- ERP purchasing reporting
- Data modeling
- Dashboard-ready dataset creation
