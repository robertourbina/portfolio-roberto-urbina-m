# POSLife

POSLife is a Point of Sale and Inventory Management system for hardware stores.

## Technology

- Windows Forms .NET 8 (C#)
- PostgreSQL
- Npgsql
- RDLC Reports
- GitHub

## Project Status

The master plan and the current status of every step are maintained in [docs/roadmap.md](docs/roadmap.md).

## Philosophy

"Do not rush, but do not stop."

## V1 Scope

- Products
- Inventory
- Sales
- Purchases
- Customers (credit and collections)
- Cash Management
- Security
- Configuration

The full approved scope is in [docs/functional-scope-v1.md](docs/functional-scope-v1.md).

## Repository Structure

```text
POSLife/
├── docs/
├── database/
├── src/
│   ├── Models/
│   ├── Repositories/
│   ├── Services/
│   ├── Forms/
│   ├── Reports/
│   ├── Resources/
│   ├── Data/
│   └── Utils/
├── backups/
└── README.md
```

## Documentation

All design decisions are documented under `docs/` before implementation.
