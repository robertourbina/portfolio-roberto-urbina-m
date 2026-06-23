# BAQ Example: Labor Efficiency Dashboard

## Business Scenario

This BAQ was designed to help production supervisors analyze labor efficiency by comparing estimated production hours against actual labor hours reported on manufacturing jobs.

The goal of this query is to provide visibility into how efficiently labor time is being used on the shop floor. This information helps the business identify jobs or operations that are consuming more time than expected and supports continuous improvement initiatives.

## Business Question

Which manufacturing jobs or operations are using more labor hours than originally estimated?

## Epicor Tables Used

| Table | Purpose |
|---|---|
| JobHead | Stores manufacturing job header information. |
| JobOper | Stores operation details and estimated production hours. |
| LaborDtl | Stores actual labor transactions reported by employees. |

## Table Relationships

JobHead is related to JobOper by the job number.

JobOper is related to LaborDtl by the job number, assembly sequence, and operation sequence.

The query starts from the manufacturing job, connects each job to its operations, and then connects each operation to the actual labor transactions reported on the shop floor.

## Selected Fields

| Field | Description |
|---|---|
| JobHead.JobNum | Manufacturing job number. |
| JobHead.PartNum | Part number being manufactured. |
| JobHead.ProdQty | Planned production quantity. |
| JobOper.AssemblySeq | Assembly sequence related to the operation. |
| JobOper.OprSeq | Operation sequence number. |
| JobOper.OpCode | Operation code. |
| JobOper.EstProdHours | Estimated production hours for the operation. |
| LaborDtl.EmployeeNum | Employee number that reported labor. |
| LaborDtl.LaborHrs | Actual labor hours reported. |
| LaborDtl.ClockInDate | Date when the labor transaction was reported. |

## Calculated Fields

A calculated field is added to compare estimated hours against actual hours.

Field name:

LaborVarianceHours

Formula:

LaborDtl.LaborHrs - JobOper.EstProdHours

A second calculated field is added to calculate labor efficiency percentage.

Field name:

LaborEfficiencyPercent

Formula:

(JobOper.EstProdHours / LaborDtl.LaborHrs) * 100

## Filter Criteria

The BAQ should only show labor transactions related to production jobs.

Suggested conditions:

LaborDtl.JobNum is not blank

LaborDtl.LaborHrs > 0

These filters remove non-job labor records and avoid calculations where actual labor hours are zero.

## Sample Result

| Job Number | Part Number | Operation | Estimated Hours | Actual Hours | Variance Hours | Efficiency % |
|---|---|---:|---:|---:|---:|---:|
| J100245 | FG-100 | 10 | 8.00 | 10.50 | 2.50 | 76.19 |
| J100317 | FG-250 | 20 | 6.00 | 7.25 | 1.25 | 82.76 |
| J100451 | FG-500 | 30 | 12.00 | 9.50 | -2.50 | 126.32 |

## Business Value

This BAQ provides a clear view of labor efficiency by job and operation.

It helps production supervisors identify operations that require more labor time than expected, helps management review productivity trends, and helps continuous improvement teams focus on areas where labor performance can be improved.

The main value of this BAQ is that it converts labor transaction data into actionable information for production efficiency analysis.

## Functional Area

Manufacturing Operations  
Shop Floor Control  
Labor Reporting  
Continuous Improvement

## Complexity Level

Advanced

This BAQ includes job operation data, labor transaction data, calculated variance, efficiency percentage logic, and production performance analysis.

## Skills Demonstrated

### Epicor ERP Knowledge

- Job Management
- Labor Entry
- Manufacturing Operations
- Shop Floor Control

### BAQ Development Skills

- Multi-table joins
- Calculated fields
- Labor transaction analysis
- Variance calculation
- Efficiency percentage calculation

### Business Analysis Skills

- Labor efficiency analysis
- Production performance monitoring
- Operational variance review
- Continuous improvement support

### Technical Skills

- Epicor Kinetic BAQ Designer
- ERP manufacturing reporting
- Data modeling
- Dashboard-ready dataset creation
