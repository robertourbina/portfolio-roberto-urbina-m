/*
===================================================
POSLife PostgreSQL Schema
===================================================

Status:
IN PROGRESS

Phase:
PostgreSQL Physical Design

===================================================
Primary Key Strategy
===================================================

All primary keys use:

BIGSERIAL

Example:

branch_id BIGSERIAL PRIMARY KEY

===================================================
Foreign Key Strategy
===================================================

Foreign keys must use:

<referenced_table>_id

Naming Convention:

fk_<table>_<referenced_table>

Example:

fk_products_categories

===================================================
Index Strategy
===================================================

Naming Convention:

idx_<table>_<column>

Examples:

idx_products_barcode

idx_sales_sale_date

idx_customers_rfc

===================================================
Unique Constraints
===================================================

Naming Convention:

uk_<table>_<column>

Examples:

uk_products_internal_code

uk_product_barcodes_barcode

===================================================
Numeric Strategy
===================================================

Money:

NUMERIC(18,2)

Examples:

prices
totals
payments
credit limits

Quantities:

NUMERIC(18,4)

Examples:

stock
meters
liters
kilograms
conversion factors

===================================================
Date Strategy
===================================================

Use TIMESTAMP for:

created_at
updated_at

Use DATE for:

business dates where time is not required

===================================================
Audit Strategy
===================================================

Standard columns:

created_at
created_by

updated_at
updated_by

===================================================
JSONB Strategy
===================================================

Use JSONB for:

audit_log.old_values

audit_log.new_values

===================================================
Soft Delete Strategy
===================================================

Business records are never physically deleted.

Use:

status

or

active

for logical deletion.

===================================================
POSLife Philosophy
===================================================

"Do not rush, but do not stop."

===================================================
*/

===================================================
Schema Strategy
===================================================

Default Schema:

public

Future schemas may be added for:

audit
integration
reporting


===================================================
Constraint Naming Strategy
===================================================

Primary Keys:

pk_<table>

Examples:

pk_products

pk_customers

Foreign Keys:

fk_<table>_<referenced_table>

Examples:

fk_products_categories

fk_sales_customers

Unique Keys:

uk_<table>_<column>

Examples:

uk_products_internal_code

Check Constraints:

chk_<table>_<rule>

Examples:

chk_products_status


===================================================
Field Standards
===================================================

Status Columns

VARCHAR(30)

Examples:

status

customer_status

credit_status

sale_status

---------------------------------------------------

Code Columns

VARCHAR(50)

Examples:

code

internal_code

customer_code

supplier_code

---------------------------------------------------

Name Columns

VARCHAR(255)

Examples:

name

contact_name

business_name

---------------------------------------------------

Description Columns

VARCHAR(255)

Examples:

description

short_description

---------------------------------------------------

Comments and Notes

TEXT

Examples:

comments

notes

audit_comments

---------------------------------------------------

Barcode Columns

VARCHAR(100)

Examples:

barcode

supplier_barcode

---------------------------------------------------

Money Columns

NUMERIC(18,2)

Examples:

price

amount

subtotal

tax_amount

total

---------------------------------------------------

Quantity Columns

NUMERIC(18,4)

Examples:

quantity

stock

factor

reserved_quantity






