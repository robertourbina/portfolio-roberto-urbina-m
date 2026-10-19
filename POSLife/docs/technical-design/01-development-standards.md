# POSLife Development Standards

## Project Information

Project Name: POSLife

Project Type: Point of Sale and Inventory Management System for Hardware Stores

Status: Technical Design Phase

Technology Stack:

- Windows Forms .NET 8
- PostgreSQL
- Npgsql
- RDLC Reports
- GitHub

---

# Development Philosophy

POSLife follows the project philosophy:

> "Do not rush, but do not stop."

All business requirements must be approved before implementation.

No development should start without previous technical design.

---

# Database Standards

## Naming Convention

All database objects must use:

```text
snake_case
```

Examples:

```text
products

customers

sales

sale_details

inventory_movements
```

---

## Primary Keys

Primary keys will use:

```text
<table_name>_id
```

Examples:

```text
product_id

customer_id

sale_id

supplier_id
```

---

## Foreign Keys

Foreign keys must use the referenced primary key name.

Examples:

```text
product_id

customer_id

supplier_id

branch_id
```

---

## Audit Columns

Master tables should include:

```text
created_at

created_by

updated_at

updated_by
```

Where applicable.

---

## Status Fields

Use:

```text
status
```

for all entity status fields.

Examples:

```text
ACTIVE

INACTIVE

SUSPENDED

CANCELLED

COMPLETED
```

---

## Soft Delete Policy

Records must never be physically deleted.

Use:

```text
status
```

or

```text
active
```

for logical deletion.

---

# C# Standards

## Naming Convention

Classes:

```text
PascalCase
```

Example:

```csharp
Product

Customer

Sale
```

---

Properties:

```csharp
PascalCase
```

Example:

```csharp
ProductId

Description

SaleDate
```

---

Private Fields:

```csharp
_camelCase
```

Example:

```csharp
_connectionString
```

---

# Architecture

POSLife will use:

```text
Models

Repositories

Services

Forms
```

Structure:

```text
src

├── Models
├── Repositories
├── Services
├── Forms
├── Data
├── Reports
├── Resources
└── Utils
```

---

# Repository Pattern

All database access must be performed through repositories.

Forms must never execute SQL statements directly.

---

# Business Rules

Business logic must be implemented inside Services.

Repositories should only access data.

---

# Source Control

GitHub is the official repository.

Every major milestone must have a commit.

Examples:

```text
POSLife V1 Functional Analysis Frozen

Database Naming Standards

Initial PostgreSQL Schema

Product Module Created
```

---

# Documentation

All design decisions must be documented under:

```text
docs
```

before implementation.


