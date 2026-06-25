
# Require Customer PO Number Before Saving a Sales Order

## Overview

This BPM example demonstrates how to validate that the **Customer PO Number** field is completed before allowing a Sales Order to be saved in Epicor ERP.

The purpose of this validation is to improve data quality, reduce missing customer references, and prevent incomplete orders from continuing through the sales process.

---

## Business Scenario

In many companies, a customer purchase order number is required before processing a sales order.

This information may be used by different departments such as customer service, shipping, accounting, production planning, and invoicing.

If the Customer PO Number is missing, the company may experience delays, invoice disputes, manual corrections, or tracking issues.

---

## Business Requirement

The system must prevent users from saving a Sales Order when the Customer PO Number is empty.

If the field is blank, Epicor should display an error message and stop the transaction.

---

## Proposed Solution

Create a **Pre-Processing Method Directive BPM** on the Sales Order update process.

The BPM will check if the Customer PO Number field is empty. If the field does not contain a value, the BPM will raise an exception and prevent the Sales Order from being saved.

---

## BPM Configuration

| Property             | Value                       |
| -------------------- | --------------------------- |
| Module               | Sales Management            |
| Business Object      | SalesOrder                  |
| Method               | Update                      |
| Directive Type       | Method Directive            |
| Execution Type       | Pre-Processing              |
| Validation           | Customer PO Number is empty |
| Action               | Raise Exception             |
| Custom Code Required | No                          |

---

## Process Flow

```text
User creates or updates a Sales Order
              |
              v
User clicks Save
              |
              v
Pre-Processing BPM executes
              |
              v
Is Customer PO Number empty?
        /              \
      Yes               No
      |                 |
      v                 v
Display error       Save Sales Order
Stop transaction    Continue process
```

---

## Example Validation Logic

```text
IF Customer PO Number is blank
THEN
    Display error message
    Stop the transaction
ELSE
    Allow the Sales Order to be saved
END IF
```

---

## Error Message

```text
Customer PO Number is required before saving the Sales Order.
Please enter a valid Customer PO Number and try again.
```

---

## Test Cases

| Test Case           | Customer PO Number | Expected Result                   | Status |
| ------------------- | ------------------ | --------------------------------- | ------ |
| Valid Sales Order   | PO-45897           | Sales Order is saved successfully | Pass   |
| Missing Customer PO | Blank              | Error message is displayed        | Pass   |
| Spaces only         | "   "              | Error message is displayed        | Pass   |

---

## Expected Result

When the Customer PO Number is completed, the Sales Order can be saved normally.

When the Customer PO Number is empty, Epicor displays an error message and prevents the transaction from being completed.

---

## Business Value

This BPM helps the organization by:

* Improving sales order data accuracy.
* Reducing missing customer references.
* Preventing incomplete orders.
* Supporting better invoice validation.
* Reducing manual corrections.
* Improving communication between departments.

---

## Possible Enhancements

This BPM can be expanded in the future to include additional rules, such as:

* Apply the validation only to specific customers.
* Apply the validation only to specific order types.
* Validate the Customer PO Number format.
* Allow exceptions for internal orders.
* Notify a supervisor when the validation fails.
* Log failed validation attempts for audit purposes.

---

## Skills Demonstrated

### Functional Skills

* Sales Order Management
* Business Process Analysis
* Requirements Interpretation
* ERP Process Control

### Technical Skills

* Epicor BPM
* Method Directives
* Pre-Processing Logic
* Data Validation
* Exception Handling

### Documentation Skills

* Business scenario documentation
* Test case documentation
* ERP solution documentation
* Process flow explanation

---

## Notes

This example is intended for portfolio and learning purposes. The configuration can be adapted depending on the company process, Epicor version, and specific business requirements.

