# POSLife Entity Relationship Model

## Status

IN PROGRESS

---

# Organization

branches

1 → N warehouses

warehouses

1 → N warehouse_locations

---

# Security

roles

1 → N users

roles

1 → N role_permissions

permissions

1 → N role_permissions

users

1 → N user_permissions

users

1 → N user_sessions

users

1 → N audit_log

# Products

product_lines

1 → N categories

categories

1 → N products

brands

1 → N products

manufacturers

1 → N products

units

1 → N product_units

products

1 → N product_units

products

1 → N product_barcodes

products

1 → N product_images

products

1 → N product_prices

price_lists

1 → N product_prices

products

1 → N product_suppliers

suppliers

1 → N product_suppliers

taxes
    1 → N products

units
    1 → N products

Inventory

products
    1 → N product_stock

warehouses
    1 → N product_stock

warehouse_locations
    1 → N product_stock

products
    1 → N inventory_movements

warehouses
    1 → N inventory_movements

warehouse_locations
    1 → N inventory_movements

transfers
    1 → N transfer_details

products
    1 → N transfer_details

warehouses
    1 → N transfers
(source_warehouse)

warehouses
    1 → N transfers
(destination_warehouse)

inventory_counts
    1 → N inventory_count_details

products
    1 → N inventory_count_details

warehouses
    1 → N inventory_counts


Customers

customer_classifications
    1 → N customers

price_lists
    1 → N customers

customers
    1 → N customer_contacts

customers
    1 → N customer_addresses

customers
    1 → N customer_account_movements

customers
    1 → N customer_payments

customer_payments
    1 → N customer_payment_applications

sales
    1 → N customer_payment_applications

customers
    1 → N customer_collection_actions

sales
    1 → N customer_collection_actions


Suppliers

suppliers
    1 → N supplier_contacts

suppliers
    1 → N supplier_bank_accounts

suppliers
    1 → N supplier_account_movements

suppliers
    1 → N supplier_payments


purchase_statuses
    1 → N purchases

suppliers
    1 → N purchases

warehouses
    1 → N purchases

purchases
    1 → N purchase_details

products
    1 → N purchase_details

purchases
    1 → N purchase_additional_costs

suppliers
    1 → N supplier_returns

purchases
    1 → N supplier_returns


sale_statuses
    1 → N sales

customers
    1 → N sales

branches
    1 → N sales

users
    1 → N sales
(seller)

users
    1 → N sales
(cashier)

sales
    1 → N sale_details

products
    1 → N sale_details

sales
    1 → N sale_payments

payment_methods
    1 → N sale_payments

sales
    1 → N sale_status_history


branches
    1 → N cash_registers

cash_registers
    1 → N cash_sessions

users
    1 → N cash_sessions

cash_sessions
    1 → N cash_movements

cash_movement_types
    1 → N cash_movements

cash_sessions
    1 → N cash_counts

cash_counts
    1 → N cash_count_details

cash_movements
    1 → N bank_deposits















