# BAQ-002 – Inventory Availability

| Property                | Value                         |
| ----------------------- | ----------------------------- |
| **Module**              | Inventory Management          |
| **Functional Area**     | Inventory Visibility          |
| **Implementation Type** | Business Activity Query (BAQ) |
| **Difficulty**          | Intermediate                  |
| **Business Impact**     | High                          |
| **Status**              | Completed                     |

## Overview

This Business Activity Query (BAQ) provides a centralized view of inventory availability across the organization, enabling users to quickly verify stock levels by part, warehouse, and bin location. The query consolidates key inventory information into a single dataset, reducing the need to navigate multiple Epicor screens to obtain operational data.

Designed to support warehouse operations, production planning, purchasing, and customer service, the BAQ presents essential inventory metrics such as on-hand quantity, allocated quantity, and available quantity. By improving inventory visibility, it helps users make informed decisions regarding material availability, production scheduling, and customer order fulfillment.

## Problem

Inventory availability information is essential for operational decision-making, but users may need to review information from different areas of the ERP system to determine whether sufficient inventory is available to support current and upcoming requirements.

Without a consolidated view of inventory availability, users may spend additional time reviewing inventory quantities and commitments before identifying potential shortages or determining whether a part requires further attention.

The lack of clear and centralized visibility can affect inventory management, production planning, and purchasing decisions by making it more difficult to identify available quantities and potential inventory risks in a timely manner.

## Business Context

In a manufacturing environment, inventory availability affects the ability to support sales order fulfillment, production activities, material planning, and purchasing decisions. Operational teams need timely visibility into available quantities and inventory commitments to understand whether current inventory can support both immediate needs and upcoming requirements.

Inventory availability can change as quantities are received, allocated, consumed, or committed to operational demand. As a result, decisions may depend not only on the quantity physically present, but also on the quantity that remains available after considering existing commitments.

A consolidated inventory availability view can support inventory management, production planning, and purchasing activities by helping users identify parts that may require attention before inventory shortages affect operations.

## Overview

This Business Activity Query (BAQ) provides a consolidated view of inventory availability to support operational decision-making in a manufacturing environment.

The query brings together relevant inventory information to help users evaluate available quantities, inventory commitments, and potential availability concerns in a single view.

By improving visibility into inventory availability, the BAQ supports inventory management, production planning, and purchasing activities by helping users identify parts that may require attention in relation to current and upcoming operational requirements.

### Business Requirements

The BAQ must provide timely visibility into inventory availability to support operational decision-making across relevant manufacturing activities.

The solution should support the evaluation of whether available inventory is sufficient to address current and upcoming operational requirements.

The BAQ should help users identify potential inventory concerns and parts that may require further attention before shortages affect sales order fulfillment, production activities, or material planning.

The information should reduce the effort required to evaluate inventory availability by providing a consolidated view of relevant inventory quantities and commitments.

The solution should support inventory management, production planning, and purchasing decisions without replacing existing inventory planning or material planning processes.

### Functional Requirements

1. The BAQ must provide a consolidated view of inventory information at the part level.

2. The BAQ must display relevant inventory quantities required to evaluate current availability.

3. The BAQ must provide visibility into inventory commitments that affect the quantity available for operational use.

4. The BAQ must support the comparison of available inventory with current and upcoming operational requirements.

5. The BAQ must help identify parts where available inventory may not be sufficient to support the defined requirements.

6. The BAQ must present the information in a format that allows users to quickly review inventory availability and identify parts that may require further attention.

7. The BAQ should support the analysis of inventory availability without replacing existing inventory, material planning, purchasing, or production planning processes.

## Solution Design

The BAQ will provide a consolidated inventory availability view organized at the part level.

The solution will combine relevant inventory quantities, inventory commitments, and operational requirements to provide a clearer representation of the quantity available to support current and upcoming needs.

The resulting view will allow users to compare available inventory with identified requirements and recognize parts where inventory availability may require further attention.

The solution will present inventory information and availability indicators in a single consolidated result set, supporting efficient review without replacing existing inventory, material planning, purchasing, or production planning processes.

## Data Sources

The BAQ uses a focused set of Epicor ERP data sources to provide warehouse-level inventory availability and compare available quantities with sales order requirements.

| Data Source | Purpose |
|---|---|
| **Part** | Provides the part-level identity and descriptive information for the result set. |
| **PartWhse** | Provides warehouse-level inventory information used to evaluate inventory availability. |
| **OrderRel** | Provides current and upcoming sales order requirements used as the operational demand source. |

The initial version of the BAQ is designed to provide inventory visibility at the warehouse level. Bin-level inventory detail is intentionally outside the initial scope and may be considered as a future enhancement for users who require more detailed inventory investigation.

## Query Logic

The BAQ is organized around the part and warehouse combination to maintain the appropriate level of inventory visibility.

Inventory information is obtained at the warehouse level through the relationship between the Part and PartWhse data sources.

Sales order requirements are evaluated separately and consolidated at the corresponding part and warehouse level before being used in the inventory availability evaluation.

This approach prevents inventory quantities from being duplicated when multiple sales order releases exist for the same part. The aggregated sales order requirements can then be compared with the relevant warehouse-level inventory quantity.

The resulting logic provides a single inventory availability view for each relevant part and warehouse combination, supporting the identification of situations where available inventory may not be sufficient to support current and upcoming sales order requirements.

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

## Parameters

The initial version of BAQ-002 does not use runtime parameters.

The BAQ is designed to provide broad visibility across the relevant Part + Warehouse combinations without requiring users to enter additional information at runtime. This approach supports the purpose of the BAQ as an inventory visibility and decision-support tool and avoids unnecessarily restricting the initial results.

Future enhancements may introduce optional parameters, such as Part Number, Warehouse, or other business criteria, if additional filtering flexibility becomes necessary. These options are outside the scope of the initial version.

## Filter Criteria

The BAQ is designed to evaluate inventory availability only for Part + Warehouse combinations with relevant operational demand.

The filter criteria are driven by the business principle that only active, open, unfulfilled, and operationally valid sales order demand should participate in the inventory availability evaluation.

### Relevant Sales Order Demand

Only sales order releases with a remaining unfulfilled quantity greater than zero are included.

This prevents fulfilled or completed demand from continuing to affect the inventory availability evaluation.

### Open Orders

Only open sales orders are considered.

Closed orders are excluded because they no longer represent active operational demand requiring additional inventory evaluation.

### Open Releases

Only open sales order releases are included.

This ensures that the BAQ evaluates releases that remain operationally active and expected to require fulfillment.

### Cancelled Releases

Cancelled releases are excluded from the evaluation.

Once a release has been cancelled, it no longer represents valid operational demand and should not continue to affect the inventory availability calculation.

### Held Orders

Orders currently on hold are excluded from the initial evaluation.

A held order may contain a business condition that prevents normal fulfillment or production from proceeding. Including held orders could overstate the inventory demand that currently requires operational action.

### Part + Warehouse Scope

Active operational demand determines which Part + Warehouse combinations are included in the BAQ.

The relevant demand identifies the Part + Warehouse combination, and the corresponding On-Hand Quantity is then evaluated against the total sales order requirement.

Part + Warehouse combinations with inventory but no relevant operational demand are outside the scope of the initial version.

### Zero On-Hand Quantity

A Part + Warehouse combination must not be excluded simply because its On-Hand Quantity is zero.

A zero On-Hand Quantity may represent an important shortage condition when relevant operational demand exists.

For example:

- Total Sales Order Requirement: 50
- On-Hand Quantity: 0
- Remaining Availability: -50
- Availability Status: Shortage
- Shortage Quantity: 50

For this reason, On-Hand Quantity is evaluated as part of the availability calculation rather than used as an exclusion criterion.

### Filter Criteria Summary

The BAQ includes sales order demand that meets the following business conditions:

- The sales order remains open.
- The sales order is not on hold.
- The sales order release remains open.
- The sales order release is not cancelled.
- A remaining unfulfilled quantity greater than zero exists.

These conditions define the relevant operational demand that determines the Part + Warehouse combinations included in the inventory availability evaluation.

The corresponding On-Hand Quantity is then evaluated regardless of whether the inventory quantity is positive, zero, or insufficient to cover the demand.

This approach keeps BAQ-002 focused on active operational requirements while avoiding the inclusion of inventory records with no relevant demand in the initial scope.

## Validation

### Validation Approach

The validation of BAQ-002 focuses on confirming that the query behaves according to the approved business design and provides reliable inventory availability information at the Part + Warehouse level.

The validation process evaluates both On-Hand inventory and operational sales order demand, with particular attention to demand aggregation, demand filtering, calculated fields, and the resulting availability status.

The validation is based on representative business scenarios rather than only confirming that the BAQ executes successfully. Each scenario evaluates the expected result and its corresponding business interpretation.

### Scenario 1 — Inventory Exceeds Demand

| Property | Value |
|----------|-------|
| On-Hand Quantity | 100 |
| Total Sales Order Requirement | 50 |
| Remaining Availability | 50 |
| Availability Status | Available |
| Shortage Quantity | 0 |

**Business Interpretation**

No immediate additional purchasing requirement is indicated for this Part + Warehouse based on the current demand and On-Hand inventory.

### Scenario 2 — Inventory Exactly Covers Demand

| Property | Value |
|----------|-------|
| On-Hand Quantity | 50 |
| Total Sales Order Requirement | 50 |
| Remaining Availability | 0 |
| Availability Status | Exactly Covered |
| Shortage Quantity | 0 |

**Business Interpretation**

No current shortage exists, but no remaining inventory buffer is available for additional demand.

### Scenario 3 — Inventory Is Insufficient

| Property | Value |
|----------|-------|
| On-Hand Quantity | 50 |
| Total Sales Order Requirement | 80 |
| Remaining Availability | -30 |
| Availability Status | Shortage |
| Shortage Quantity | 30 |

**Business Interpretation**

Current On-Hand inventory is insufficient to cover the active operational demand, resulting in a shortage of 30 units and requiring further operational review.

### Scenario 4 — Multiple Sales Order Releases for the Same Part + Warehouse

| Property | Value |
|----------|-------|
| Release 1 | 20 |
| Release 2 | 30 |
| Release 3 | 25 |
| Total Sales Order Requirement | 75 |
| On-Hand Quantity | 100 |
| Remaining Availability | 25 |
| Availability Status | Available |
| Shortage Quantity | 0 |

**Business Interpretation**

Multiple active sales order releases for the same Part + Warehouse are aggregated into a single operational demand quantity, while the corresponding On-Hand inventory is evaluated once at the Part + Warehouse level.

### Scenario 5 — Filtered / Inactive Demand

| Property | Value |
|----------|-------|
| On-Hand Quantity | 100 |
| Release A — Open / Active | 30 |
| Release B — Fulfilled | 20 — Excluded |
| Release C — Cancelled | 15 — Excluded |
| Release D — Held Order | 25 — Excluded |
| Total Valid Demand | 30 |
| Remaining Availability | 70 |
| Availability Status | Available |
| Shortage Quantity | 0 |

**Business Interpretation**

Only active and operationally valid demand affects the inventory availability evaluation. Fulfilled, cancelled, and held demand is excluded so that the resulting availability reflects the current operational situation.

### Validation Coverage Review

The five validation scenarios collectively provide coverage of the approved BAQ-002 business logic. They validate the three possible availability outcomes — **Available, Exactly Covered, and Shortage** — while confirming the correct evaluation of operational demand and On-Hand inventory at the **Part + Warehouse** level.

The validation also confirms that multiple sales order releases are correctly aggregated without duplicating On-Hand inventory, and that fulfilled, cancelled, and held demand is excluded from the availability calculation. The scenarios cover shortage conditions, including situations where available inventory is insufficient to satisfy the current operational demand.

Finally, the scenarios validate the logical relationship among **Total Sales Order Requirement, On-Hand Quantity, Remaining Availability, Availability Status, and Shortage Quantity**. Therefore, the validation demonstrates not only that the BAQ executes correctly, but that its results behave according to the intended business logic and provide sufficient evidence to consider **BAQ-002 functionally validated**.

![VALIDATION LOGICAL FLOW IMAGE](https://github.com/robertourbina/portfolio-roberto-urbina-m/blob/main/epicor/baq-examples/baq-002-inventory-availability/images/Figure%20%E2%80%94%20BAQ-002%20Validation%20Logical%20Flow.png)

**Status: 🔒 Frozen**

## Business Value

BAQ-002 provides a consolidated view of On-Hand inventory and active sales order demand at the Part + Warehouse level. By bringing information from multiple operational sources into a single BAQ, users can quickly evaluate inventory availability and identify situations that require attention.

The Availability Status helps users prioritize Part + Warehouse combinations according to their current situation, including Available, Exactly Covered, and Shortage conditions. This provides a practical decision-support view without replacing the planning or purchasing processes used by the business.

The information can support several operational areas:

- **Sales:** Provides visibility into whether current inventory and demand conditions may affect the ability to support customer commitments.
- **Purchasing:** Helps identify parts that may require purchasing attention because current inventory is insufficient to cover operational demand.
- **Production Planning:** Helps identify demand that may require scheduling or additional production planning attention.
- **Inventory Management:** Provides visibility into the relationship between available inventory and upcoming sales order demand.
- **Management:** Provides an overall view of inventory availability and potential shortages to support decisions related to purchasing and production requirements.

By consolidating inventory and demand information in one place, BAQ-002 reduces the time required to evaluate inventory availability against current commitments. It also helps identify inventory risks that could prevent the business from meeting those commitments, allowing operational areas to review potential issues earlier and plan accordingly.

Overall, BAQ-002 provides **inventory visibility and decision support that helps the business identify availability risks, prioritize attention, and improve operational planning at the Part + Warehouse level.**

**Status: 🔒 Frozen**

## Technical Skills Demonstrated

BAQ-002 demonstrates the application of Epicor ERP functional knowledge across Sales Order Management, Warehouse Management, and Inventory Management. The solution connects operational sales order demand with warehouse-level inventory information to provide availability visibility at the Part + Warehouse level.

The implementation demonstrates knowledge of the Epicor ERP data model, including the use of Part for product information, PartWhse for inventory at the Part + Warehouse level, and OrderRel for identifying sales order release demand. Understanding the role and relationship of these tables was essential to building the BAQ around the required business scope.

The BAQ design demonstrates the ability to join multiple data sources while controlling the level of aggregation. Multiple sales order releases are aggregated into a single demand quantity, while On-Hand inventory is evaluated once at the Part + Warehouse level to mitigate the risk of duplicated inventory values.

The solution also demonstrates the use of business logic and calculated fields to transform raw ERP data into decision-support information. Remaining Availability, Availability Status, and Shortage Quantity provide meaningful indicators that allow users to understand whether current inventory can support operational demand.

BAQ-002 also demonstrates query-level data selection through defined filters that identify operationally relevant records. Runtime parameters were intentionally not included in the initial scope, while filtering is used to control which records participate in the availability evaluation.

Finally, the development and validation of BAQ-002 demonstrate the ability to translate business requirements into technical query logic and validate the resulting behavior against representative business scenarios. The solution required understanding not only where the data is stored in Epicor ERP, but also how the underlying business process should be represented within the system.

**Status: 🔒 Frozen**

## Lessons Learned

BAQ-002 reinforced the importance of understanding the Epicor ERP data model before designing a query. Knowing where the required information is stored and understanding the purpose and relationships of the relevant tables provides the foundation for developing a reliable solution.

The development of BAQ-002 also reinforced the importance of understanding how multiple sales order releases relate to the Part + Warehouse level. Working with multiple releases required careful use of joins and aggregation to obtain the correct demand quantity while avoiding duplicated inventory information.

Another important lesson was recognizing the data integrity risks that can appear when demand and inventory information are joined. A query can execute correctly from a technical perspective while still producing misleading business results if the level of aggregation is not properly controlled.

BAQ-002 also demonstrated how calculated fields can transform raw ERP data into information that is easier for users to understand and apply to business decisions. Similarly, query-level filtering reinforces the importance of selecting only the data that is relevant to the intended business analysis.

One of the main lessons from the development process was that the business logic must be understood before designing and developing the technical solution. The technical implementation should represent the actual business process and the decisions the solution is intended to support.

The validation process reinforced another important lesson: a BAQ can execute without errors and still provide misleading information. Functional validation against the approved business scope is therefore necessary to confirm that the results are reliable and behave as expected.

The two main lessons from BAQ-002 are to clearly define the business issue to be resolved and understand how the required information is stored before designing the solution, and to validate the outcome to ensure that the resulting solution provides reliable information.

**Status: 🔒 Frozen**

## Future Enhancements

BAQ-002 provides a foundation for future improvements to inventory availability analysis. The following enhancements could extend its usefulness while maintaining the current focus on Part + Warehouse visibility and active sales order demand.

### Runtime Parameters

Future versions could include runtime parameters that allow users to focus the analysis on a specific Part, Warehouse, or Availability Status. This would make the BAQ more flexible and allow users to select the information most relevant to their operational needs.

### Bin-Level Detail

Additional visibility could be provided through bin-level inventory information. This would help users investigate where inventory is located within a warehouse and support more detailed inventory availability analysis.

### Additional Demand Sources

The solution could be extended to include additional operational demand sources beyond sales orders. This would provide a broader view of requirements that may affect inventory availability and operational planning.

### Purchasing Information

Future enhancements could include open purchase orders, expected receipts, and raw material delivery dates. This information would help users evaluate whether required materials are expected to arrive on time and support purchasing and production planning decisions.

### Production Information

Production orders or planned production could be incorporated to provide additional visibility into how current and future requirements may be supported through production. This would be particularly useful for the Production area when evaluating the ability to meet operational demand.

### Time-Based Analysis

A time-based analysis could allow users to evaluate inventory availability according to Need By dates or upcoming periods. This would help users concentrate on relevant timeframes and identify requirements that may need attention.

### Dashboard and Visualization

BAQ-002 could be presented through an Epicor dashboard or another visual management tool. The use of colors, indicators, or visual marks could help users identify parts with shortages or other availability issues more clearly and prioritize situations requiring attention.

### Enhancement Priorities

Based on the potential business value, the following three enhancements are considered the most relevant initial opportunities:

1. **Runtime Parameters:** Allow users to select and focus on the information they need.
2. **Purchasing Information:** Provide visibility into expected raw material availability and delivery timing.
3. **Time-Based Analysis:** Allow users to concentrate on a relevant period according to operational requirements.

These enhancements would extend BAQ-002 from a consolidated inventory availability view into a broader decision-support solution, providing additional flexibility, supply visibility, and time-based analysis while preserving the original business scope.

**Status: 🔒 Draft**


