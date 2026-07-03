# BAQ-001 – Open Sales Orders Analysis

| Property | Value |
|----------|-------|
| Module | Sales Order Management |
| Functional Area | Order-to-Cash |
| Implementation Type | Business Activity Query (BAQ) |
| Difficulty | Intermediate |
| Business Impact | High |
| Status | Completed |

---

# Overview

This implementation demonstrates the design and development of a Business Activity Query (BAQ) that provides visibility into open sales orders within Epicor ERP.

The solution was created to support Sales, Customer Service, Shipping, Production Planning, and Management by providing a centralized view of customer orders that remain open or partially fulfilled.

Rather than navigating multiple Epicor ERP screens, users can quickly identify pending customer commitments, monitor fulfillment progress, and prioritize operational activities through a single, easy-to-use inquiry.

This implementation follows the standard documentation methodology adopted throughout this portfolio, emphasizing business analysis, solution design, implementation, validation, and business value.

---

# 1. Problem

Manufacturing organizations rely on accurate sales order information to coordinate production, inventory, purchasing, and shipping activities.

Although Epicor ERP provides standard inquiry screens, obtaining a consolidated view of all open sales orders often requires navigating through multiple transactions and reviewing information across several windows.

This process increases the time required to answer customer inquiries, monitor delivery commitments, and identify orders requiring immediate attention.

The organization required a centralized inquiry capable of displaying the current status of all open sales orders in a single location while supporting operational decision-making across multiple departments.

---

# 2. Requirements

The proposed solution must satisfy the following business requirements.

## Functional Requirements

- Display only open sales orders.
- Exclude cancelled orders.
- Display both header and line information.
- Calculate remaining quantities pending shipment.
- Display customer information.
- Display product information.
- Display requested shipping dates.
- Support filtering by customer, order number, and part number.
- Allow sorting by requested shipment date.
- Be suitable for dashboards and reporting.

## Business Requirements

The solution should:

- Improve visibility into customer commitments.
- Reduce the time required to answer customer inquiries.
- Support shipment prioritization.
- Improve communication between Sales, Customer Service, Production, and Shipping.
- Provide reliable information for operational decision-making.

---

# 3. Solution Evaluation

Several alternatives were evaluated before selecting the final solution.

| Option | Advantages | Limitations |
|---------|------------|-------------|
| Standard Epicor inquiries | No development required | Limited flexibility and difficult to consolidate information |
| Standard reports | Suitable for printed reports | Not interactive and limited filtering capabilities |
| Dashboard | Excellent visualization | Requires an underlying BAQ |
| Business Activity Query (BAQ) | Flexible, reusable, and easily integrated with dashboards and reports | Requires initial design and validation |

After evaluating the available alternatives, a Business Activity Query (BAQ) was selected as the most appropriate solution because it provides flexibility, supports interactive filtering, and serves as the foundation for future dashboards, reports, and integrations.

---

# 4. Selected Approach

A Business Activity Query (BAQ) was designed using Epicor ERP to consolidate information from the Sales Order module into a single inquiry.

The implementation retrieves sales order header information, line details, customer information, and product information while calculating remaining quantities pending shipment.

The design follows Epicor ERP best practices by minimizing unnecessary joins, selecting only the required fields, and producing a reusable dataset suitable for multiple reporting scenarios.

---

# 5. Implementation

> *(Implementation details will be documented in the following sections.)*

## 5.1 Data Model

The data model for this BAQ is centered on the sales order lifecycle within Epicor ERP.

The main business entity is the **Sales Order**, which represents a customer commitment to purchase manufactured or supplied products. In this implementation, the sales order is analyzed at the header, line, and release levels to provide a complete view of open customer demand.

The BAQ uses the following logical data areas:

| Data Area | Purpose |
|----------|---------|
| Sales Order Header | Identifies the customer, order number, order date, and general order information. |
| Sales Order Lines | Provides the ordered parts, quantities, pricing, and commercial information. |
| Sales Order Releases | Provides delivery schedules, release quantities, requested ship dates, remaining quantities, and fulfillment status. |
| Customer Information | Adds customer identification and descriptive information for sales and customer service follow-up. |
| Part Information | Adds product descriptions and item details to make the results easier to understand. |
| Sales Representative Information | Supports accountability and follow-up by identifying the responsible sales representative when applicable. |

The inclusion of **Sales Order Releases** is important because Epicor ERP manages customer delivery commitments at the release level. A single sales order line may have multiple releases with different shipment dates, quantities, or delivery requirements.

This is especially relevant in a manufacturing environment where institutional furniture orders may be delivered in phases based on production capacity, material availability, or customer installation schedules.

By including release-level information, the BAQ can answer key business questions such as:

- Which sales order releases are still open?
- Which customers have pending shipments?
- Which products are pending delivery?
- What quantity remains to be shipped by release?
- Which releases are overdue or require follow-up?
- What is scheduled to ship during a specific period?

By organizing the BAQ around the sales order header, detail, and release relationship, the solution provides a reliable foundation for dashboards, reports, and future operational analysis.

---

## 5.2 Tables Used

The BAQ retrieves information from several Epicor ERP tables that together represent the complete Sales Order process. Each table was selected based on the business requirements identified during the analysis phase.

The following tables provide the transactional and master data required to analyze open sales orders and their associated delivery commitments.

| Table | Data Type | Purpose |
|--------|-----------|---------|
| OrderHed | Transaction | Stores the sales order header information, including customer, order dates, sales representative, and overall order status. |
| OrderDtl | Transaction | Contains the products ordered by the customer, ordered quantities, pricing information, and line-level status. |
| OrderRel | Transaction | Stores release-level information, including requested ship dates, release quantities, open quantities, warehouse, and fulfillment status. |
| Customer | Master | Provides customer identification and descriptive information. |
| Part | Master | Provides product descriptions and item master information used to enrich the report output. |
| SalesRep *(Optional)* | Master | Identifies the sales representative responsible for the customer order. |

The implementation combines transactional data with master data to provide users with a complete business view of each open sales order.

Although this implementation focuses on the core tables required to satisfy the identified business requirements, the design allows additional tables to be incorporated in future enhancements without significantly changing the overall data model.

### Design Decision

The BAQ intentionally uses the minimum set of transaction and master tables required to satisfy the business requirements.

This design helps reduce unnecessary joins, improves maintainability, and supports better query performance.

The inclusion of `OrderRel` is a key design decision because delivery commitments in Epicor ERP are managed at the release level. This allows the BAQ to provide more accurate visibility into pending shipments, open quantities, and requested ship dates.

---

### 5.3 Table Relationships

---

### 5.4 Calculated Fields

---

### 5.5 Parameters

---

### 5.6 Filters

---

### 5.7 Expected Output

---

---

# 6. Validation

Validation activities performed during implementation include:

- Verification of returned records.
- Comparison against standard Epicor inquiries.
- Validation of calculated quantities.
- Functional testing with representative business scenarios.
- Confirmation that only open sales orders are displayed.

---

# 7. Business Value

The implementation provides several operational benefits:

- Improves visibility into open customer orders.
- Reduces the time required to answer customer inquiries.
- Supports production and shipping planning.
- Improves collaboration between departments.
- Provides reliable information for dashboards and management reporting.
- Establishes a reusable data source for future Epicor ERP solutions.

---

# 8. Lessons Learned

This implementation reinforced the importance of beginning every ERP solution with a clear understanding of the business problem before designing the technical solution.

Careful analysis of business requirements simplified the BAQ design, reduced unnecessary complexity, and produced a solution that can be reused across multiple reporting and dashboard initiatives.

The implementation also demonstrated that a well-designed BAQ becomes a strategic information source rather than simply another query.

---

# 9. Related Implementations

The following implementations are planned as part of this portfolio and will build upon the data provided by this BAQ.

- DSH-001 – Open Sales Orders Dashboard *(Planned)*
- RPT-001 – Open Sales Orders Report *(Planned)*
- BPM-001 – Sales Order Validation *(Planned)*
