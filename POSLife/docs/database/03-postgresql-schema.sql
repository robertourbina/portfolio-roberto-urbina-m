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







