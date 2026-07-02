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
