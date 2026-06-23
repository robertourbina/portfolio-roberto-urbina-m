# BAQ Example: Sales by Date Range with Parameters

## Business Scenario

This BAQ was designed to help sales managers and finance users analyze sales information for a selected date range.

The goal of this query is to allow users to enter a start date and an end date so they can review sales activity for a specific period. This information helps the business analyze monthly sales, quarterly revenue, yearly performance, or any custom date range required by management.

## Business Question

What sales were generated during a selected date range?

## Epicor Tables Used

| Table | Purpose |
|---|---|
| Customer | Stores customer master information. |
| InvcHead | Stores invoice header information, including invoice date and customer number. |
| InvcDtl | Stores invoice line detail information, including part number, quantity, and sales amount. |

## Table Relationships

Customer is related to InvcHead by the customer number.

InvcHead is related to InvcDtl by the invoice number.

The query starts from the invoice header, connects each invoice to its customer, and then connects each invoice to the invoice detail lines.

## Parameters

This BAQ includes two parameters so the user can select the period to analyze.

| Parameter | Data Type | Description |
|---|---|---|
| StartDate | Date | First invoice date to include in the report. |
| EndDate | Date | Last invoice date to include in the report. |

## Selected Fields

| Field | Description |
|---|---|
| Customer.CustID | Customer identification code. |
| Customer.Name | Customer name. |
| InvcHead.InvoiceNum | Invoice number. |
| InvcHead.InvoiceDate | Date when the invoice was created. |
| InvcDtl.PartNum | Part number invoiced to the customer. |
| InvcDtl.LineDesc | Invoice line description. |
| InvcDtl.OurShipQty | Quantity invoiced or shipped. |
| InvcDtl.ExtPrice | Extended sales amount for the invoice line. |

## Calculated Field

A calculated field is added to show the sales amount for each invoice line.

Field name:

SalesAmount

Formula:

InvcDtl.ExtPrice

## Filter Criteria

The BAQ should only show invoices where the invoice date is within the selected date range.

Suggested conditions:

InvcHead.InvoiceDate >= StartDate

InvcHead.InvoiceDate <= EndDate

These filters allow the user to run the same BAQ for different reporting periods without modifying the query design.

## Sample Result

| Customer ID | Customer Name | Invoice Num | Invoice Date | Part Num | Description | Quantity | Sales Amount |
|---|---|---:|---|---|---|---:|---:|
| CUST001 | ABC Manufacturing | 900101 | 2026-01-10 | FG-100 | Control Panel Assembly | 10 | 15000.00 |
| CUST002 | Industrial Parts MX | 900145 | 2026-01-15 | FG-250 | Industrial Cabinet | 5 | 12500.00 |
| CUST003 | North Components | 900188 | 2026-01-22 | FG-300 | Electrical Enclosure | 8 | 18400.00 |

## Business Value

This BAQ provides a flexible way to analyze sales information by date range.

It helps sales managers review sales activity for specific periods, helps finance teams validate revenue information, and helps management compare performance across different time frames.

The main value of this BAQ is that it allows users to generate dynamic sales reports without changing the BAQ structure.

## Functional Area

Sales Management  
Finance Reporting  
Customer Analysis  
Executive Reporting

## Complexity Level

Intermediate

This BAQ includes multiple table relationships, invoice line analysis, parameter-based filtering, and sales reporting logic.

## Skills Demonstrated

### Epicor ERP Knowledge

- Customer Management
- Invoice Processing
- Sales Reporting
- Revenue Analysis

### BAQ Development Skills

- Multi-table joins
- Date parameters
- Parameter-based filtering
- Calculated fields
- Reusable query design

### Business Analysis Skills

- Sales period analysis
- Revenue review
- Customer sales visibility
- Management reporting support

### Technical Skills

- Epicor Kinetic BAQ Designer
- ERP reporting
- Data modeling
- Dashboard-ready dataset creation
