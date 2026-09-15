
# BAQ-003 – Purchase Orders Pending Receipt

| Property | Value |
|----------|-------|
| Module | Purchasing Management |
| Functional Area | Procure-to-Pay |
| Implementation Type | Business Activity Query (BAQ) |
| Difficulty | Intermediate |
| Business Impact | High |
| Status | Draft |

## Overview

BAQ-003 – Purchase Orders Pending Receipt is designed to provide visibility into purchase order lines that have not yet been fully received.

The BAQ focuses on the relationship between open purchase order requirements and the quantities received for each purchase order line. Its purpose is to help Purchasing, Receiving, Inventory Management, and Production Planning identify outstanding supplier deliveries and understand which materials or items may still be pending receipt.

The initial version is intended to provide a clear operational view of pending purchase order receipts without replacing the standard purchasing, receiving, or material planning processes.

## Problem

Purchase orders may contain multiple lines and scheduled receipts, making it difficult to identify which materials or items are still pending receipt.

When received quantities are not compared clearly with the original ordered quantities, Purchasing and Receiving personnel may need to review purchase orders individually to determine:

- Which purchase order lines remain open.
- How much quantity is still pending receipt.
- Which suppliers have outstanding deliveries.
- Which materials may affect inventory availability or production planning.
- Whether a purchase order line has been partially received or has not yet been received.

The absence of a focused pending-receipt view can increase the time required to investigate outstanding purchase order requirements and may delay follow-up activities with suppliers or internal departments.

BAQ-003 addresses this need by providing a consolidated view of purchase order lines with remaining quantities to be received.

## Requirements

### Functional Requirements

The BAQ must:

- Identify open purchase orders with outstanding receipt requirements.
- Identify open purchase order lines within those purchase orders.
- Display the purchase order number and purchase order line.
- Identify the release associated with the purchase order line.
- Identify the supplier associated with the purchase order.
- Display the part or item associated with the purchase order line.
- Display the released quantity associated with the purchase order line.
- Display the quantity already received against the applicable release.
- Calculate the remaining quantity to be received.
- Include partially received purchase order requirements.
- Include purchase order requirements for which no receipt has been recorded.
- Exclude purchase order lines that have no remaining quantity to be received.
- Provide a clear view of pending receipt requirements at the Purchase Order Line level.

### Business Requirements

The BAQ should help Purchasing, Receiving, Inventory Management, and Production Planning:

- Identify outstanding supplier deliveries.
- Determine which purchase order lines and releases have quantities still pending receipt.
- Prioritize follow-up activities with suppliers.
- Understand the quantity still expected for each purchase order line and release.
- Identify potential impacts on inventory availability and production planning.
- Reduce the time required to review purchase orders individually.

### Scope Clarification

The initial version will focus on open purchase orders, open purchase order lines, release quantities, received quantities, and remaining quantities to be received.

The following topics are intentionally outside the initial scope:

- Supplier delivery performance.
- Supplier quality evaluation.
- On-time delivery measurements.
- Purchase price analysis.
- General purchasing efficiency.
- Detailed material planning calculations.
- Promised delivery date analysis or delivery-date prioritization.

These topics can be considered as future enhancements or addressed through other BAQ examples, particularly **BAQ-006 — Supplier Performance Analysis**.

## Solution Design

BAQ-003 is designed to provide a consolidated view of purchase order lines with outstanding receipt quantities.

The BAQ will use the purchase order line as the primary result level, allowing each purchase order line to be evaluated independently based on its ordered quantity and received quantity.

The solution will compare the original ordered quantity with the quantity already received to determine the remaining quantity to be received.

The BAQ will focus on open purchase order requirements and will include both partially received lines and lines for which no receipt has been recorded. Fully received lines will be excluded from the result.

The resulting view will provide Purchasing, Receiving, Inventory Management, and Production Planning with a focused operational view of outstanding purchase order requirements.

The initial solution is intentionally limited to receipt visibility and pending quantities. Supplier performance measurements, delivery-performance analysis, and other purchasing metrics are outside the scope of this BAQ.

## Data Sources

The BAQ uses a focused set of Epicor ERP data sources to identify purchase order lines with outstanding receipt quantities.

| Data Source | Purpose |
|---|---|
| **POHeader** | Provides purchase order header information and is used to identify open purchase orders within the scope of the analysis. |
| **PODetail** | Provides purchase order line information and serves as the primary result level for the BAQ. |
| **PORel** | Provides release-level purchasing requirements, including released quantities and received quantities used to determine the remaining quantity to be received. |
| **Vendor** | Provides supplier information associated with the purchase order. |
| **Part** | Provides part-level identification and descriptive information for the purchased item. |
| **RcvDtl** | Provides receipt transaction detail that can be used when additional receiving information is required. It is not used as the primary source for the received-quantity calculation in the initial design. |

The initial version of the BAQ is designed to evaluate outstanding receipt requirements at the Purchase Order Line level.

The primary quantity evaluation uses the release information available through PORel. This approach allows released and received quantities to be evaluated without introducing unnecessary receipt-transaction joins into the primary calculation.

RcvDtl remains available as a supporting data source for future receipt-related details, such as receipt transaction information, when required.

The data sources are intentionally limited to the information required to identify open purchase orders, evaluate their open lines and releases, and determine remaining quantities to be received. Supplier performance measurements, purchasing cost analysis, and detailed receiving analysis are outside the initial scope.

## Query Logic

The BAQ is organized around the Purchase Order Line as the primary result level.

The query first evaluates the Purchase Order header to identify open purchase orders. Closed or void purchase orders are excluded from the analysis because they no longer represent active purchasing requirements.

Within an open purchase order, the query evaluates the corresponding purchase order lines and includes only lines that remain open. Closed or void purchase order lines are excluded from the result.

Release information from PORel is then used to evaluate the purchasing requirements associated with each purchase order line. Because a purchase order line may contain multiple releases, release-level quantities are evaluated and consolidated appropriately at the Purchase Order Line level.

The released quantity and received quantity from PORel are used to determine the remaining quantity to be received for the applicable purchase order requirements.

The remaining quantity is calculated by comparing the released quantity with the accumulated received quantity.

Purchase order requirements with a remaining quantity greater than zero are included in the final result. This allows the BAQ to identify both partially received requirements and requirements for which no receipt has been recorded.

Vendor and Part information are included to provide supplier and item context without changing the primary Purchase Order Line result level.

RcvDtl is retained as a supporting data source for receipt transaction details when additional receiving information is required, but it is not used as the primary source for the received-quantity calculation in the initial design.

This approach provides a consolidated view of open purchase order lines with outstanding receipt quantities while preventing multiple releases or receipt transactions from artificially increasing the quantities used in the calculation.

## Calculated Fields

The BAQ uses calculated fields to transform the release-level quantity information into values that are easier to interpret from an operational perspective.

### Remaining Quantity

**Purpose:** Determines the quantity that remains to be received for the applicable purchase order requirement.

The calculation compares the released quantity with the quantity already received.

A positive result indicates that a portion of the released quantity remains outstanding.

### Receipt Status

**Purpose:** Provides a simple business interpretation of the receipt condition.

The status is derived from the relationship between the released quantity and the received quantity:

| Condition | Receipt Status |
|---|---|
| Received Quantity = 0 | Not Received |
| Received Quantity > 0 and Remaining Quantity > 0 | Partially Received |

Fully received requirements are excluded from the final result because the BAQ only includes purchase order requirements with a remaining quantity greater than zero.

The Receipt Status provides a business-friendly value that can later support visual indicators in a dashboard or other presentation layer.

### Design Consideration

The initial version intentionally focuses on the two calculated fields required to identify and interpret outstanding receipt quantities.

Additional metrics, such as receipt completion percentage, can be considered as future enhancements if the BAQ is later incorporated into a dashboard or broader purchasing analysis.

## Runtime Parameters

The initial version of BAQ-003 does not use runtime parameters.

This is intentional because the purpose of the BAQ is to provide a consolidated view of **all purchase order requirements that meet the defined query conditions**.

The query conditions already determine which records are included in the result, based on criteria such as:

- Open purchase orders.
- Open purchase order lines.
- Applicable open purchase order releases.
- Remaining quantity greater than zero.

Because the BAQ is intended to provide an overall operational view of outstanding receipt requirements, additional user-defined parameters are not required for the initial scope.

Future versions may introduce runtime parameters if specific operational scenarios require users to limit the results by criteria such as supplier, purchase order, part, plant, or date.

## Filter Criteria

The filter criteria are designed to ensure that the BAQ returns only active purchase order requirements with quantities still pending receipt.

### Purchase Order Header

The query includes only purchase orders that:

- Are open.
- Are not voided.

Closed or voided purchase orders are excluded because they no longer represent active purchasing requirements.

### Purchase Order Line

Within the qualifying purchase orders, the query includes only purchase order lines that:

- Are open.
- Are not voided.

This prevents closed or voided purchase order lines from being included in the pending receipt analysis.

### Purchase Order Release

The query evaluates the applicable purchase order releases and includes only releases that:

- Are open.
- Are not voided.

This ensures that the quantity calculation is based on active purchase order requirements.

### Remaining Quantity

The final filter includes only purchase order requirements where the **Remaining Quantity is greater than zero**.

This results in the inclusion of:

- Purchase order requirements for which no receipt has been recorded.
- Partially received purchase order requirements.

Fully received requirements are excluded because their remaining quantity is zero.

### Filter Design Consideration

The filters are intentionally defined within the BAQ rather than exposed as runtime parameters. This allows the initial version to provide a complete operational view of outstanding purchase order receipts while maintaining the business rules established in the Query Logic section.









