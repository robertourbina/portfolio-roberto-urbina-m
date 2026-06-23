# BAQ Example: Open Sales Orders

## Business Scenario

This BAQ was designed to help the sales and customer service teams identify open sales orders that still have pending quantities to ship.

The goal of this query is to provide visibility into customer orders, ordered quantities, shipped quantities, and remaining quantities. This information helps the business follow up on pending deliveries, prioritize production or shipping activities, and improve customer service.

## Business Question

Which customer sales orders are still open, and how many units remain to be shipped?

## Epicor Tables Used

| Table | Purpose |
|---|---|
| Customer | Stores customer information. |
| OrderHed | Stores sales order header information. |
| OrderDtl | Stores sales order line detail information. |

## Table Relationships

Customer is related to OrderHed by the customer number.

OrderHed is related to OrderDtl by the sales order number.

The query starts from the sales order header, connects each order to its customer, and then connects each order to its detail lines.

## Selected Fields

| Field | Description |
|---|---|
| Customer.CustID | Customer identification code. |
| Customer.Name | Customer name. |
| OrderHed.OrderNum | Sales order number. |
| OrderHed.OrderDate | Date when the sales order was created. |
| OrderDtl.OrderLine | Sales order line number. |
| OrderDtl.PartNum | Part number ordered by the customer. |
| OrderDtl.LineDesc | Part or line description. |
| OrderDtl.OrderQty | Quantity ordered by the customer. |
| OrderDtl.OurShipQty | Quantity already shipped. |

## Calculated Field

A calculated field is added to show the quantity that is still pending to ship.

Field name:

PendingQty

Formula:

OrderDtl.OrderQty - OrderDtl.OurShipQty

## Filter Criteria

The BAQ should only show sales order lines where the pending quantity is greater than zero.

Suggested condition:

OrderDtl.OrderQty - OrderDtl.OurShipQty > 0

This filter removes fully shipped lines and keeps only open sales order lines.

## Sample Result

| Customer ID | Customer Name | Order Num | Order Date | Line | Part Num | Description | Ordered Qty | Shipped Qty | Pending Qty |
|---|---|---:|---|---:|---|---|---:|---:|---:|
| CUST001 | ABC Manufacturing | 10001 | 2026-01-15 | 1 | FG-100 | Finished Good 100 | 100 | 60 | 40 |
| CUST002 | Industrial Parts MX | 10002 | 2026-01-18 | 1 | FG-250 | Finished Good 250 | 50 | 0 | 50 |
| CUST003 | North Components | 10003 | 2026-01-20 | 2 | FG-300 | Finished Good 300 | 80 | 30 | 50 |

## Business Value

This BAQ provides a clear view of open sales order demand.

It helps customer service teams answer customer questions faster, helps shipping teams identify pending deliveries, and helps production teams understand which parts may require priority attention.

The main value of this BAQ is that it converts sales order data into actionable information for daily operations.

## Skills Demonstrated

- Understanding of Epicor sales order data.
- Use of multiple related ERP tables.
- Creation of calculated fields.
- Filtering records based on business logic.
- Translating a business question into a practical ERP query.
- Supporting customer service, shipping, and production decision-making.
