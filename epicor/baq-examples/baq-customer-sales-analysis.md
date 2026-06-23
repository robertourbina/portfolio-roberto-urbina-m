# BAQ Example: Customer Sales Analysis

## Business Scenario

This BAQ was designed to help sales managers and business leaders analyze customer sales performance.

The goal of this query is to provide visibility into total sales by customer. This information helps the business identify key customers, review revenue concentration, and support commercial decision-making.

## Business Question

Which customers generated the highest sales amount during a selected period?

## Epicor Tables Used

| Table | Purpose |
|---|---|
| Customer | Stores customer master information. |
| InvcHead | Stores invoice header information. |
| InvcDtl | Stores invoice line detail information. |

## Table Relationships

Customer is related to InvcHead by the customer number.

InvcHead is related to InvcDtl by the invoice number.

The query starts from the invoice header, connects each invoice to its customer, and then connects each invoice to its invoice detail lines.

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

A calculated field is added to show the total sales amount by invoice line.

Field name:

SalesAmount

Formula:

InvcDtl.ExtPrice

## Filter Criteria

The BAQ should only show invoices within the selected date range.

Suggested conditions:

InvcHead.InvoiceDate >= StartDate

InvcHead.InvoiceDate <= EndDate

These filters allow the user to analyze customer sales for a specific period, such as one month, one quarter, or one year.

## Sample Result

| Customer ID | Customer Name | Invoice Num | Invoice Date | Part Num | Description | Quantity | Sales Amount |
|---|---|---:|---|---|---|---:|---:|
| CUST001 | ABC Manufacturing | 900101 | 2026-01-10 | FG-100 | Control Panel Assembly | 10 | 15000.00 |
| CUST002 | Industrial Parts MX | 900145 | 2026-01-15 | FG-250 | Industrial Cabinet | 5 | 12500.00 |
| CUST001 | ABC Manufacturing | 900188 | 2026-01-22 | FG-300 | Electrical Enclosure | 8 | 18400.00 |

## Business Value

This BAQ provides a clear view of customer sales activity.

It helps sales managers identify top customers, helps finance teams review revenue by customer, and helps management understand which customers are contributing the most to total sales.

The main value of this BAQ is that it converts invoice detail data into useful sales information for business analysis and decision-making.

## Functional Area

Sales Management  
Customer Analysis  
Finance Reporting  
Executive Reporting

## Complexity Level

Intermediate

This BAQ includes invoice data, customer relationships, date filtering, sales amount analysis, and reporting logic that can be used for dashboards or management reports.

## Skills Demonstrated

### Epicor ERP Knowledge

- Customer Management
- Invoice Processing
- Sales Analysis
- Revenue Reporting

### BAQ Development Skills

- Multi-table joins
- Date filtering
- Invoice line analysis
- Sales amount reporting
- Dashboard-ready query design

### Business Analysis Skills

- Customer sales performance analysis
- Revenue concentration review
- Commercial reporting
- Management decision support

### Technical Skills

- Epicor Kinetic BAQ Designer
- ERP reporting
- Data modeling
- Sales dashboard dataset creation
