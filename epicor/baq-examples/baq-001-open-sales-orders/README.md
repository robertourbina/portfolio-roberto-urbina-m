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

## 5.3 Table Relationships

The BAQ follows the natural sales order hierarchy used by Epicor ERP. The relationship flow begins with the customer, continues through the sales order header and detail records, and reaches the release level, where customer delivery commitments are managed.

This hierarchical structure ensures that each level of the sales order process contributes the information required to provide a complete view of open customer demand.

```text
Customer
   │
   ▼
OrderHed
   │
   ▼
OrderDtl
   │
   ▼
OrderRel
   │
   ▼
Part
```

The following table describes the primary relationships used in this implementation.

| Relationship | What? | Why? | Business Impact |
|--------------|-------|------|-----------------|
| **Customer → OrderHed** | Associates customer master data with the sales order header. | Every sales order belongs to a customer, making this relationship essential for identifying ownership of each order. | Enables Sales and Customer Service teams to analyze open orders by customer and respond more efficiently to customer inquiries. |
| **OrderHed → OrderDtl** | Connects the sales order header with its corresponding order lines. | A single sales order may contain multiple products or services, each represented as an individual order line. | Provides visibility into the complete list of products requested by the customer and supports line-level analysis. |
| **OrderDtl → OrderRel** | Connects each sales order line with one or more shipment releases. | Epicor ERP manages delivery commitments at the release level, allowing multiple scheduled deliveries for a single order line. | Enables accurate analysis of pending shipments, requested ship dates, release quantities, and overdue deliveries. This relationship is fundamental for production planning and shipping operations. |
| **OrderDtl → Part** | Retrieves descriptive product information from the Part Master. | Part numbers alone are not sufficient for business users to identify products quickly. | Improves report readability and allows users to understand the products included in each sales order without additional lookups. |

### Design Decision

The relationship between **OrderDtl** and **OrderRel** represents the core of this implementation.

Rather than analyzing customer demand exclusively at the sales order or line level, this BAQ evaluates open demand at the **release level**, where Epicor ERP manages shipment schedules and customer delivery commitments.

This design provides a more accurate representation of operational activities because production planning, shipping, and customer service teams typically manage deliveries based on releases rather than entire sales orders.

### Best Practice

When designing BAQs for operational analysis, it is recommended to use the **lowest business level that supports the required decision-making process**.

For sales order management, the release level offers the greatest visibility into customer commitments because it captures shipment schedules, open quantities, and delivery dates. This approach improves the accuracy of dashboards, reports, and operational planning while reducing the need for additional calculations in downstream solutions.

## 5.4 Calculated Fields

### Why Calculated Fields Were Necessary

The standard fields available in Epicor provided the required transactional information, but several business indicators needed to be derived to make the report more meaningful for production planners and customer service teams.

Instead of requiring users to export data to spreadsheets for additional calculations, the necessary metrics were generated directly within the BAQ. This approach delivers actionable information at the source, reduces manual work, and improves consistency across departments.

### Calculated Fields

| Calculated Field          | Purpose                                                                                                                                                                                        |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **OpenOrderValue**        | Calculates the monetary value that remains pending to ship.                                                                                                                                    |
| **RemainingQuantity**     | Determines the quantity that is still open after completed shipments.                                                                                                                          |
| **DaysUntilNeedBy**       | Calculates the number of days remaining before the requested delivery date.                                                                                                                    |
| **OrderStatus**           | Displays a business-friendly status based on shipment progress and remaining quantities.                                                                                                       |
| **ShipmentCompletionPct** | Calculates the percentage of the ordered quantity that has already been shipped, allowing users to quickly evaluate fulfillment progress.                                                      |
| **AvgDaysToShip**         | Estimates the shipping cycle time by calculating the elapsed days between the order date and the shipment date, providing a useful operational performance indicator at the transaction level. |

### Example Expressions

#### Remaining Quantity

```sql
OrderDtl.OrderQty - OrderDtl.OurShipQty
```

#### Open Order Value

```sql
(OrderDtl.OrderQty - OrderDtl.OurShipQty) * OrderDtl.DocUnitPrice
```

#### Days Until Required Date

```sql
DATEDIFF(day, Today(), OrderDtl.NeedByDate)
```

#### Shipment Completion Percentage

```sql
CASE
    WHEN OrderDtl.OrderQty = 0 THEN 0
    ELSE (OrderDtl.OurShipQty * 100.0) / OrderDtl.OrderQty
END
```

#### Estimated Days to Ship

```sql
DATEDIFF(day, OrderHed.OrderDate, ShipHead.ShipDate)
```

#### Business Status

```sql
CASE
    WHEN RemainingQuantity = 0 THEN 'Completed'
    WHEN RemainingQuantity > 0 AND DaysUntilNeedBy <= 0 THEN 'Overdue'
    ELSE 'Open'
END
```

### Implementation Insight

The calculated fields were designed to transform transactional data into meaningful business information that supports day-to-day operational decisions. Rather than presenting only quantities and dates, the BAQ answers practical questions that production planners, customer service representatives, and operations managers typically ask:

* How much of the order is still pending?
* What is the remaining financial commitment?
* Which orders require immediate attention?
* How far has each order progressed?
* How long is the current shipping cycle?

Providing these insights directly within the BAQ reduces the need for manual spreadsheet calculations and enables faster, more informed decision-making.

### Design Decision

The `AvgDaysToShip` calculated field was intentionally included as a transaction-level operational indicator rather than an aggregated performance metric.

Its primary purpose is to provide users with immediate visibility into the elapsed shipping cycle for individual customer orders.

Future analytical BAQs may extend this concept by using aggregation functions (such as `AVG`) and grouping to evaluate shipping performance by customer, product line, or other business dimensions.

### Business Impact

The calculated fields transformed the BAQ from a simple data extraction tool into an operational decision-support solution.

Users can immediately identify open commitments, monitor fulfillment progress, estimate shipping performance, and prioritize orders requiring attention without exporting data for additional analysis. This improves reporting efficiency, increases data consistency, and provides greater visibility into the order fulfillment process.

### Future Enhancement

This implementation establishes the foundation for more advanced operational reporting.

Future versions could incorporate aggregated performance indicators, customer service metrics, backlog analysis, and trend reporting to support strategic decision-making while reusing the same business logic developed in this BAQ.


## 5.5 Runtime Parameters

### Parameter Strategy

This BAQ was intentionally designed without runtime parameters.

Its primary purpose is to provide production planners, customer service representatives, and operations teams with an immediate view of all open sales orders requiring attention. Since this report is intended to be used throughout the day as an operational dashboard, requiring users to enter parameters before execution would introduce unnecessary steps and reduce efficiency.

By returning all relevant open orders automatically, the BAQ delivers consistent information across departments while simplifying daily operational reviews.

### Future Enhancements

If future business requirements demand more specific analysis, optional runtime parameters can be incorporated without modifying the overall query structure. Examples include:

- Customer ID
- Sales Representative
- Order Date Range
- Need By Date Range
- Product Group
- Plant or Warehouse

This design keeps the current BAQ simple and operational while allowing future scalability as reporting requirements evolve.

## 5.6 Filter Criteria

### Why Filter Criteria Were Necessary

A well-designed Business Activity Query should return only the information that supports the business objective. Retrieving unnecessary records increases processing time, complicates data analysis, and may lead users to make decisions based on irrelevant information.

For this reason, the BAQ includes a set of filters that focus exclusively on active sales orders requiring operational attention.

### Filter Criteria

| Filter                                 | Business Purpose                                                                                                                                                      |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Order Open = True**                  | Includes only sales orders that still have pending activities or shipments. Closed orders are excluded because they no longer require operational follow-up.          |
| **RemainingQuantity > 0**              | Returns only order lines with quantities still pending to ship, allowing planners to focus on outstanding commitments.                                                |
| **OrderHeld = False** *(Optional)*     | Excludes orders that have been placed on hold, preventing them from appearing in the operational review until they are released.                                      |
| **NeedByDate >= Today()** *(Optional)* | Focuses the report on current and upcoming customer commitments. Depending on business requirements, overdue orders may also be included for exception management.    |
| **Company = Current Company**          | Ensures that the BAQ retrieves information only for the active company environment, supporting organizations with multiple companies within the same Epicor database. |

### Implementation Insight

The filtering strategy was designed to reduce noise and highlight only the records that require action. Instead of presenting every sales order stored in the ERP, the BAQ focuses on open commitments that influence production scheduling, inventory planning, and customer delivery performance.

Each filter contributes to improving report usability while reducing the amount of information users must review during their daily operations.

### Business Impact

Applying meaningful filter criteria transforms the BAQ into a focused operational report rather than a complete transaction listing.

Users can immediately concentrate on orders that require planning, production, or shipping activities, reducing report review time and improving decision-making across production, customer service, and logistics teams.


## 5.7 Expected Output

### Report Objective

The objective of this BAQ is to provide a clear and actionable view of open sales orders that require operational attention. The information returned should allow users to quickly evaluate order status, shipping progress, and upcoming customer commitments without navigating through multiple Epicor screens.

### Information Presented

The report is expected to display the following key business information for each sales order line:

| Information | Business Purpose |
|-------------|------------------|
| Sales Order Number | Identifies the customer order. |
| Customer ID | Identifies the customer associated with the order. |
| Customer Name | Allows users to recognize the customer without additional lookups. |
| Part Number | Identifies the requested product. |
| Part Description | Provides a meaningful description of the item being produced or shipped. |
| Order Quantity | Displays the quantity originally requested by the customer. |
| Quantity Shipped | Indicates the quantity already fulfilled. |
| Remaining Quantity | Highlights the quantity still pending shipment. |
| Shipment Completion % | Shows overall fulfillment progress. |
| Need By Date | Indicates the customer's requested delivery date. |
| Estimated Days to Ship | Provides visibility into the current shipping cycle. |
| Open Order Value | Displays the financial value still pending shipment. |
| Order Status | Provides a business-friendly operational status. |

### Suggested Sorting

To improve usability, the report should be sorted using the following priority:

1. **Need By Date (Ascending)** — Orders with the closest delivery dates appear first.
2. **Customer Name (Ascending)** — Groups customer orders together for easier review.
3. **Sales Order Number (Ascending)** — Keeps related order lines organized.

This sorting strategy allows production planners and customer service representatives to identify urgent customer commitments immediately while maintaining a logical report structure.

### Expected User Experience

The BAQ should provide enough information for users to answer common operational questions without opening additional Epicor forms, including:

- Which orders require immediate attention?
- How much remains to be shipped?
- Which customer commitments are approaching?
- What is the current fulfillment progress?
- What is the remaining financial commitment?
- Which orders may require production or logistics follow-up?

### Implementation Insight

The expected output was designed to prioritize business readability over technical complexity. Rather than exposing every available database field, only information that contributes to operational decision-making was included.

This approach produces a cleaner report, reduces unnecessary data, and allows users to focus on the information that directly supports production planning and customer fulfillment.

### Business Impact

By presenting operational, scheduling, and financial indicators within a single report, the BAQ becomes a practical decision-support tool rather than a simple data listing.

Production planners, customer service teams, and operations managers can monitor order progress, prioritize daily activities, and respond to customer commitments more efficiently using a single, consolidated source of information.

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
