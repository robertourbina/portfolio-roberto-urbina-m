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

### 5.1 Data Model

---

### 5.2 Tables Used

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
