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
