# BAQ-001 – Open Sales Orders Analysis

| Property | Value |
|----------|-------|
| Module | Sales Order Management |
| Functional Area | Order-to-Cash |
| Implementation Type | Business Activity Query (BAQ) |
| Difficulty | Intermediate |
| Business Impact | High |
| Status | In Progress |

---

## 1. Overview

This implementation demonstrates the design of a Business Activity Query (BAQ) used to analyze open sales orders in Epicor ERP.

The purpose of this BAQ is to provide visibility into customer orders that are still open, pending shipment, or partially fulfilled. This information helps sales, customer service, shipping, and operations teams understand current order backlog and prioritize business activities.

---

## 2. Business Scenario

In a manufacturing environment, sales orders represent customer demand that must be fulfilled through inventory, production, purchasing, and shipping processes.

When sales orders remain open, different departments need visibility into key information such as customer, order date, requested ship date, part number, ordered quantity, shipped quantity, and remaining quantity.

Without a centralized view, users may need to review multiple screens or reports to understand the current status of open customer orders.

This BAQ provides a consolidated view of open sales orders to support daily follow-up and operational decision-making.

---

## 3. Business Problem

Sales and customer service teams frequently require accurate and timely information about customer orders that have not yet been completely fulfilled. Although Epicor ERP provides standard inquiry screens, obtaining a consolidated view of all open sales orders often requires navigating through multiple transactions and manually reviewing individual order details.

This process can be time-consuming and may delay customer responses, shipment planning, and production scheduling. Additionally, the lack of a centralized view makes it more difficult to identify overdue orders, partially shipped lines, and pending customer commitments.

The organization required a single source of information that would allow users to quickly identify all open sales orders, monitor fulfillment status, and support operational decision-making across multiple departments.

The solution was to develop a Business Activity Query (BAQ) that consolidates the most relevant sales order information into a single, easy-to-use inquiry.

---

## 4. Business Process Overview

This implementation supports the **Order-to-Cash** business process, beginning with customer order entry and continuing through shipping and invoicing.

During the lifecycle of a sales order, multiple departments interact with the same information:

- Sales enters and manages customer orders.
- Customer Service provides order status updates.
- Production plans manufacturing activities based on demand.
- Purchasing ensures required materials are available.
- Shipping prepares and fulfills customer deliveries.
- Management monitors order backlog and operational performance.

Providing a consolidated view of open sales orders improves communication between departments, increases visibility into customer commitments, and helps prioritize daily operational activities.

---

## 5. Functional Requirements

The BAQ must satisfy the following business requirements:

### Required Information

- Company
- Order Number
- Order Line
- Customer ID
- Customer Name
- Part Number
- Part Description
- Order Date
- Requested Ship Date
- Need By Date
- Order Quantity
- Shipped Quantity
- Remaining Quantity
- Unit Price
- Extended Price
- Sales Representative
- Order Status
- Line Status

### Functional Requirements

- Display only open sales order lines.
- Exclude cancelled orders.
- Calculate the remaining quantity to be shipped.
- Allow users to sort by requested ship date.
- Support filtering by customer, part number, and order number.
- Provide information suitable for dashboards and reporting.

