# POSLife: Database Design, Foundation Block

| Item | Value |
|---|---|
| Project | POSLife, point of sale for a hardware store in Mexico |
| Document | Database design, Section 2, block 1: Foundation |
| Version | 0.1 (draft) |
| Status | Develop step done, validated against the requirements, waiting for owner review |
| Date | 2026-11-25 |
| Baseline | POSLife-Requirements.md v1.0 (frozen) |
| Level of detail | Tables and key columns. SQL scripts come after the design is approved |

## 1. Decisions applied

| Topic | Decision |
|---|---|
| Primary keys | `bigint` generated always as identity |
| Names | English, `snake_case`, singular table names, primary key column `<table>_id` |
| Audit | Database triggers |
| Business rules | In the application. Database functions only for stock, document sequences and cost |
| Catalogs | Lookup tables with codes, no PostgreSQL enums |
| Attachments | Files on disk, outside the database |

## 2. Conventions

**Constraint and object names**

| Object | Pattern | Example |
|---|---|---|
| Primary key | `pk_<table>` | `pk_product` |
| Foreign key | `fk_<table>_<column>` | `fk_sale_line_product_id` |
| Unique | `uq_<table>_<columns>` | `uq_app_setting_setting_key` |
| Check | `ck_<table>_<rule>` | `ck_tax_rate_dates` |
| Index | `ix_<table>_<columns>` | `ix_audit_log_table_record` |
| Trigger | `trg_<table>_<action>` | `trg_app_setting_audit` |
| Function / view | `fn_<name>` / `vw_<name>` | `fn_next_document_number` |

**Column suffixes:** `_at` timestamps, `_date` dates, `is_` and `has_` booleans, `_amount`, `_price`, `_cost`, `_rate`, `_qty`.

**Standard columns**

| Column | Applies to | Notes |
|---|---|---|
| `branch_id` | Transactional tables | `bigint not null default 1`. No branch logic in the interface |
| `created_at`, `created_by` | All tables | `timestamptz default now()`, user id |
| `updated_at`, `updated_by` | All tables | Set by trigger |
| `row_version` | All tables | Integer increased by trigger on every update, used for optimistic concurrency |
| `is_active` | Catalogs and masters | Records with history are deactivated, never deleted |

**Domains (proposed).** Shared types so precision is defined once:

| Domain | Base type | Used for |
|---|---|---|
| `dom_amount` | `numeric(18,2)` | Totals, payments, balances |
| `dom_unit_price` | `numeric(18,6)` | Unit prices and costs |
| `dom_qty` | `numeric(18,4)` | Quantities |
| `dom_rate` | `numeric(7,4)` | Tax and percentage rates |

**Extensions:** `pg_trgm` (fuzzy search), `unaccent` (accent-insensitive search), `btree_gist` (no overlapping tax rate dates).

**Time.** Everything is `timestamptz`. The store time zone is a setting, used to decide the business day for cuts and reports.

**Comments.** Every table and column gets a `COMMENT ON`, which feeds the P2 data dictionary.

## 3. Schemas

| Schema | Content | Block |
|---|---|---|
| `core` | Company, settings, sequences, catalogs, taxes, calendar, jobs, alerts, errors, attachments, registers | Foundation |
| `security` | Employees, users, roles, permissions, sessions, authorizations | Foundation |
| `audit` | Audit log | Foundation |
| `reporting` | Views and the data dictionary | Last block |
| `catalog`, `inventory`, `customer`, `sales`, `cash`, `sales_order`, `purchase`, `campaign` | Business areas | Later blocks (names confirmed in each block) |

## 4. Tables: `core`

### 4.1 Versioning and environment

| Table | Purpose | Key columns |
|---|---|---|
| `schema_version` | Applied SQL scripts | `schema_version_id`, `script_name`, `checksum`, `applied_at`, `applied_by`, `execution_ms` |

The version required of the registers (ch. 16.6) and the environment flag (production or test, ch. 16.5) are rows in `app_setting`.

### 4.2 Company and branch

| Table | Purpose | Key columns |
|---|---|---|
| `company` | One row: company data and branding | `legal_name`, `trade_name`, `rfc`, `tax_regime_id`, `fiscal_postal_code`, address, phone, email, `logo_attachment_id`, `primary_color`, `secondary_color` |
| `branch` | One row now (`branch_id` 1) | `code`, `name`, address, `is_active` |

### 4.3 Settings

| Table | Purpose | Key columns |
|---|---|---|
| `app_setting` | All system settings (ch. 16.1) | `setting_key` (unique), `value_text`, `value_type`, `category`, `description`, `requires_authorization`, `requires_dual_approval` (prepared, P2) |

The settings change log is the audit log filtered by this table, so there is no separate log table. Settings export and import (P1) work on this table.

### 4.4 Document sequences

| Table | Purpose | Key columns |
|---|---|---|
| `document_type` | Catalog of numbered documents (ch. 18) | `code` (unique), `name`, `area`, `prefix`, `number_length`, `is_active` |
| `document_sequence` | One counter per document type | `document_type_id` (unique), `last_number` |

- **`fn_next_document_number(code)`** adds 1 to the counter row and returns the number. It runs inside the caller's transaction.
- A counter row is used instead of a PostgreSQL `SEQUENCE` on purpose. A sequence skips numbers when a transaction rolls back, while the row update rolls back with it, so numbers stay continuous and are never reused (ch. 4).
- The row lock lasts until the transaction ends, so the application requests the number late in the transaction.
- Each document stores the numeric number and the formatted label at the time of issue, so a later prefix change does not alter history.
- The test database has its own counters (ch. 16.5).
- **Idempotency key** (P1): sales and payments carry a unique request key, defined in their blocks.

### 4.5 Taxes

| Table | Purpose | Key columns |
|---|---|---|
| `tax_profile` | Profiles such as 16%, 0%, exempt | `code`, `name`, `is_exempt`, `is_active` |
| `tax_rate` | Rates with effective dates | `tax_profile_id`, `rate` (`dom_rate`), `effective_from`, `effective_to` (null = open) |

An exclusion constraint prevents overlapping dates for the same profile. Sale lines store their own rate and amounts, so history never changes (ch. 4 rule 7).

### 4.6 Catalogs (one table per catalog, all with `code`, `name`, `is_active`)

| Table | Extra columns |
|---|---|
| `payment_method` | `sat_payment_form_id` (reserved), `is_cash`, `requires_reference`, `opens_drawer` |
| `unit_of_measure` | `sat_unit_id` (reserved), `allows_decimals` |
| `denomination` | `kind` (coin or bill), `value_amount`, `sort_order` |
| `expense_category` | None |
| `reason_type` | Groups reasons: adjustment, write-off, return, cancellation, no sale, cash difference, lost quote |
| `reason` | `reason_type_id`, `requires_note` |
| `sat_product_service`, `sat_unit`, `sat_payment_form`, `sat_tax_regime`, `sat_cfdi_use` | Reserved CFDI catalogs, created now and loaded in Phase 3 |

Status and type catalogs for each area are created in that area's block.

### 4.7 Registers

| Table | Purpose | Key columns |
|---|---|---|
| `terminal` | The 8 registers and the register inventory (ch. 16.7) | `code`, `name`, `host_name`, `is_active`, `app_version`, `last_seen_at` |
| `terminal_config` | Devices per register (ch. 17) | `terminal_id`, ticket printer (name, width 58 or 80 mm, ESC/POS, drawer through printer), report printer, label printer (reserved), `cash_drawer_enabled`, scale (COM port, protocol) |
| `print_route` | Document routing rules (ch. 17.2) | `document_type_id`, `printer_role` (ticket or report), optional `terminal_id` override |

### 4.8 Calendar, jobs, alerts, errors

| Table | Purpose | Key columns |
|---|---|---|
| `store_hours` | Weekly hours | `branch_id`, `weekday`, `opens_at`, `closes_at`, `is_closed` |
| `calendar_holiday` | Holidays and special hours | `holiday_date`, `name`, `is_closed`, `opens_at`, `closes_at` |
| `job_definition` | Scheduled tasks (ch. 16.7) | `code`, `name`, `schedule`, `is_enabled` |
| `job_run` | Run history | `job_definition_id`, `started_at`, `finished_at`, `job_run_status_id`, `message`, `triggered_by` (schedule or manual), `user_id` |
| `alert_definition` | Alert types | `code`, `name`, `severity_id`, `area`, `is_enabled`, `target_role_id` |
| `alert` | Alerts center | `alert_definition_id`, `message`, `reference_table`, `reference_id`, `alert_status_id`, `acknowledged_by`, `acknowledged_at`, `resolved_at` |
| `app_error_log` | Application errors | `occurred_at`, `terminal_id`, `user_id`, `app_version`, `module`, `message`, `stack_trace` |
| `notification_outbox` (P2) | Email and WhatsApp queue | `channel`, `recipient`, `subject`, `body`, `status`, `attempts`, `sent_at` |

Supporting catalogs: `job_run_status`, `alert_severity`, `alert_status`.

### 4.9 Attachments and stored documents

| Table | Purpose | Key columns |
|---|---|---|
| `attachment` | One row per file on disk | `file_name`, `mime_type`, `size_bytes`, `sha256`, `relative_path`, `created_at`, `created_by` |
| `attachment_link` | Links a file to any record | `attachment_id`, `reference_table`, `reference_id`, `link_type` |
| `stored_document` | Official copies (cuts, statements, delivery notes) so the exact original can be reprinted (ch. 14.4) | `document_type_id`, `document_number`, `attachment_id`, `issued_at`, `issued_by` |

The root folder is a setting. The database holds only the relative path and a SHA-256 hash, so the backup job can verify files (ch. 16.3).

## 5. Tables: `security`

| Table | Purpose | Key columns |
|---|---|---|
| `employee_status` | Catalog: Active, Inactive, Blocked | `code`, `name` |
| `employee` | Employee record (ch. 15.1) | `employee_number`, `full_name`, `employee_status_id`, `badge_code` (prepared, P2) |
| `app_user` | Login account (`user` is a reserved word) | `employee_id` (unique), `username`, `role_id`, `pin_hash`, `password_hash`, `failed_attempts`, `locked_until`, `last_login_at`, `must_change_password`, `is_active` |
| `role` | Roles and editable templates | `code`, `name`, `is_system` |
| `permission` | Module and action (view, create, edit, cancel, authorize, export) | `module`, `action`, `code` (unique) |
| `role_permission` | Role template | `role_id`, `permission_id` |
| `user_permission_override` | Per-user grant or deny | `user_id`, `permission_id`, `is_granted`, `expires_at` (prepared, P2 temporary permissions) |
| `limit_type` | Catalog: discount percent, withdrawal amount, adjustment threshold | `code`, `name`, `unit` |
| `role_limit`, `user_limit` | Limits by role, overridden by user | `limit_type_id`, `limit_value` |
| `user_terminal` | Registers allowed for each user | `user_id`, `terminal_id` |
| `user_session` | Logins and register use | `user_id`, `terminal_id`, `started_at`, `ended_at`, `end_reason` |
| `authorization_type` | Catalog of operations needing authorization | `code`, `name`, `requires_admin_only` |
| `authorization_record` | Every authorization (ch. 15.3) | `authorization_number` (global sequence), `authorization_type_id`, `requested_by`, `authorized_by`, `reason`, `reference_table`, `reference_id`, `terminal_id`, `authorized_at`, `is_self_authorized` |
| `sensitive_access_log` | Access to cost, margin and cash reports, exports, and later customer data (ch. 14.2, 15.6) | `user_id`, `access_type`, `object_code`, `terminal_id`, `occurred_at`, `details` |

Rules enforced in the database:

- A partial unique index on `user_session (user_id) where ended_at is null` allows one active login per user (ch. 15.1).
- Hashes are produced by the application with a salted algorithm, and the database never sees a plain PIN or password.
- Assignment rules (supervisors only assign cashier and warehouse permissions) are application rules.
- The permission change log and access review report read the audit log, with no separate table.

## 6. Tables: `audit`

| Table | Purpose | Key columns |
|---|---|---|
| `audit_log` | Immutable change history (ch. 15.4) | `audit_log_id`, `occurred_at`, `table_schema`, `table_name`, `record_id`, `operation` (insert, update, delete), `old_data` (jsonb), `new_data` (jsonb), `changed_columns`, `user_id`, `terminal_id`, `db_user` |

**How it works**

- One generic trigger function, `audit.fn_audit_row()`, is attached to each audited table. It receives a list of columns to exclude, so `pin_hash` and `password_hash` never reach the log.
- The application sets the user and register for each transaction with `set_config('app.user_id', ..., true)` and `set_config('app.terminal_id', ..., true)`. The trigger reads them, so connection pooling cannot mix users.
- Sensitive operational tables are audited. Very high-volume tables such as sale lines are not, because their documents are already immutable.
- **Immutability:** the application role has insert and select only. A trigger also rejects update, delete and truncate. The table owner could still bypass this, which is why the tamper-evident hash chain exists in Phase 3 (prepared: `previous_hash` and `row_hash` columns can be added then).
- **Partitioning:** I propose creating the table partitioned by month from the start (the primary key becomes `audit_log_id` plus `occurred_at`). Phase 2 then only adds the job that creates new partitions, and no table rebuild is needed.

**Foundation tables audited:** `company`, `branch`, `app_setting`, `tax_profile`, `tax_rate`, `document_type`, `payment_method`, `unit_of_measure`, `denomination`, `expense_category`, `reason`, `terminal`, `terminal_config`, `print_route`, `employee`, `app_user`, `role`, `role_permission`, `user_permission_override`, `role_limit`, `user_limit`, `user_terminal`.

## 7. Database roles and privileges

| Role | Use | Rights |
|---|---|---|
| `pos_owner` | Owns the objects | Used only by the migration tool |
| `pos_app` | The registers (limited service account, ch. 15.5) | Read and write on business tables, execute on functions, insert only on `audit_log`, no DDL |
| `pos_report` | Reports and BI | Read-only on `reporting` |
| `pos_admin` | Administrator tool | Applies migrations and manages backups |

Credentials are never stored in plain text, and the connection uses an encrypted channel.

## 8. Validation against the requirements

| Requirement | Covered by |
|---|---|
| Ch. 4 rules 1, 2 | Central database, `branch_id` convention, `branch` |
| Ch. 4 rule 3, ch. 18 | `document_type`, `document_sequence`, `fn_next_document_number` |
| Ch. 4 rules 4, 10 | Stock and cost functions (Inventory block) |
| Ch. 4 rules 6, 7 | `tax_profile`, `tax_rate` |
| Ch. 4 rule 8 | SAT catalogs and reserved columns |
| Ch. 4 rule 9, ch. 15.4 | `audit_log` and triggers |
| Ch. 4 rule 11, ch. 16.5 | Environment flag in `app_setting`, separate database |
| Ch. 4 rule 12, ch. 17 | `terminal`, `terminal_config`, `print_route` |
| Ch. 14.4 (stored copies) | `stored_document`, `attachment` |
| Ch. 15.1 to 15.3 | `employee`, `app_user`, `role`, `permission`, limits, `authorization_record` |
| Ch. 15.5 | Database roles, registers and users per register |
| Ch. 15.6 (P1) | Audit log (permission changes), `user_session`, `sensitive_access_log` |
| Ch. 16.1, 16.7 | `company`, `app_setting`, `store_hours`, `calendar_holiday`, `job_definition`, `job_run`, `alert`, `app_error_log`, `terminal` |
| Ch. 16.3 | `attachment.sha256`, job definitions |
| Ch. 16.6 | `schema_version`, required version setting |

## 9. Open points for review

1. **Catalog structure:** one table per catalog (as drafted, with real foreign keys) or a single generic lookup table.
2. **Roles per user:** one role per user plus overrides (as drafted) or several roles per user.
3. **Attachment folder:** the root folder must be reachable from all 8 registers, normally a shared folder on the computer that hosts the database. To be confirmed in the technical design.
4. **Audit partitioning from the start** (as proposed) or a plain table in Phase 1.
5. **Domains** (`dom_amount` and the others): accept as proposed or use plain `numeric` types.
