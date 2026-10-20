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

