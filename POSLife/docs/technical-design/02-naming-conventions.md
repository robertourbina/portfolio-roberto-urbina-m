# POSLife Naming Conventions

## Purpose

This document defines naming conventions for the entire POSLife project.

These conventions must be followed for:

- PostgreSQL database objects
- C# classes
- WinForms controls
- Reports
- Documentation

---

# Database Naming Standards

## Tables

Use:

snake_case

Examples:

products

customers

suppliers

sales

sale_details

inventory_movements

---

## Primary Keys

Format:

<table_name>_id

Examples:

product_id

customer_id

supplier_id

sale_id

purchase_id

---

## Foreign Keys

Use the exact referenced primary key name.

Examples:

product_id

customer_id

supplier_id

branch_id

warehouse_id

---

## Columns

Use:

snake_case

Examples:

created_at

updated_at

sale_date

credit_limit

minimum_stock

---

## Boolean Fields

Prefix with:

is_

Examples:

is_active

is_default

is_system

is_preferred_supplier

---

## Date and Time Fields

Use:

_at for timestamps

Examples:

created_at

updated_at

approved_at

closed_at

Use:

_date for business dates

Examples:

sale_date

purchase_date

delivery_date

---

## Monetary Fields

Use:

numeric(18,2)

Examples:

sale_price

purchase_price

credit_limit

balance

total_amount

---

# C# Naming Standards

## Classes

Use:

PascalCase

Examples:

Product

Customer

Sale

InventoryMovement

---

## Properties

Use:

PascalCase

Examples:

ProductId

Description

SaleDate

CreditLimit

---

## Private Fields

Use:

_camelCase

Examples:

_connectionString

_productRepository

_currentUser

---

## Interfaces

Prefix with:

I

Examples:

IProductRepository

ICustomerService

ISaleService

---

# WinForms Naming Standards

## Forms

Suffix:

Form

Examples:

MainForm

ProductForm

CustomerForm

PointOfSaleForm

---

## Controls

### TextBox

Prefix:

txt

Example:

txtDescription

txtBarcode

---

### Button

Prefix:

btn

Example:

btnSave

btnSearch

---

### Label

Prefix:

lbl

Example:

lblTotal

lblStatus

---

### DataGridView

Prefix:

dgv

Example:

dgvProducts

dgvCustomers

---

### ComboBox

Prefix:

cmb

Example:

cmbCategory

cmbWarehouse

---

# Reports

Suffix:

Report

Examples:

SalesReport

InventoryReport

CustomerBalanceReport

---

# File Naming

Use:

kebab-case

Examples:

functional-scope-v1.md

business-rules.md

entity-relationship-model.md

---

# Versioning

Major.Minor.Build

Examples:

1.0.0

1.1.0

2.0.0

---

# General Rule

Consistency is more important than personal preference.

All developers must follow these conventions.
