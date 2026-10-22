# POSLife Data Dictionary

## Purpose

This document defines all database entities used by POSLife.

Status:

IN PROGRESS

---

# Organization

## branches

Description:

Stores company branches.

Primary Key:

branch_id

Main Fields:

- branch_id
- code
- name
- address
- phone
- status

---

## warehouses

Description:

Stores warehouses for each branch.

Primary Key:

warehouse_id

Main Fields:

- warehouse_id
- branch_id
- code
- name
- status

---

## warehouse_locations

Description:

Stores BIN locations inside warehouses.

Primary Key:

location_id

Main Fields:

- location_id
- warehouse_id
- aisle
- section
- bin
- status

# Security

## roles

Description:

Stores user roles.

Primary Key:

role_id

Main Fields:

- role_id
- code
- name
- description
- status
- created_at
- created_by
- updated_at
- updated_by

---

## users

Description:

Stores system users.

Primary Key:

user_id

Main Fields:

- user_id
- username
- password_hash
- full_name
- email
- phone
- role_id
- branch_id
- status
- last_login_at
- password_last_change_at
- created_at
- created_by
- updated_at
- updated_by

---

## permissions

Description:

Stores system permissions.

Primary Key:

permission_id

Main Fields:

- permission_id
- code
- name
- module
- description
- status

---

## role_permissions

Description:

Assigns permissions to roles.

Primary Key:

role_permission_id

Main Fields:

- role_permission_id
- role_id
- permission_id

---

## user_permissions

Description:

Stores user-specific permission overrides.

Primary Key:

user_permission_id

Main Fields:

- user_permission_id
- user_id
- permission_id
- granted

---

## user_sessions

Description:

Stores user login sessions.

Primary Key:

session_id

Main Fields:

- session_id
- user_id
- login_at
- logout_at
- computer_name
- ip_address

---

## audit_log

Description:

Stores audit information.

Primary Key:

audit_id

Main Fields:

- audit_id
- module
- action
- record_id
- old_values
- new_values
- comments
- user_id
- created_at

## product_lines

Description:

Stores product lines.

Primary Key:

line_id

Main Fields:

- line_id
- code
- name
- description
- status
- created_at
- created_by
- updated_at
- updated_by

## categories

Description:

Stores product categories.

Primary Key:

category_id

Main Fields:

- category_id
- line_id
- code
- name
- description
- status
- created_at
- created_by
- updated_at
- updated_by

## brands

Description:

Stores product brands.

Primary Key:

brand_id

Main Fields:

- brand_id
- code
- name
- description
- status
- created_at
- created_by
- updated_at
- updated_by

## manufacturers

Description:

Stores manufacturers.

Primary Key:

manufacturer_id

Main Fields:

- manufacturer_id
- code
- name
- description
- status
- created_at
- created_by
- updated_at
- updated_by

## units

Description:

Stores units of measure.

Primary Key:

unit_id

Main Fields:

- unit_id
- code
- name
- decimals
- status
- created_at
- created_by
- updated_at
- updated_by

## products

Description:

Stores product master information.

Primary Key:

product_id

Main Fields:

- product_id
- internal_code
- barcode
- description
- short_description
- search_keywords

- line_id
- category_id
- brand_id
- manufacturer_id

- base_unit_id

- tax_id

- status

- weight
- length
- width
- height

- minimum_stock
- reorder_point
- maximum_stock

- image_path

- comments

- created_at
- created_by
- updated_at
- updated_by

## product_units

Description:

Stores product unit conversions.

Primary Key:

product_unit_id

Main Fields:

- product_unit_id
- product_id
- unit_id
- factor
- status

---

## product_barcodes

Description:

Stores multiple barcodes for products.

Primary Key:

barcode_id

Main Fields:

- barcode_id
- product_id
- barcode
- is_default
- status

---

## product_images

Description:

Stores product images.

Primary Key:

product_image_id

Main Fields:

- product_image_id
- product_id
- image_path
- description
- is_primary
- status

---

## price_lists

Description:

Stores sales price lists.

Primary Key:

price_list_id

Main Fields:

- price_list_id
- code
- name
- description
- status

---

## product_prices

Description:

Stores product prices by price list.

Primary Key:

product_price_id

Main Fields:

- product_price_id
- product_id
- product_unit_id
- price_list_id
- price
- minimum_price
- status

---

## product_suppliers

Description:

Stores supplier information for products.

Primary Key:

product_supplier_id

Main Fields:

- product_supplier_id
- product_id
- supplier_id
- supplier_product_code
- last_cost
- lead_time_days
- is_preferred
- status

# Inventory

## product_stock

Description:

Stores current inventory balances.

Primary Key:

stock_id

Main Fields:

- stock_id
- product_id
- warehouse_id
- location_id
- on_hand_quantity
- reserved_quantity
- updated_at

---

## inventory_movements

Description:

Stores inventory transactions (Kardex).

Primary Key:

movement_id

Main Fields:

- movement_id
- product_id
- warehouse_id
- location_id
- movement_date
- movement_type
- quantity
- unit_cost
- reference_type
- reference_id
- comments
- user_id

---

## transfers

Description:

Stores inventory transfers.

Primary Key:

transfer_id

Main Fields:

- transfer_id
- source_warehouse_id
- destination_warehouse_id
- transfer_date
- status
- comments
- user_id

---

## transfer_details

Description:

Stores transfer lines.

Primary Key:

transfer_detail_id

Main Fields:

- transfer_detail_id
- transfer_id
- product_id
- quantity

---

## inventory_counts

Description:

Stores physical inventory counts.

Primary Key:

count_id

Main Fields:

- count_id
- warehouse_id
- count_date
- status
- comments

---

## inventory_count_details

Description:

Stores physical inventory count lines.

Primary Key:

count_detail_id

Main Fields:

- count_detail_id
- count_id
- product_id
- system_quantity
- counted_quantity
- difference

# Customers

## customer_classifications

Description:

Stores customer classifications.

Primary Key:

customer_classification_id

Main Fields:

- customer_classification_id
- code
- name
- description
- status

Examples:

NORMAL

PREFERRED

VIP

STRATEGIC

---

## customers

Description:

Stores customer master information.

Primary Key:

customer_id

Main Fields:

- customer_id
- code
- name
- business_name
- rfc
- phone
- mobile_phone
- email

- customer_classification_id

- price_list_id

- credit_limit
- credit_days

- customer_status

- credit_status

- comments

- created_at
- created_by
- updated_at
- updated_by

---

## customer_contacts

Description:

Stores customer contacts.

Primary Key:

customer_contact_id

Main Fields:

- customer_contact_id
- customer_id
- contact_name
- position
- phone
- mobile_phone
- email
- status

---

## customer_addresses

Description:

Stores customer addresses.

Primary Key:

customer_address_id

Main Fields:

- customer_address_id
- customer_id
- address_type
- address
- city
- state
- zip_code
- status

## customer_account_movements

Description:

Stores customer account statement movements.

Primary Key:

movement_id

Main Fields:

- movement_id
- customer_id
- movement_date
- reference_type
- reference_id
- debit
- credit

---

## customer_payments

Description:

Stores customer payments.

Primary Key:

payment_id

Main Fields:

- payment_id
- customer_id
- payment_date
- total_amount
- payment_method_id
- reference
- comments

---

## customer_payment_applications

Description:

Stores customer payment applications.

Primary Key:

application_id

Main Fields:

- application_id
- payment_id
- sale_id
- applied_amount

---

## customer_collection_actions

Description:

Stores collection activities.

Primary Key:

collection_action_id

Main Fields:

- collection_action_id
- customer_id
- sale_id
- action_date
- action_type
- comments
- next_followup_date
- user_id

# Suppliers

## suppliers

Description:

Stores supplier master information.

Primary Key:

supplier_id

Main Fields:

- supplier_id
- code
- name
- business_name
- rfc
- phone
- mobile_phone
- email

- address
- city
- state
- zip_code

- comments

- status

- created_at
- created_by
- updated_at
- updated_by

---

## supplier_contacts

Description:

Stores supplier contacts.

Primary Key:

supplier_contact_id

Main Fields:

- supplier_contact_id
- supplier_id
- contact_name
- position
- phone
- mobile_phone
- email
- status

---

## supplier_bank_accounts

Description:

Stores supplier bank accounts.

Primary Key:

supplier_bank_account_id

Main Fields:

- supplier_bank_account_id
- supplier_id
- bank_name
- account_number
- clabe
- account_holder
- currency
- is_default
- status

## suppliers

Description:

Stores supplier master information.

Primary Key:

supplier_id

Main Fields:

- supplier_id
- code
- name
- business_name
- rfc
- phone
- mobile_phone
- email

- address
- city
- state
- zip_code

- comments
- status

- created_at
- created_by
- updated_at
- updated_by

---

## supplier_account_movements

Description:

Stores supplier account statement movements.

Primary Key:

movement_id

Main Fields:

- movement_id
- supplier_id
- movement_date
- reference_type
- reference_id
- debit
- credit

---

## supplier_payments

Description:

Stores supplier payments.

Primary Key:

supplier_payment_id

Main Fields:

- supplier_payment_id
- supplier_id
- payment_date
- amount
- reference
- comments

# Sales

## sales

Description:

Stores sales transactions.

Primary Key:

sale_id

Main Fields:

- sale_id
- sale_number

- branch_id
- customer_id

- seller_user_id
- cashier_user_id

- sale_type
- status

- sale_date

- subtotal
- discount_amount
- tax_amount
- total

- comments

- due_date

- delivery_status
- delivery_date
- delivery_comments

- source_sale_id

- created_at
- created_by
- updated_at
- updated_by

## sale_details

Description:

Stores sales lines.

Primary Key:

sale_detail_id

Main Fields:

- sale_detail_id
- sale_id

- product_id

- product_internal_code
- product_barcode
- product_description

- unit_id
- unit_code

- quantity

- unit_price

- discount_percent
- discount_amount

- tax_id
- tax_code
- tax_percent
- tax_amount

- line_total

## sale_statuses

Description:

Stores sales statuses.

Primary Key:

sale_status_id

Main Fields:

- sale_status_id
- code
- name
- description
- status

## sale_payments

Description:

Stores sale payment transactions.

Primary Key:

sale_payment_id

Main Fields:

- sale_payment_id
- sale_id
- payment_method_id
- amount
- reference
- payment_date

---

## sale_status_history

Description:

Stores sales status history.

Primary Key:

history_id

Main Fields:

- history_id
- sale_id
- sale_status_id
- change_date
- user_id
- comments

---

## store_credit_vouchers

Description:

Stores store credit vouchers.

Primary Key:

voucher_id

Main Fields:

- voucher_id
- voucher_number
- customer_id
- issue_date
- expiration_date
- amount
- remaining_amount
- status

## payment_methods

Description:

Stores payment methods.

Primary Key:

payment_method_id

Main Fields:

- payment_method_id
- code
- name
- description
- status

# Purchases

## purchase_statuses

Description:

Stores purchase statuses.

Primary Key:

purchase_status_id

Main Fields:

- purchase_status_id
- code
- name
- description
- status

Examples:

DRAFT

SENT_TO_SUPPLIER

PARTIALLY_RECEIVED

RECEIVED

PAID

CANCELLED

---

## sale_statuses

Description:

Stores sales statuses.

Primary Key:

sale_status_id

Main Fields:

- sale_status_id
- code
- name
- description
- status

## payment_methods

Description:

Stores payment methods.

Primary Key:

payment_method_id

Main Fields:

- payment_method_id
- code
- name
- description
- status


## purchases

Description:

Stores purchases.

Primary Key:

purchase_id

Main Fields:

- purchase_id
- purchase_number
- supplier_id
- warehouse_id

- supplier_invoice_series
- supplier_invoice_number
- supplier_invoice_date

- purchase_status_id

- purchase_date

- subtotal
- tax_amount
- total

- comments

- created_at
- created_by
- updated_at
- updated_by

---

## purchase_details

Description:

Stores purchase lines.

Primary Key:

purchase_detail_id

Main Fields:

- purchase_detail_id
- purchase_id

- product_id

- product_internal_code
- product_description

- quantity

- unit_cost

- tax_percent
- tax_amount

- line_total

## supplier_returns

Description:

Stores supplier returns.

Primary Key:

supplier_return_id

Main Fields:

- supplier_return_id
- supplier_id
- purchase_id
- return_date
- reason
- comments

## purchase_additional_costs

Description:

Stores additional costs associated with purchases.

Primary Key:

purchase_cost_id

Main Fields:

- purchase_cost_id
- purchase_id
- cost_type
- amount
- comments


## purchase_statuses

Description:

Stores purchase statuses.

Primary Key:

purchase_status_id

Main Fields:

- purchase_status_id
- code
- name
- description
- status

## purchases

Description:

Stores purchases.

Primary Key:

purchase_id

Main Fields:

- purchase_id
- purchase_number

- supplier_id

- warehouse_id

- supplier_invoice_series
- supplier_invoice_number
- supplier_invoice_date

- purchase_status_id

- purchase_date

- subtotal
- tax_amount
- total

- comments

- created_at
- created_by
- updated_at
- updated_by

## purchase_details

Description:

Stores purchase lines.

Primary Key:

purchase_detail_id

Main Fields:

- purchase_detail_id
- purchase_id

- product_id

- product_internal_code
- product_description

- quantity

- unit_cost

- tax_percent
- tax_amount

- line_total

## supplier_returns

Description:

Stores supplier returns.

Primary Key:

supplier_return_id

Main Fields:

- supplier_return_id
- supplier_id
- purchase_id
- return_date
- reason
- comments

## purchase_additional_costs

Description:

Stores additional purchase costs.

Primary Key:

purchase_cost_id

Main Fields:

- purchase_cost_id
- purchase_id
- cost_type
- amount
- comments








