# POSLife: Requirements Specification

| Item | Value |
|---|---|
| Project | POSLife, point of sale for a hardware store in Mexico |
| Document | Requirements specification (Section 1) |
| Version | 1.0 draft, for approval |
| Date | 2026-11-24 |
| Document language | English |
| Application language | Spanish (interface, tickets and reports) |

## Table of contents

1. Purpose and scope
2. Technology
3. Conventions and phases
4. Architecture rules
5. Feature matrix and comparison with SICAR and Eleventa
6. Sales
7. Products
8. Cash
9. Customers
10. Promotions and Campaigns
11. Quotes and Orders
12. Purchases
13. Inventory
14. Reports
15. Security
16. Administration and deployment
17. Equipment and document routing
18. Document numbering
19. Amendments to frozen sections
20. Prepared for the future (off for now)
21. Open technical points and items to verify
22. Out of scope

---

## 1. Purpose and scope

POSLife is a point of sale (POS) and store management system for a hardware store in Mexico. It is modeled on products such as SICAR and Eleventa, evaluating each of their characteristics, adding a personalization for hardware retail, and including extra functions those products do not cover well.

**Operating context**

| Item | Value |
|---|---|
| Locations | One store (no branch logic in the first versions) |
| Registers | 8 |
| Cashiers | 5 |
| Products | About 15,000 items |
| Database | One central PostgreSQL database |
| Currency | Mexican pesos only |
| CFDI 4.0 electronic invoicing | Phase 3; the data is prepared from the start |

**Goals**

- Fast, reliable selling at the register, with hardware-specific needs (fractional quantities, several presentations per product, kits, contractor price tiers, job sites).
- Strong control of cash, prices, discounts and inventory through authorizations and an audit trail.
- A structure that lets the store grow (more branches, invoicing, per-location inventory) without rebuilding the database.

## 2. Technology

| Layer | Choice |
|---|---|
| Application | Windows Forms, .NET 8, C# |
| Database | PostgreSQL |
| Data access | Npgsql |
| Reports | RDLC |
| Source control | GitHub |

## 3. Conventions and phases

| Tag | Meaning |
|---|---|
| **[P1]** | Phase 1: first release |
| **[P2]** | Phase 2: extended release |
| **[P3]** | Phase 3: later release |
| **Prepared** | The data structure and settings exist, but the feature is switched off |

Rules used throughout this document:

- "Supervisor authorization" means the authorizer enters **their own** credentials. Nobody authorizes their own operation, except the administrator (those cases are logged and flagged in a security report).
- "Configurable" means the administrator can change the value in system settings.
- Statements marked as frozen were approved section by section. Later additions to a frozen section are listed in chapter 19.

## 4. Architecture rules

1. **Central database.** All registers connect to one PostgreSQL database through a configured host and port. The database runs on one of the registers at first and later on a dedicated server, so nothing assumes where it lives.
2. **Future branches.** Transactional tables carry `branch_id` with default `1`. There is no branch logic in the user interface.
3. **Global document sequences.** Each document type has one running sequence for the whole store. It never restarts, is generated inside the database transaction, and is never reused. A cancelled document keeps its number with a status. The register is stored as a separate field. A reprint keeps the original number and is marked "COPY".
4. **Stock only through movements.** Stock is never edited directly. Every change is a movement recorded in the kardex.
5. **Completed sales are never deleted.** Corrections go through a sales return.
6. **Prices include tax.** The four product prices are stored with tax included. Net amounts are calculated from the product's tax profile.
7. **Tax rates with effective dates.** A product points to a tax profile (for example 16%, 0%, exempt), and the profile resolves to a rate in a table with effective dates. Every sale line stores the amount without tax, the tax percentage, the tax amount and the total, so history and returns keep the original rate.
8. **Reserved CFDI fields.** RFC, legal name, tax regime, fiscal postal code, CFDI use, SAT product and unit keys, and SAT payment key are reserved from the first version.
9. **Immutable audit log.** Sensitive changes are recorded with who, what, when, register, and before and after values. Entries cannot be edited or deleted.
10. **Cost snapshot.** Each sale keeps the product cost at the time of sale, so historical margins never change.
11. **Separate test environment.** A duplicate database with its own numbering is used for testing updates and training users.
12. **Print routing.** Documents are routed to the ticket printer or the report printer by configurable rules (chapter 17).

## 5. Feature matrix and comparison with SICAR and Eleventa

The "baseline" column describes what is typical of a SICAR- or Eleventa-class POS, from general knowledge. It should be checked against the current editions and trials of both products before this document is frozen as a competitive analysis.

| Module | Baseline capabilities | POSLife additions | Phase |
|---|---|---|---|
| Sales | Fast sales screen, barcode search, discounts, hold and recall, several payment methods, ticket | Decimal quantities, presentations, kits, four price tiers, recorded cash rounding adjustment, quote conversion, repeat sale by customer, job site and PO number, delivery | P1 |
| Products | Code, barcode, department, cost, price, tax, minimum and maximum stock | Multiple barcodes and presentations, tax profiles with effective dates, locations (aisle, shelf, level, bin), On hold status, mass update tool, aliases, services, quantity pricing, history | P1 to P3 |
| Inventory | Stock, adjustments, kardex, low-stock alerts | Reserved and quarantine quantities, cycle count calendar by value, recurring difference flags, product block and recall, repackaging | P1, P2 |
| Cash | Open and close, deposits and withdrawals, cash cut | Blind count, per-employee withdrawal limits, safe drops, petty cash fund, "no sale" log, difference history per cashier | P1 |
| Customers and credit | Customer file, credit limit, payments, statement | Contact person with role, job sites, special prices, overdue-balance blocking, cases, store credit ledger | P1, P2 |
| Loyalty | Points in some editions | Configurable programs with dates, scopes, expiry and minimum redemption | P1 |
| Quotes and orders | Quotes in some editions | Price-locked quotes, stock reservation, back-orders, deposits, layaways, own-fleet delivery tracking | P1, P2 |
| Purchases | Purchase orders, receiving, payables | Barcode receiving, order multiples and minimums, three-way match, quarantine with inspection specs, supplier cases | P1, P2 |
| Campaigns | Basic promotions | Campaign lifecycle with approval, no-stacking rule, below-cost block, analysis against two baselines | P1 to P3 |
| Reports | Sales, inventory, cash reports | Dashboard, drill-down, exception reports, CSV for analysis, scheduled email, user-defined reports | P1 to P3 |
| Security | Users and roles | PIN and password login, own-credential authorizations, tamper-evident audit log, access reviews | P1 to P3 |
| Administration | Backup, configuration | Test environment, version check, jobs center, health panel, migration from other POS | P1, P2 |
| CFDI 4.0 | Invoice, global invoice, cancellation | Prepared fields from the start, invoicing in Phase 3 | P3 |

---
## 6. Sales

**Status: frozen** (with the additions in chapter 19).

### 6.1 Sale flow

- Sales screen with barcode or code search, decimal quantities and a presentation selector.
- **Hold sale (pending)**: any number per register, recalled by number or customer.
- **Repeat sale**: from the last sale or from history, searching by customer, then editing before charging.
- **Quote conversion**: a quote becomes a sale in one action, fully or partially.
- **Customer**: "público en general" is the default, or an identified customer.
- **Seller**: optional and configurable, so the business can sell with counter sellers and cashiers or with cashiers only.
- **Delivery**: a sale can be flagged for delivery, with the address taken from the customer or job site.
- **Stock at zero**: configurable as block, warn, allow, or allow with authorization. With authorization, the administrator authorizes and the product goes on a flagged list for review.
- **Price and stock lookup** without starting a sale.

### 6.2 Statuses

Pending, Completed, Partially returned, Returned, Cancelled. Only a Pending sale can be cancelled.

### 6.3 Kits

- A kit is defined with fixed components, quantities and a **fixed price**.
- The cashier cannot modify the contents.
- The ticket prints the kit and its components.
- Stock is virtual: selling a kit deducts its components. Each sale records that it came from a kit, so kit sales can be reported.
- Returns can be for the whole kit or for individual components.

### 6.4 Prices, discounts and authorizations

- Four price tiers per product. A customer's default tier applies, and if that tier has no price the sale uses tier 1.
- Special customer prices take priority over the tier (chapter 9).
- The cashier cannot change a price. A supervisor can authorize an override, and every override is logged.
- Discounts by line and by ticket, with limits per role.
- Voiding a line requires authorization.
- Credit sales follow the credit rules in chapter 9.

### 6.5 Payments

- Methods: cash, card, transfer, check, customer credit, store credit, and mixed payments.
- Card payments store only the reference or last four digits, never the full number.
- The SAT payment key is reserved for CFDI.

### 6.6 Rounding (option B)

- The sale total is **never rounded**, because CFDI needs the exact amount.
- For cash, the cashier enters the amount received. The difference from the exact total is recorded as a **rounding adjustment** linked to the sale, so the cash cut balances.
- The administrator can turn rounding on or off and choose the mode (up, down, nearest).

### 6.7 Returns

- Linked to the original sale, with a reason and supervisor authorization.
- Each item goes back to stock or is written off as damaged.
- The customer receives a refund (cash or original method) or store credit.
- A cash refund appears in the cash cut.
- Points earned on the sale are reversed (chapter 9).
- A returned promoted item refunds the price actually paid (chapter 10).

### 6.8 Tickets

Reprints are marked "COPY" and logged.

### 6.9 Documents and numbering

Sales ticket, sales return, held sale reference.

---

## 7. Products

**Status: frozen** (with the addition in chapter 19).

### 7.1 Identification and classification

- A **consecutive internal code**, independent of any barcode.
- Several barcodes per presentation: manufacturer barcodes as they are, and internally generated barcodes (from the internal code) for products without one, with label printing.
- Supplier part number, description and brand.
- Department, category and subcategory.

### 7.2 Presentations and prices

- One **base unit** per product (inventory is counted in this unit) and several **presentations**, such as piece, bag or box.
- Each presentation has a conversion factor, its own barcode and **four prices with tax included**.
- Example: washers are counted in pieces, and a bag of one kilogram is a presentation with an approximate conversion factor.
- **Price tier 1 is mandatory.** If a customer's tier has no price, tier 1 applies.
- Kits: components, quantities and fixed price.

### 7.3 Cost

- The cost method is chosen at system start (average, last purchase, or both visible with one used for margins) and can only be changed with authorization.
- Margin is shown for each price, calculated on the net price.

### 7.4 Tax

A tax profile per product (16%, 0%, exempt), resolved through the rates table with effective dates. SAT product and unit keys are reserved for CFDI.

### 7.5 Stock control

Minimum, maximum and reorder point. Product type: stocked item, kit or service.

### 7.6 Locations

- A product can have several locations, for example **sales floor** and **back warehouse**.
- Each location has aisle, shelf, level and bin, kept in a locations catalog.
- Inventory per location and transfers between them are prepared for the future.

### 7.7 Status

- Active, Inactive, **On hold** (not sellable).
- To activate a product it needs a unit and presentation, a price (tier 1), a tax profile and a cost.
- Imported products start On hold.
- Products with history are never deleted.

### 7.8 Other capabilities

- **Receiving inspection specs**: one check per line, shown when the product is received (chapter 12).
- Equivalents and substitutes, shelf and barcode labels.
- **Mass update tool** (Epicor-style): select products by filter or Excel file, choose which fields to change from a list the administrator configures, apply by value, percentage or amount, preview old and new values, authorize, and undo a whole batch.

### 7.9 Phases

| Phase | Characteristics |
|---|---|
| P1 | Search aliases (several names per product), product type including services, decimal rules per presentation, quantity-based pricing, price and cost history, several suppliers per product, non-returnable flag |
| P2 | Technical attributes and variants, discontinued flag, special-order flag, minimum price floor |
| P3 | Lot and expiration, serial numbers and warranty, landed cost |

### 7.10 Documents and numbering

Internal product code (consecutive) and internal barcode.

---

## 8. Cash

**Status: frozen.** Pesos only.

### 8.1 Sessions

- Opening amount entered when the session opens, and the cashier **confirms the opening count**.
- One open session per register and per cashier at a time.
- Shift handover on the same register: close one cashier, open the next.
- A closed session cannot be reopened. Corrections go through a supervisor with an audit trail.

### 8.2 Cash movements

- **Withdrawals and expenses**: the administrator configures which employees can make them and the maximum amount for each. Above that amount a supervisor must authorize. Expenses carry a category, a note and a receipt.
- **Deposits** of extra change into the drawer.
- **Safe drops**: an alert when the drawer exceeds a limit set by the administrator, and a recorded transfer to the safe.
- **Cash refunds** from returns flow into the cut.
- **"No sale" drawer openings** require a reason and are logged.
- Supplier payments in cash from a register create the matching movement automatically, using these same rules (chapter 12).

### 8.3 Petty cash fund

A store-level fund separate from the registers, with its own balance. Expenses are charged to it with category and receipt. Funding and replenishment are recorded movements, and the fund has its own count.

### 8.4 Cash cut

- **Partial cut (X)** without closing, and **final cut (Z)** that closes the session.
- **Blind count by denomination** (the denomination list is configurable): the cashier counts first, then the system shows the expected amount and the difference.
- Totals by payment method, plus returns, cancellations, discounts, withdrawals, expenses and rounding adjustments.
- A difference above the configured threshold requires a note and supervisor authorization.
- **Difference history per cashier**: overages and shortages over time.
- Summary on the ticket printer and detailed report on the report printer.

### 8.5 End of day

Consolidated closing of all registers, with the bank deposit recorded. A backup runs before each final cut.

### 8.6 Phase 2

Card batch reconciliation (card terminal totals compared with card sales).

### 8.7 Documents and numbering

Cash session, withdrawal receipt, expense receipt, deposit, safe drop, X cut, Z cut, petty cash movement, daily closing.

---
## 9. Customers

**Status: frozen** (with the additions in chapter 19).

### 9.1 Customer file

- Customer number from the global sequence, name or business name, type (retail, contractor, company), and status: Active, Inactive, Blocked.
- **Blocking requires a comment**, and records the date and user. Unblocking is recorded the same way. Every status change stays in the history.
- **One contact person with their role**, plus phone and email.
- Several delivery addresses, and notes.
- Fiscal data reserved for Phase 3: RFC, legal name, tax regime, fiscal postal code, CFDI use.
- Search by name, phone, RFC or contact. Duplicate detection and merge. Privacy notice consent recorded.
- "Público en general" remains the default customer on every sale.

### 9.2 Pricing

Default price tier (1 to 4), plus **special prices per customer** for specific products, which take priority over the tier.

### 9.3 Credit and accounts receivable

- Credit limit and credit days per customer.
- A credit sale is **blocked** when it would exceed the limit **or** the customer has overdue balances. A supervisor can authorize an exception.
- Payments on account are applied to specific sales or to the oldest first, with a receipt.
- Customer statement and aging report (current, 30, 60 and 90 days).
- Credit limit changes are logged with who authorized them and why.

### 9.4 Store credit

A balance ledger from returns, usable in later sales. Every movement is recorded.

### 9.5 Loyalty program (registered customers only)

Configured per program in settings:

- **Earning**: start and end dates for seasonal promotions, scope (all products, categories or specific products), and points by amount spent.
- **Expiration**: points expire according to the program's rule.
- **Redemption**: usable on defined products, defined categories or all products, with a **minimum number of points**. The value of a point and the form of redemption (discount or store credit) are program settings.
- A ledger records every movement, and a return reverses the points it earned.
- **P2**: redemption at partner businesses (vouchers or codes).

### 9.6 Job sites (contractors)

- Several per customer: name, address, status (Active or Closed) and an optional contact.
- Sales and deliveries carry the job site reference, and deliveries use its address.
- Reports of sales and deliveries per job site.

### 9.7 History

Purchases per customer and per job site, with products, totals and payments.

### 9.8 Phases

| Phase | Capabilities |
|---|---|
| P1 | Customer summary at the register (balance, available credit, overdue amount, last purchase, average ticket), customer alerts shown when the customer is selected, credit limit history, segments or tags, personal data requests (export or anonymize; customers with history are anonymized, not deleted) |
| P2 | **Cases** (below), sending statements and receipts by email or WhatsApp (channels decided at design time), PO number on sales for customers that require it, import of customers from Excel |
| P3 | Birthdays and marketing consent. Interest on overdue balances is prepared but off |

**Cases (P2).** A case is a tracked item linked to a customer, with a case number from the global sequence, type, priority, assigned user, due date, status (Open, In progress, Resolved, Closed), a log of notes and calls, and links to related documents.

Case types: collections follow-up (promised payment dates and reminders), complaint, delivery issue, warranty or return follow-up, quote follow-up, general inquiry, and **product request**. A product request also records the requested product, quantity and customer, a list of suppliers consulted (cost, lead time, minimum order, response date), and the outcome (product created, special order, or declined with a reason). A created product starts On hold. Requests for the same product are grouped to show demand.

Not included: authorized buyers (several people charging to one company account) and a credit approval workflow; the customer keeps only the credit amount granted.

### 9.9 Documents and numbering

Customer number, payment receipt, customer statement, store credit note, case number.

---

## 10. Promotions and Campaigns

**Status: frozen.**

### 10.1 Campaign definition

- Campaign number from the global sequence, name, start and end dates, and creator.
- Statuses: Draft, Scheduled, Active, **Paused**, Ended, Cancelled.
- A **supervisor must set a campaign to Active**, and every status change is logged.
- **Clone** an existing campaign. Set **goals** (units, revenue or margin) to compare with results.

### 10.2 Promotion types

Percentage discount, fixed price, buy X get Y, quantity-based discount, free item with purchase, kit or bundle price, and points multiplier (using the loyalty program).

### 10.3 Scope and eligibility

- Included products: by product, category, department, brand or saved list, with exclusions.
- Who qualifies: all customers, a price tier, a customer segment, or loyalty members only.
- Limits: maximum units per campaign or per customer, days and hours, and **automatic end** when the unit limit is reached.

### 10.4 Rules

- **Best price for the customer, no stacking.** Campaigns, price tiers, special customer prices and manual discounts are not cumulative.
- **Selling below cost is blocked**, checked at activation and at the register.
- **Cost-change safeguard**: if a new purchase raises a product's cost above its campaign price, the campaign is suspended for that product and the supervisor is alerted.
- **Returns**: a returned promoted item refunds the price actually paid and reverses earned points. For "buy X get Y" and bundles, the refund is adjusted so the customer cannot keep the free item.

### 10.5 At the register

Each line shows the campaign applied and the amount saved, and the ticket shows total savings. Each sale line carries a campaign reference.

### 10.6 Analysis

- Compared with **both baselines**: the period just before the campaign and the same dates last year.
- Units, revenue, margin, discount cost, average ticket, new customers, effect on stock, top products, and result against the goal.
- An RDLC report, with a note that results show association and do not prove cause.

### 10.7 Phases

| Phase | Capabilities |
|---|---|
| P2 | Coupons and promo codes, clearance suggestions from slow-moving or overstocked items, campaign calendar, post-campaign effect comparison |
| P3 | Supplier-funded promotions, announcements by email or WhatsApp to customer segments that gave marketing consent |

### 10.8 Documents and numbering

Campaign number, coupon codes, campaign result report.

---

## 11. Quotes and Orders

**Status: frozen.**

### 11.1 Quotes

- Quote number from the global sequence, customer or prospect without a file, job site, and the user who prepared it.
- **Valid one week by default; a supervisor can extend it.** Prices are **locked** until it expires.
- Lines with products, presentations and kits, at the customer's tier, special prices and active campaigns, with discounts within role limits.
- Notes and conditions, printing on the report printer, sending by email.
- Revision history, alternatives (substitutes and equivalents), and partial conversion to a sale.
- Statuses: Open, Converted, Expired, Rejected. Rejected or expired quotes record a **lost reason**, with a conversion report.
- **Follow-up reminders** before expiry, linked to the quote follow-up case type.

### 11.2 Orders

- Statuses: Draft, Confirmed, Partially fulfilled, Fulfilled, Cancelled.
- **Stock is reserved** until the promised date plus a grace period, with an alert before release.
- Back-orders and partial fulfillment.
- A **pick list sorted by location** (aisle, shelf, level, bin), printed on the report printer.
- Customer pickup with a "ready for pickup" status and the name of the authorized person.
- **P2**: lines without stock generate a purchase requirement, and the back-order is released when goods arrive.

### 11.3 Deposits and layaways

- Deposit receipts, held as a balance in favor of the customer and applied to the final sale.
- Layaways with a time limit, released automatically when it expires.
- Cancellations follow a **configurable refund rule**: cash or store credit, percentage retained, and exceptions such as special orders.

### 11.4 Delivery

- Statuses: Pending, Prepared, On route, Delivered, Failed or returned.
- Catalogs of **the store's own drivers and vehicles**, delivery lists per driver and per day, and the address taken from the customer or job site.
- Delivery fees configurable by zone or order amount, sold as a service item.
- Proof of delivery by signature or name on the delivery note.
- The dispatcher decides vehicle loads (no weight or dimension checks).
- **P2**: driver license and vehicle insurance or inspection alerts, and failed-delivery rescheduling with a reason and attempt count.
- **Prepared, off for now**: payment on delivery (fields for amount to collect and who collected), route planning (stop order, distance) and delivery cost tracking.

### 11.5 Documents and numbering

Quote, order, deposit receipt, layaway agreement, delivery note, pick list.

---
## 12. Purchases

**Status: frozen** (with the addition in chapter 19). Pesos only.

### 12.1 Suppliers

- Supplier number from the global sequence, RFC, one contact person with role, addresses, credit days and limit, lead time.
- Status: Active, Inactive, Blocked (blocking requires a comment, with date and user).
- A setting per supplier: **allows receiving without a purchase order**.
- Each supplier lists its products with part number, cost, **order multiples** and **minimum order amount**.
- **One-time supplier [P1]**: a quick record for an urgent purchase from a store you do not normally buy from, convertible later into a full supplier.

### 12.2 Requirements and purchase orders

- Suggested reorder from minimum stock and reorder point, rounded to the supplier's multiples.
- Purchase order statuses: Draft, Approved, Sent, Partially received, Received, Cancelled.
- **Duplicate a previous order** as a starting point. Print on the report printer and send by email.
- **Late delivery alerts**: orders past their expected date are flagged with the supplier and pending lines.
- Approval above an amount threshold is **prepared but off**.

### 12.3 Receiving

- By **barcode scan**, against a purchase order (full or partial), or direct for suppliers marked as allowed.
- Supplier document number and date. Differences are recorded (short, over, damaged).
- Cost updates by the chosen cost method, with an alert when the new cost differs from the last one.
- **Margin alert**: when a new cost drops a product's margin below a threshold, the affected products are listed for repricing.
- Location assigned on receiving, and back-orders released with notification.
- **Inspection specs [P2]**: when a product has receiving inspection specs, the screen shows them and the receiver marks each line **Accepted** or **Quarantine**, with a note.
- **Quarantine [P2]**: units are not available for sale. A review releases them to available stock, returns them to the supplier (creating a supplier return), or writes them off. A supplier case can be opened for the claim.

### 12.4 Supplier price lists

Updated from a configurable Excel file with a grid where you select which fields change. It uses the same tool as the product mass update: column mapping, preview, authorization and undo by batch.

### 12.5 Payables and payments

- Supplier invoices with due dates from the credit days.
- Payments by **bank transfer, cash or petty cash fund**. A cash payment from a register, or a payment from the petty cash fund, creates the matching Cash movement automatically, so the employee limits and authorizations in chapter 8 apply.
- Aging report, supplier statement and payment calendar.
- **Returns to supplier** with credit note or replacement.

### 12.6 Phases

| Phase | Capabilities |
|---|---|
| P1 | Everything above except the items tagged P2, plus supplier performance report and purchases by period |
| P2 | Orders without stock and approved product request cases feed the requirements. Supplier advances applied to later invoices. **Supplier cases** (delivery issue, warranty claim, price dispute, quality issue, general inquiry). **Suggested quantities from sales history** (demand over a configurable window, lead time and safety stock, less stock on hand and on order, rounded to multiples). Calendar of expected deliveries with late ones highlighted. Quarantine with inspection specs. **Three-way match** of order, receipt and supplier invoice. Price comparison between suppliers |
| P3 | Landed cost (freight and import costs), reading supplier CFDI XML files |
| Prepared | Purchase order approval, early-payment discounts, attachments for supplier documents |

### 12.7 Documents and numbering

Supplier number, purchase requirement, purchase order, goods receipt, supplier return, supplier payment.

---

## 13. Inventory

**Status: frozen.**

### 13.1 Stock and movements

- **Kardex** per product: date, document, user, quantity in and out, balance and cost.
- Quantities shown as **on hand, in quarantine, reserved and available**, by presentation and base unit. Kits show availability from their components.
- Movement types: sale, return, purchase receipt, supplier return, adjustment, quarantine release, write-off, repackaging, and initial load.

### 13.2 Adjustments and write-offs

- A reason is required (damage, theft, expiry, counting error).
- An adjustment needs supervisor authorization when its value **exceeds the cost of 3 units** of the product. The threshold is configurable and this is the default.
- Write-offs are reported by reason and by value.
- Sales at zero stock follow the setting in chapter 6. With "allow with authorization", the product goes on a flagged list for review at the next receiving or count.

### 13.3 Opening inventory load [P1]

Import starting quantities and costs from Excel with validation, plus a go-live cutover procedure.

### 13.4 Physical counts [P1]

- **Cycle count calendar**: products ranked by value, with the highest-cost counted most often, plus a **full yearly count**.
- Count sheets by location, assigned to employees, counted blind with a barcode scanner.
- Differences are reviewed, and after authorization they **adjust the stock**.
- **Recurring differences flag**: products or zones that keep showing differences are highlighted for investigation.

### 13.5 Valuation, alerts and traceability

- Valuation: current inventory value by cost method, by department, category or supplier. Past dates can be reconstructed later from the kardex.
- Alerts and analysis: low stock, overstock, slow movers, ABC analysis and stock coverage in days.
- Traceability: all movements and documents for a product, and where it was sold.

### 13.6 Phase 2

- **Min and max suggestions screen**: from sales history, you select which products to change and the system applies only those.
- **Product block and recall**: block a product from sale immediately (On hold) and list the customers who bought it.
- **Location barcodes**: print shelf and bin labels and count by scanning the location, then the products.
- **Repackaging**: break bulk into packaged products with their own codes, consuming the source stock and allocating its cost.

### 13.7 Prepared, off for now

Inventory per location with transfers, valuation by past date through snapshots, lot and expiration, serial numbers.

### 13.8 Documents and numbering

Adjustment, write-off, count sheet, count result, repackaging, block and recall notice.

---

## 14. Reports

**Status: frozen** (reopened and re-approved with additions).

### 14.1 Catalog (starting point, adjustable as users need)

- **Sales**: tickets and copies, sales by period, product, department, cashier, seller, customer and job site, returns, discounts, kit sales.
- **Cash**: X and Z cuts, withdrawals and expenses by category, petty cash, difference history per cashier.
- **Products**: price and cost history, margin by product, labels.
- **Customers**: statements, aging, purchase history, loyalty ledger, job site reports, cases.
- **Campaigns**: campaign result report with both baselines.
- **Quotes and orders**: quote conversion and lost reasons, pick list, delivery lists, delivery notes, deposit receipts.
- **Purchases**: supplier performance, purchases by period, payables aging, payment calendar, price comparison.
- **Inventory**: kardex, valuation, ABC, slow movers, coverage, write-offs by reason, flagged zero-stock sales, recurring differences, count results.

### 14.2 How reports work

- Filters on every report, with a preview before printing.
- Printing follows the routing in chapter 17.
- Export to **PDF, Excel and CSV**. CSV files use consistent column names and UTF-8 encoding, for analysis in Python or R.
- Access by role (chapter 15). Reports are in Spanish with Mexican number and date formats.
- Access to sensitive reports (cost, margin, cash) is logged.

### 14.3 Dashboard and alerts

An owner's start screen with widgets each user can choose (today's sales and margin, cash status, low stock, overdue receivables, late deliveries, expiring quotes, open cases), and an alerts center that gathers what every section flags.

### 14.4 Phases

| Phase | Capabilities |
|---|---|
| P1 | Drill-down from dashboard numbers to documents, charts, **stored copies of official documents** (cash cuts, statements, delivery notes) so the exact original can be reprinted, tax summary by rate (16%, 0%, exempt), price lists by tier, exception reports (products without cost or price, duplicate barcodes, customers without a contact, quotes without follow-up, unusual cancellations or returns by cashier) |
| P2 | Reporting views and a data dictionary for Power BI, Excel, Python or R, saved report favorites, **automatic email sending** configured by the user, sales targets compared with actual results, cross-tab reports, cashier performance and loss prevention, sales by hour and weekday, profitability by department, customer and job site, delivery indicators, inventory turnover and days of stock |
| P3 | User-defined report and query tool (similar to Epicor BAQs), customer analysis (top customers, customers who stopped buying, segmentation by recency, frequency and amount), basket analysis, cash flow projection |

### 14.5 Documents and numbering

Reports do not use folios. Printed cuts, receipts and delivery notes keep the numbers defined in their chapters.

---
## 15. Security

**Status: frozen.**

### 15.1 Users and login

- Employee record: number, name, role, status (Active, Inactive, Blocked) and user account. Users are deactivated, never deleted.
- **Cashiers log in with a PIN.** Supervisors, administrators and every other role use a **full password**. Passwords are stored as salted hashes and cannot be read.
- Quick user switch at the register, automatic lock after inactivity, lockout after failed attempts.
- A user cannot be logged in on two registers at once.

### 15.2 Roles and permissions

- Roles: administrator, supervisor, cashier, warehouse, owner, purchasing, dispatcher, with editable role templates.
- A permission matrix by module and action (view, create, edit, cancel, authorize, export), with role templates and overrides per user.
- Limits per role or user: discount percentage, withdrawal amount, adjustment threshold.
- **Cost and margin visibility**: administrator, owner and purchasing only.
- **Who assigns permissions**: administrators assign anything. Supervisors can assign only cashier and warehouse permissions, and cannot grant anything they do not hold themselves.

### 15.3 Authorizations

- The authorizer enters their **own** credentials. Each authorization records who, what, why and when.
- Nobody authorizes their own operation, except the administrator. Those cases are logged and appear in a security report.
- Authorizers have their own limits. An authorization report is included.
- Operations that need authorization are listed throughout this document (price override, discounts above limits, voiding lines, returns, withdrawals above limits, cash differences, credit exceptions, adjustments above the threshold, campaign activation, quote validity extension, mass updates, product blocks, cost method changes). Selling at zero stock, when allowed with authorization, is authorized by the administrator.

### 15.4 Audit log

Who, what, when and from which register, with before and after values on sensitive fields. It cannot be edited or deleted, and it has filters and CSV export.

### 15.5 Registers and data protection

- The 8 registers are registered in the system, with the users allowed on each.
- The database connection uses a limited service account, with credentials never stored in plain text. Encrypted connection to PostgreSQL, and backups protected by permission.
- An **emergency access** procedure lets an administrator recover if the only administrator is locked out.

### 15.6 Phases

| Phase | Capabilities |
|---|---|
| P1 | Permission change log, access review report, offboarding in one action (deactivate the user, close open sessions, flag the ID badge), security alerts (failed logins, an administrator authorizing their own operation, after-hours access, large exports), export controls with a log |
| P2 | Login by **ID badge barcode**, password expiry rules, login history report, second verification step for administrators, **temporary permissions** that expire automatically, **dual approval** for critical settings (cost method, authorization thresholds, user permissions), login hours for cashiers, customer data masking by role with a log of who viewed sensitive data |
| P3 | **Tamper-evident audit log**: entries are chained so any alteration can be detected, including changes made directly in the database |

### 15.7 Documents and numbering

Authorization record numbers.

---

## 16. Administration and deployment

**Status: frozen** (with the addition in chapter 19).

### 16.1 System settings

One administration area with a change log:

- Company data, ticket formats and legends, report templates, printers and routing, hardware tests.
- Tax rates with effective dates, cost method, rounding mode, behavior at zero stock, document numbering, thresholds, loyalty settings, and the store's email account.
- **Branding**: logo, application icon and institutional colors for some screens, tickets and report headers, with a preview. For thermal tickets the logo is converted to black and white.
- The interface is in Spanish.

### 16.2 Setup and migration

- A first-run wizard for each register, with hardware tests and a **prerequisites check** (.NET 8 runtime, printer drivers).
- Guided setup for an **empty business**: company data, taxes, departments, price tiers, users and registers.
- Excel imports for a **previous POS**: products (starting On hold), customers, suppliers, opening balances and opening inventory, each with validation, a trial run, an error report and a preview.

### 16.3 Backup and recovery

- A daily automatic backup after the final cut (and one before each cut), keeping 30 daily and 12 monthly. The destination is configurable, and the default is the same disk as the database.
- The administration screen **warns while the backup destination is the same disk** as the database and reminds monthly to keep a copy elsewhere (external drive, another computer or cloud).
- **Backup verification**: the system checks each file and alerts if it failed or the disk is nearly full.
- Backups **include attachments and stored documents**, not only database data.
- A documented, periodically tested restore procedure and a **server failure plan**: UPS power, restore steps, and what the registers do while the database is down.

### 16.4 Database location

The database runs on a register at first and later on a dedicated server. A documented procedure moves it: backup, restore, change the connection, verify. UPS power is recommended for the computer that hosts the database, which should stay on during store hours.

### 16.5 Test and training environment

A separate duplicate database, like Epicor's sandbox. It can be copied from production on demand or filled with sample data. It is used to try updates before installing them in the store and to train users. It shows an unmistakable banner and color, has its own numbering, never sends real emails, and marks printed documents as test. Access is by permission.

### 16.6 Deployment and updates

- An installer for the registers and the server, and a versioning scheme.
- **Manual installation** on each register, for control.
- **Version check against the database (required)**: the database stores the current system version. A register older than the required version shows "update required" and blocks sales until updated.
- **Optional release notice**: the administrator screen can look at the GitHub Releases page and show that a new version is available, with release notes. It only informs, needs internet access, and can be switched off.
- Database changes are applied by an administrator tool that takes a backup first and has a rollback path. Updates are tested first in the test environment.
- **Maintenance mode** blocks new logins with a message while an update runs.

### 16.7 Phase 1 additions

- **Background jobs center**: every scheduled task (backups, quote expiry, order and layaway release, loyalty points expiry, campaign auto-end, scheduled reports, count scheduling) with last run, result, manual run and failure alerts.
- **Business calendar** with store hours and holidays.
- **System health panel**: database size, last backup, free disk space, open sessions and pending alerts.
- **Register inventory**: the 8 registers with program version, last connection and device status.
- **Settings export and import**.
- Application error log, in-app help, alerts configuration, and customer privacy settings (notice text, consent, retention rules, personal data requests). The wording should be reviewed by a legal advisor.

### 16.8 Phase 2

- **Promote settings from test to production**, comparing both environments.
- **Post-outage capture**: enter the sales made on paper after a server failure, with their original time and paper ticket number (the sale origin is "captured after an outage").
- **Register interface options**: font size, a touch-friendly mode, configurable keyboard shortcuts.
- **Administrator runbook and cashier quick guide** as printable documents.
- Routine database maintenance, log retention rules, performance monitoring.

### 16.9 Phase 3

Accounting export together with CFDI, archiving of old data, and an offline mode for the registers.

### 16.10 For the GitHub portfolio

A sample data generator (the same one that fills the test environment) and documentation of the database and setup steps, so the project can be shown without real store data.

---

## 17. Equipment and document routing

### 17.1 Equipment per register

A `terminal_config` table stores each register's settings.

| Device | Configuration |
|---|---|
| Barcode scanner | Keyboard-type scanner, no special setup |
| **Ticket printer** | Thermal, 58 or 80 mm, ESC/POS; optionally opens the cash drawer through the printer |
| **Report printer** | Letter or A4 laser or inkjet for RDLC reports; can be a **shared network printer** used by all registers |
| Label printer | Optional third role for shelf and barcode labels (reserved) |
| Cash drawer | Enabled or disabled |
| Scale | Optional, COM port and protocol |

### 17.2 Document routing (configurable defaults)

| Printer | Documents |
|---|---|
| Ticket printer | Tickets, copies, cash cut, withdrawal receipts |
| Report printer | Reports, quotes, delivery notes, customer statements |

---

## 18. Document numbering

Rules are in chapter 4 (global sequences, continuous, never reused, generated inside the transaction, cancelled documents keep their number, register stored separately, reprints marked "COPY"). Prefix and length are configurable. CFDI will have its own fiscal series and folios in Phase 3, separate from these.

| Area | Documents |
|---|---|
| Sales | Sales ticket, sales return, held sale reference |
| Products | Internal product code, internal barcode |
| Cash | Cash session, withdrawal receipt, expense receipt, deposit, safe drop, X cut, Z cut, petty cash movement, daily closing |
| Customers | Customer number, payment receipt, customer statement, store credit note, case number |
| Campaigns | Campaign number, coupon codes, campaign result report |
| Quotes and orders | Quote, order, deposit receipt, layaway agreement, delivery note, pick list |
| Purchases | Supplier number, purchase requirement, purchase order, goods receipt, supplier return, supplier payment |
| Inventory | Adjustment, write-off, count sheet, count result, repackaging, block and recall notice |
| Security | Authorization record number |

---

## 19. Amendments to frozen sections

Each addition was requested or authorized by the owner during the requirements review. No rule of the original section changed.

| Section | Addition | Reason |
|---|---|---|
| Sales | Campaign reference on sale lines | Campaign analysis (chapter 10) |
| Sales | Job site reference on the sale and its delivery | Contractor job sites (chapter 9) |
| Sales | PO number on the sale, required for customers that need it | Company customers (chapter 9) |
| Sales | Sale origin "captured after an outage" and paper ticket number | Post-outage capture (chapter 16) |
| Sales | "Allow with authorization" added as an option of the zero-stock setting | Inventory flagged list (chapter 13) |
| Products | Receiving inspection specs field | Quarantine and inspection (chapter 12) |

The authorization dates were not recorded in this document and can be added from the project history.

---

## 20. Prepared for the future (off for now)

| Area | Prepared |
|---|---|
| Branches | `branch_id` default 1 on transactional tables |
| Invoicing | CFDI 4.0 fields reserved from the first version |
| Inventory | Per-location stock and transfers, valuation snapshots, lot and expiration, serial numbers |
| Purchases | Purchase order approval threshold, early-payment discounts, attachments |
| Delivery | Payment on delivery, route planning, delivery cost tracking |
| Customers | Interest on overdue balances |
| Security | Tamper-evident audit log |
| Operations | Offline mode for registers, accounting export, archiving |

---

## 21. Open technical points and items to verify

1. **RDLC with .NET 8**: Windows Forms on .NET 8 needs a ReportViewer control compatible with that version, and the report designer is a Visual Studio extension. Verify the available options before freezing the technical architecture.
2. **SICAR and Eleventa baseline**: check the baseline column in chapter 5 against the current editions and trials of both products.
3. **Cash rounding rules**: check current Banxico and PROFECO guidance before fixing the default rounding mode.
4. **Customer privacy**: the privacy notice, consent wording and retention rules should be reviewed by a legal advisor.
5. **Fiscal retention**: the legal retention period for fiscal documents should be confirmed with the accountant (Phase 3).
6. **Email and WhatsApp**: email needs the store's account configured. WhatsApp depends on an external provider and customer consent, so channels are decided at design time.
7. **Background jobs**: where scheduled tasks run (for example as a service on the computer that hosts the database) is decided in the technical design.
8. **Updates**: the exact installer and update packaging for the registers is decided in the technical design, within the manual-installation and version-check rules in chapter 16.
9. **Backups**: the default destination is the same disk as the database. A copy on another device or in the cloud is strongly recommended.
10. **Hardware**: scale protocols and thermal printer models are confirmed when the equipment is chosen.

---

## 22. Out of scope

- Multi-branch logic in the user interface (the structure is prepared).
- E-commerce.
- Mobile application.
- Dollars or other currencies.
- Authorized buyers on company accounts, and a credit approval workflow.
- Vehicle load capacity checks (weight and dimensions).

---

*End of document.*
