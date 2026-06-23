# BAQ Example: Inventory Below Minimum

## Business Scenario

This BAQ was designed to help inventory and purchasing teams identify parts with inventory levels below the minimum required quantity.

The goal of this query is to provide visibility into parts that may require replenishment. This information helps the business prevent stock shortages, support production continuity, and improve purchasing decisions.

## Business Question

Which parts are currently below the minimum inventory level and may require replenishment?

## Epicor Tables Used

| Table | Purpose |
|---|---|
| Part | Stores part master information. |
| PartWhse | Stores warehouse-level inventory quantities for each part. |
| Warehse | Stores warehouse information. |

## Table Relationships

Part is related to PartWhse by the part number.

PartWhse is related to Warehse by the warehouse code.

The query starts from the part master, connects each part to its warehouse inventory record, and then connects the record to the warehouse information.

## Selected Fields

| Field | Description |
|---|---|
| Part.PartNum | Part number. |
| Part.PartDescription | Description of the part. |
| Part.TypeCode | Indicates whether the part is manufactured, purchased, or sales kit. |
| PartWhse.WarehouseCode | Warehouse where the inventory is stored. |
| Warehse.Description | Warehouse description. |
| PartWhse.OnHandQty | Current quantity available in the warehouse. |
| PartWhse.MinimumQty | Minimum inventory quantity required for the part. |

## Calculated Field

A calculated field is added to show the shortage quantity.

Field name:

ShortageQty

Formula:

PartWhse.MinimumQty - PartWhse.OnHandQty

## Filter Criteria

The BAQ should only show parts where the on-hand quantity is lower than the minimum quantity.

Suggested condition:

PartWhse.OnHandQty < PartWhse.MinimumQty

This filter removes parts that have enough inventory and keeps only the parts that may require replenishment.

## Sample Result

| Part Number | Description | Type | Warehouse | On Hand Qty | Minimum Qty | Shortage Qty |
|---|---|---|---|---:|---:|---:|
| RM-100 | Steel Sheet 10 mm | Purchased | MAIN | 25 | 100 | 75 |
| RM-250 | Electrical Connector | Purchased | MAIN | 40 | 120 | 80 |
| FG-300 | Control Panel Assembly | Manufactured | FG | 5 | 20 | 15 |

## Business Value

This BAQ provides a clear view of inventory items that are below the required minimum level.

It helps purchasing teams identify parts that may need to be ordered, helps production teams avoid material shortages, and helps inventory teams monitor stock availability.

The main value of this BAQ is that it converts inventory quantity data into actionable information for material planning and replenishment.

## Functional Area

Inventory Management  
Material Planning  
Purchasing Support  
Production Support

## Complexity Level

Intermediate

This BAQ includes warehouse-level inventory analysis, calculated shortage quantities, inventory filters, and material planning logic.

## Skills Demonstrated

### Epicor ERP Knowledge

- Inventory Management
- Warehouse Inventory Control
- Material Planning
- Purchasing Support

### BAQ Development Skills

- Multi-table joins
- Calculated fields
- Inventory quantity analysis
- Query filtering
- Replenishment reporting

### Business Analysis Skills

- Stock shortage identification
- Material availability analysis
- Production support reporting
- Purchasing decision support

### Technical Skills

- Epicor Kinetic BAQ Designer
- ERP inventory reporting
- Data modeling
- Dashboard-ready dataset creation
