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

