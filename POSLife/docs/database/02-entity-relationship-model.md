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















