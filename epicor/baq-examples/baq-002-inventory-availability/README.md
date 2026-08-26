# BAQ-002 – Inventory Availability

| Property                | Value                         |
| ----------------------- | ----------------------------- |
| **Module**              | Inventory Management          |
| **Functional Area**     | Inventory Visibility          |
| **Implementation Type** | Business Activity Query (BAQ) |
| **Difficulty**          | Intermediate                  |
| **Business Impact**     | High                          |
| **Status**              | Completed                     |

---

## Overview

This Business Activity Query (BAQ) provides a centralized view of inventory availability across the organization, enabling users to quickly verify stock levels by part, warehouse, and bin location. The query consolidates key inventory information into a single dataset, reducing the need to navigate multiple Epicor screens to obtain operational data.

Designed to support warehouse operations, production planning, purchasing, and customer service, the BAQ presents essential inventory metrics such as on-hand quantity, allocated quantity, and available quantity. By improving inventory visibility, it helps users make informed decisions regarding material availability, production scheduling, and customer order fulfillment.

--
## Problem

Inventory availability information is essential for operational decision-making, but users may need to review information from different areas of the ERP system to determine whether sufficient inventory is available to support current and upcoming requirements.

Without a consolidated view of inventory availability, users may spend additional time reviewing inventory quantities and commitments before identifying potential shortages or determining whether a part requires further attention.

The lack of clear and centralized visibility can affect inventory management, production planning, and purchasing decisions by making it more difficult to identify available quantities and potential inventory risks in a timely manner.

--
## Business Context

In a manufacturing environment, inventory availability affects the ability to support sales order fulfillment, production activities, material planning, and purchasing decisions. Operational teams need timely visibility into available quantities and inventory commitments to understand whether current inventory can support both immediate needs and upcoming requirements.

Inventory availability can change as quantities are received, allocated, consumed, or committed to operational demand. As a result, decisions may depend not only on the quantity physically present, but also on the quantity that remains available after considering existing commitments.

A consolidated inventory availability view can support inventory management, production planning, and purchasing activities by helping users identify parts that may require attention before inventory shortages affect operations.

--

## Overview

This Business Activity Query (BAQ) provides a consolidated view of inventory availability to support operational decision-making in a manufacturing environment.

The query brings together relevant inventory information to help users evaluate available quantities, inventory commitments, and potential availability concerns in a single view.

By improving visibility into inventory availability, the BAQ supports inventory management, production planning, and purchasing activities by helping users identify parts that may require attention in relation to current and upcoming operational requirements.

--

### Business Requirements

The BAQ must provide timely visibility into inventory availability to support operational decision-making across relevant manufacturing activities.

The solution should support the evaluation of whether available inventory is sufficient to address current and upcoming operational requirements.

The BAQ should help users identify potential inventory concerns and parts that may require further attention before shortages affect sales order fulfillment, production activities, or material planning.

The information should reduce the effort required to evaluate inventory availability by providing a consolidated view of relevant inventory quantities and commitments.

The solution should support inventory management, production planning, and purchasing decisions without replacing existing inventory planning or material planning processes.

--

### Functional Requirements

1. The BAQ must provide a consolidated view of inventory information at the part level.

2. The BAQ must display relevant inventory quantities required to evaluate current availability.

3. The BAQ must provide visibility into inventory commitments that affect the quantity available for operational use.

4. The BAQ must support the comparison of available inventory with current and upcoming operational requirements.

5. The BAQ must help identify parts where available inventory may not be sufficient to support the defined requirements.

6. The BAQ must present the information in a format that allows users to quickly review inventory availability and identify parts that may require further attention.

7. The BAQ should support the analysis of inventory availability without replacing existing inventory, material planning, purchasing, or production planning processes.

--

## Solution Design

The BAQ will provide a consolidated inventory availability view organized at the part level.

The solution will combine relevant inventory quantities, inventory commitments, and operational requirements to provide a clearer representation of the quantity available to support current and upcoming needs.

The resulting view will allow users to compare available inventory with identified requirements and recognize parts where inventory availability may require further attention.

The solution will present inventory information and availability indicators in a single consolidated result set, supporting efficient review without replacing existing inventory, material planning, purchasing, or production planning processes.

--

## Data Sources

The BAQ uses a focused set of Epicor ERP data sources to provide warehouse-level inventory availability and compare available quantities with sales order requirements.

| Data Source | Purpose |
|---|---|
| **Part** | Provides the part-level identity and descriptive information for the result set. |
| **PartWhse** | Provides warehouse-level inventory information used to evaluate inventory availability. |
| **OrderRel** | Provides current and upcoming sales order requirements used as the operational demand source. |

The initial version of the BAQ is designed to provide inventory visibility at the warehouse level. Bin-level inventory detail is intentionally outside the initial scope and may be considered as a future enhancement for users who require more detailed inventory investigation.

--

## Query Logic

The BAQ is organized around the part and warehouse combination to maintain the appropriate level of inventory visibility.

Inventory information is obtained at the warehouse level through the relationship between the Part and PartWhse data sources.

Sales order requirements are evaluated separately and consolidated at the corresponding part and warehouse level before being used in the inventory availability evaluation.

This approach prevents inventory quantities from being duplicated when multiple sales order releases exist for the same part. The aggregated sales order requirements can then be compared with the relevant warehouse-level inventory quantity.

The resulting logic provides a single inventory availability view for each relevant part and warehouse combination, supporting the identification of situations where available inventory may not be sufficient to support current and upcoming sales order requirements.

--

## Calculated Fields

The BAQ uses calculated fields and business indicators to compare warehouse-level On-Hand inventory with the total unfulfilled sales order requirements for each Part + Warehouse combination.

The calculated fields are designed to provide a clear inventory availability evaluation without introducing unnecessary complexity.

### Total Sales Order Requirement

**Purpose:** Represents the total quantity from open sales order releases that remains relevant for fulfillment, aggregated at the Part + Warehouse level.

This field consolidates multiple sales order releases into a single operational demand value. Aggregating the requirements prevents multiple demand records from duplicating inventory quantities during the availability evaluation.

### On-Hand Quantity

**Purpose:** Represents the current physical inventory quantity recorded for a part at a specific warehouse.

The On-Hand Quantity is used as the inventory input for the availability evaluation. Using the physical inventory balance provides a clear distinction between inventory quantity and the sales order requirements that will be evaluated against it.

### Remaining Availability

**Purpose:** Represents the inventory quantity remaining after the total unfulfilled sales order requirements have been considered.

**Business Logic:**

On-Hand Quantity − Total Sales Order Requirement

The result may be positive, zero, or negative:

- **Positive:** Inventory remains after the identified sales order requirements are considered.
- **Zero:** Inventory exactly covers the identified sales order requirements.
- **Negative:** The identified sales order requirements exceed the current On-Hand Quantity.

Negative values are intentionally preserved because they provide a direct indication of the magnitude of the inventory shortage.

### Availability Status

**Purpose:** Provides a quick business interpretation of the Remaining Availability result.

**Business Logic:**

- **Available:** Remaining Availability is greater than zero.
- **Exactly Covered:** Remaining Availability is equal to zero.
- **Shortage:** Remaining Availability is less than zero.

This indicator allows users to quickly identify whether inventory remains, exactly covers the identified demand, or is insufficient to support the current requirements.

### Shortage Quantity

**Purpose:** Represents the positive quantity by which the Total Sales Order Requirement exceeds the On-Hand Quantity for a specific Part + Warehouse combination.

The value is zero when no shortage exists.

When Remaining Availability is negative, the Shortage Quantity represents the absolute value of the shortage. This provides a clear positive quantity indicating how many units are missing.

### Calculated Fields Summary

| Calculated Field | Business Purpose |
|---|---|
| **Total Sales Order Requirement** | Measures the relevant unfulfilled operational demand. |
| **On-Hand Quantity** | Represents the current physical inventory at the warehouse. |
| **Remaining Availability** | Calculates the inventory balance after demand is considered. |
| **Availability Status** | Provides a quick business interpretation of the availability result. |
| **Shortage Quantity** | Shows the magnitude of the inventory shortage when demand exceeds On-Hand Quantity. |

Together, these calculated fields provide a logical inventory availability evaluation at the Part + Warehouse level.

The sequence supports the following business flow:

**Sales Order Demand → On-Hand Inventory → Remaining Availability → Availability Status → Shortage Quantity**

This approach supports operational visibility and decision-making while preserving the BAQ as a decision-support tool rather than a replacement for inventory planning or material planning processes.

--



--


--



--


--



--


--


--


--

--

