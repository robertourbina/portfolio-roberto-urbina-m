
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

- Identify purchase order lines with outstanding receipt quantities.
- Display the purchase order number and purchase order line.
- Identify the supplier associated with each purchase order.
- Display the part or item associated with the purchase order line.
- Display the original ordered quantity.
- Display the quantity already received.
- Calculate the remaining quantity to be received.
- Include partially received purchase order lines.
- Include purchase order lines with no receipts.
- Exclude purchase order lines that have been fully received.
- Provide a clear view of pending receipt requirements at the purchase order line level.

### Business Requirements

The BAQ should help Purchasing, Receiving, Inventory Management, and Production Planning:

- Identify outstanding supplier deliveries.
- Determine which materials or items remain pending receipt.
- Prioritize follow-up activities with suppliers.
- Understand the quantity still expected from each purchase order line.
- Identify potential impacts on inventory availability and production planning.
- Reduce the time required to review purchase orders individually.

## Solution Design

BAQ-003 is designed to provide a consolidated view of purchase order lines with outstanding receipt quantities.

The BAQ will use the purchase order line as the primary result level, allowing each purchase order line to be evaluated independently based on its ordered quantity and received quantity.

The solution will compare the original ordered quantity with the quantity already received to determine the remaining quantity to be received.

The BAQ will focus on open purchase order requirements and will include both partially received lines and lines for which no receipt has been recorded. Fully received lines will be excluded from the result.

The resulting view will provide Purchasing, Receiving, Inventory Management, and Production Planning with a focused operational view of outstanding purchase order requirements.

The initial solution is intentionally limited to receipt visibility and pending quantities. Supplier performance measurements, delivery-performance analysis, and other purchasing metrics are outside the scope of this BAQ.







