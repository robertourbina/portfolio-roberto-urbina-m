# BAQ Example: Customer Sales Growth Comparison

## Business Scenario

This BAQ was designed to help sales managers compare customer sales between two different periods.

The goal of this query is to identify whether each customer increased or decreased their sales compared with a previous period. This information helps the business review customer performance, detect sales growth opportunities, and identify customers that may require follow-up.

## Business Question

Which customers increased or decreased their sales compared with the previous period?

## Epicor Tables Used

| Table | Purpose |
|---|---|
| Customer | Stores customer master information. |
| InvcHead | Stores invoice header information, including customer and invoice date. |
| InvcDtl | Stores invoice line detail information, including sales amount. |

## Table Relationships

Customer is related to InvcHead by the customer number.

InvcHead is related to InvcDtl by the invoice number.

The query summarizes invoice detail amounts by customer and compares sales totals between two reporting periods.

## Subquery Concept

This BAQ can use summarized subqueries to calculate sales by customer for two different periods.

The first summarized query calculates current period sales.

The second summarized query calculates previous period sales.

The main query compares both results by customer.

## Selected Fields

| Field | Description |
|---|---|
| Customer.CustID | Customer identification code. |
| Customer.Name | Customer name. |
| CurrentPeriodSales | Total sales amount for the current period. |
| PreviousPeriodSales | Total sales amount for the previous period. |
| SalesDifference | Difference between current period sales and previous period sales. |
| SalesGrowthPercent | Percentage of growth or decrease between both periods. |

## Calculated Fields

A calculated field is added to show the difference between the current period and the previous period.

Field name:

SalesDifference

Formula:

CurrentPeriodSales - PreviousPeriodSales

A second calculated field is added to show the sales growth percentage.

Field name:

SalesGrowthPercent

Formula:

((CurrentPeriodSales - PreviousPeriodSales) / PreviousPeriodSales) * 100

## Filter Criteria

The BAQ should summarize invoices by customer and include only posted or valid invoice records within the selected date ranges.

Suggested conditions:

Current period invoice date is between CurrentStartDate and CurrentEndDate.

Previous period invoice date is between PreviousStartDate and PreviousEndDate.

These filters allow the user to compare sales performance across two different periods.

## Sample Result

| Customer ID | Customer Name | Current Period Sales | Previous Period Sales | Sales Difference | Growth % |
|---|---|---:|---:|---:|---:|
| CUST001 | ABC Manufacturing | 45000.00 | 38000.00 | 7000.00 | 18.42 |
| CUST002 | Industrial Parts MX | 28000.00 | 35000.00 | -7000.00 | -20.00 |
| CUST003 | North Components | 52000.00 | 50000.00 | 2000.00 | 4.00 |

## Business Value

This BAQ provides a clear view of customer sales growth or decline.

It helps sales managers identify customers with increasing demand, customers with declining sales, and accounts that may require commercial follow-up.

The main value of this BAQ is that it converts invoice history into comparative sales information that supports strategic sales decisions.

## Functional Area

Sales Management  
Customer Analysis  
Finance Reporting  
Executive Reporting

## Complexity Level

Advanced

This BAQ includes summarized subqueries, customer-level aggregation, period comparison logic, calculated differences, and sales growth percentage analysis.

## Skills Demonstrated

### Epicor ERP Knowledge

- Customer Management
- Invoice Processing
- Sales Performance Analysis
- Revenue Reporting

### BAQ Development Skills

- Summarized subqueries
- Aggregated sales calculations
- Period comparison logic
- Calculated fields
- Advanced reporting design

### Business Analysis Skills

- Customer growth analysis
- Revenue trend review
- Sales performance comparison
- Commercial decision support

### Technical Skills

- Epicor Kinetic BAQ Designer
- ERP reporting
- Data modeling
- Dashboard-ready dataset creation
