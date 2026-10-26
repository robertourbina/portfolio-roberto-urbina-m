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
