# BAQ Example: Late Jobs Report

## Business Scenario

This BAQ was designed to help production planners and supervisors identify manufacturing jobs that are behind schedule.

The goal of this query is to provide visibility into released jobs that have passed their required due date and are not yet closed. This information helps the business prioritize delayed jobs, review production bottlenecks, and take corrective action before customer delivery dates are impacted.

## Business Question

Which manufacturing jobs are currently late and require immediate attention from the production team?

## Epicor Tables Used

| Table | Purpose |
|---|---|
| JobHead | Stores manufacturing job header information. |
| JobOper | Stores operation details related to each manufacturing job. |
| Part | Stores part master information, including part descriptions. |

## Table Relationships

JobHead is related to Part by the part number.

JobHead is related to JobOper by the job number.

The query starts from the job header, connects each job to its manufactured part, and then connects each job to its production operations.

## Selected Fields

| Field | Description |
|---|---|
| JobHead.JobNum | Manufacturing job number. |
| JobHead.PartNum | Part number being manufactured. |
| Part.PartDescription | Description of the manufactured part. |
| JobHead.ProdQty | Planned production quantity. |
| JobHead.ReqDueDate | Required due date for the job. |
| JobHead.JobReleased | Indicates whether the job has been released to production. |
| JobHead.JobClosed | Indicates whether the job has been closed. |
| JobOper.OprSeq | Operation sequence number. |
| JobOper.OpCode | Operation code. |
| JobOper.EstProdHours | Estimated production hours for the operation. |
| JobOper.ActProdHours | Actual production hours reported for the operation. |

## Calculated Field

A calculated field is added to show how many days late the job is.

Field name:

DaysLate

Formula:

Today() - JobHead.ReqDueDate

## Filter Criteria

The BAQ should only show jobs that have been released, are not closed, and have a required due date earlier than today.

Suggested conditions:

JobHead.JobReleased = True

JobHead.JobClosed = False

JobHead.ReqDueDate < Today()

These filters remove jobs that are not active, jobs that are already closed, and jobs that are not yet late.

You can also sum some days to Today, if you want to know, which ones will be delayed next week.

## Sample Result

| Job Number | Part Number | Description | Production Qty | Due Date | Operation | Estimated Hours | Actual Hours | Days Late |
|---|---|---|---:|---|---:|---:|---:|---:|
| J100245 | FG-100 | Control Panel Assembly | 100 | 2026-05-28 | 10 | 8.00 | 10.50 | 18 |
| J100317 | FG-250 | Industrial Cabinet | 50 | 2026-06-01 | 20 | 6.00 | 7.25 | 14 |
| J100451 | FG-500 | Electrical Enclosure | 80 | 2026-06-07 | 30 | 12.00 | 13.75 | 8 |

## Business Value

This BAQ provides a clear view of late manufacturing jobs.

It helps production planners identify delayed jobs, helps supervisors prioritize shop floor activities, and helps management review production performance.

The main value of this BAQ is that it converts job schedule data into actionable information for daily production control.

## Functional Area

Production Management  
Manufacturing Operations  
Production Planning  
Shop Floor Control

## Complexity Level

Intermediate

This BAQ includes multiple table relationships, date-based calculations, operational filters, and manufacturing reporting logic.

## Skills Demonstrated

### Epicor ERP Knowledge

- Job Management
- Production Planning
- Shop Floor Operations
- Manufacturing Execution

### BAQ Development Skills

- Multi-table joins
- Date calculations
- Calculated fields
- Operational filtering
- Manufacturing reporting

### Business Analysis Skills

- Production monitoring
- Schedule adherence analysis
- Bottleneck identification
- Operational performance reporting

### Technical Skills

- Epicor Kinetic BAQ Designer
- Manufacturing data analysis
- ERP reporting design
- Dashboard-ready dataset creation
