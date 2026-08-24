# Enterprise Finance Data Platform

**Production-Grade Multi-Source Data Engineering Solution on Microsoft Fabric**

End-to-end metadata-driven data platform integrating heterogeneous finance and ERP systems into a governed Lakehouse architecture for trusted analytics and enterprise reporting.

---

## Project Overview

This project demonstrates the design and implementation of a production-oriented enterprise data platform built on Microsoft Fabric to consolidate fragmented financial and operational data from multiple business entities and source systems.

The platform implements a metadata-driven ingestion framework, Medallion Architecture (Bronze, Silver and Gold), incremental data processing, data quality validation, audit logging, error handling, orchestration, dimensional modelling and semantic reporting.

The solution is designed around real-world Data Engineering principles including scalability, maintainability, observability, recoverability and data reliability.

---

## Business Problem

A multi-entity organisation operating across the United Kingdom, Spain and Czech Republic maintains financial and operational data across multiple independent systems.

The fragmented architecture creates several challenges:

- Inconsistent reporting across business entities
- Manual data consolidation and reconciliation
- Multiple versions of business-critical metrics
- Limited visibility into data pipeline failures
- Repeated ingestion and transformation logic
- Difficulty tracing data from source systems to reporting
- Limited scalability when onboarding additional datasets

The objective of this project is to engineer a centralised, governed and scalable data platform that provides a reliable single source of truth for downstream analytics and reporting.

![Enterprise Finance Data Platform Architecture](images/enterprise-finance-data-platform-architecture.png)

---

## Solution Architecture

The platform follows a layered, metadata-driven architecture designed to separate source ingestion, data transformation, business modelling and analytical consumption.

### Architecture Flow

#### Source Systems

SAP Business One (HANA) • QuickBooks Online • SQL Server ERP • SharePoint • REST API

↓

#### Metadata-Driven Ingestion & Orchestration

Configuration-driven pipelines • Lookup • ForEach • Conditional processing • Parameterised ingestion

↓

#### Bronze Layer — Raw

Source-aligned ingestion • Raw historical preservation • Ingestion metadata • Traceability

↓

#### Silver Layer — Validated & Conformed

Schema enforcement • Data cleansing • Deduplication • Business-rule validation • Standardisation • SCD Type 2 where applicable • Incremental Delta MERGE

↓

#### Gold Layer — Business Ready

Dimensional modelling • Fact tables • Dimensions • Business rules • Curated analytical datasets

↓

#### Semantic & Consumption Layer

Power BI Semantic Model • Business KPIs • Enterprise dashboards and reporting

### Cross-Cutting Engineering Controls

The architecture is supported by operational controls across the end-to-end data lifecycle:

- **Metadata & Configuration Management** — controls source onboarding and pipeline behaviour
- **Data Quality & Reconciliation** — validates completeness, consistency and business rules
- **Audit Logging** — captures pipeline execution, processing status and record-level metrics
- **Error Handling & Recoverability** — captures failures and supports controlled reruns
- **Monitoring & Observability** — provides visibility into pipeline health and failed processing stages
- **Incremental Processing** — reduces unnecessary reprocessing through watermark-driven ingestion and Delta MERGE

---

## Pipeline Orchestration & Execution

The master orchestration pipeline coordinates the end-to-end execution of the data platform, from source ingestion through transformation, business modelling and semantic model refresh.

The orchestration sequence includes:

- Execution start logging
- Metadata-driven source discovery
- Dynamic source-system processing
- Silver-layer transformation
- Gold-layer business modelling
- Power BI semantic model refresh
- Final execution status logging

The execution below demonstrates a successful end-to-end platform run.

![Master Pipeline End-to-End Execution](images/master-pipeline-end-to-end-execution.png)

### Dependency-Aware Silver Transformation

Silver-layer processing is orchestrated according to data dependencies. Foundational dimensions are processed before dependent dimensions and fact datasets to support referential integrity and controlled transformation sequencing.

The pipeline coordinates notebook-based transformations across dimensions, transactional facts and downstream datasets.

![Silver Layer Transformation Pipeline](images/silver-layer-transformation-pipeline.png)

---

## Incremental Ingestion & Watermark Management

The platform implements metadata-driven incremental ingestion to minimise unnecessary source extraction and support reliable, restartable processing.

### Metadata-Driven Incremental Pipeline

The QuickBooks ingestion pipeline retrieves incremental configuration from the metadata control layer, executes the parameterised ingestion notebook, and updates watermark state only after successful processing.

![Metadata-Driven Incremental Pipeline](images/metadata-driven-incremental-pipeline.png)

### Watermark Resolution Logic

Incremental extraction windows are resolved dynamically for each configured entity.

The implementation:

- Reads the previous successful watermark
- Supports initial seeding for newly onboarded entities
- Applies a configurable overlap to protect against late-arriving records and timestamp-boundary conditions
- Calculates the effective extraction start time for each run
- Advances the successful watermark only after successful processing

![Incremental Watermark Logic](images/incremental-watermark-logic.png)

This design prevents failed executions from incorrectly advancing the extraction boundary and allows subsequent runs to restart from the previously committed processing state.

---

## Gold Layer & Semantic Model

The Gold layer transforms validated and conformed data into business-ready dimensional structures for enterprise finance analytics.

Curated fact and dimension tables are exposed through the Power BI semantic model, where relationships, business measures and analytical structures provide a consistent reporting layer across the organisation.

Key modelling principles include:

- Conformed dimensions across source systems
- Surrogate keys for dimensional relationships
- Fact tables defined at explicit business grain
- Centralised business measures and calculations
- Controlled relationships between facts and dimensions
- Analytics-ready structures for enterprise reporting

![Enterprise Finance Semantic Model](images/enterprise-finance-semantic-model.png)

---

## Analytics & Business Consumption

The curated Gold-layer datasets are exposed through a Power BI semantic model, providing a consistent analytical layer across the three business entities.

The reporting solution enables stakeholders to analyse:

- Revenue and profitability performance
- Budget versus actual performance
- Customer and product performance
- Accounts receivable and cash collection
- Inventory performance
- Financial position and general ledger reporting

![Executive Financial Overview](images/executive-financial-overview.png)

The dashboard demonstrates the final consumption path of the platform:

**Source Systems → Bronze → Silver → Gold → Semantic Model → Power BI**

Rather than embedding business logic independently within individual reports, reusable measures and analytical relationships are maintained through the semantic model to provide consistent reporting definitions across the platform.

---

## Data Quality & Validation

Data quality controls are integrated into the processing lifecycle to validate data before it is consumed by downstream reporting.

Validation results are captured and exposed through an operational dashboard, providing visibility into:

- Passed and failed validation checks
- Expected and observed values
- Processing status
- Validation timestamps
- Source and dataset context

![Data Quality and Validation](images/data-quality-validation.png)

This provides an auditable view of data quality and helps identify issues before unreliable data reaches business reporting.

---

## Pipeline Monitoring & Observability

Pipeline execution metadata is captured to provide operational visibility across the platform.

The monitoring layer tracks:

- Pipeline execution status
- Start and completion times
- Processing duration
- Records written
- Source-system and source-object activity
- Failed executions and error details

![Pipeline Operations and Monitoring](images/pipeline-operations-monitoring.png)

This closes the operational loop between ingestion, transformation and reporting by making pipeline health and data-processing outcomes visible from a central monitoring view.

---

## Engineering Design Highlights

### Metadata-Driven Processing

Source and entity behaviour is controlled through metadata, allowing ingestion logic to be reused across multiple datasets without duplicating pipeline implementations.

Configuration controls include:

- Source system and company
- Source object
- Source type and connection
- Target Lakehouse, schema and table
- Load strategy
- Processing sequence
- Watermark configuration
- Pagination behaviour where applicable
- Active/inactive processing status

This allows new source objects to be onboarded primarily through configuration rather than creating a separate pipeline for every dataset.

### Full and Incremental Load Strategy

The ingestion framework supports different load strategies based on source and entity requirements.

Initial loads establish the baseline dataset, while subsequent incremental loads process only new or changed records using stored watermark state.

For incremental processing, the last successful watermark is persisted only after successful completion, preventing failed runs from incorrectly advancing the extraction boundary.

### Idempotency & Recoverability

Incremental processing is designed to support safe reruns.

A configurable watermark overlap protects against late-arriving records and timestamp-boundary conditions, while downstream Delta MERGE processing prevents overlapping extraction windows from creating duplicate business records.

Failed executions do not advance the successful watermark, allowing the next run to restart from the previously committed processing state.

### Dependency-Aware Transformation

Transformation workloads are executed according to dataset dependencies.

Foundational dimensions are processed before dependent dimensions and fact tables, helping maintain referential integrity and predictable transformation sequencing across the Silver and Gold layers.

### Data Quality & Reconciliation

Data quality checks are incorporated into the processing lifecycle rather than treated as a reporting-only activity.

Validation results, expected and observed values, processing status and execution timestamps are captured for operational monitoring and investigation.

### Observability

Pipeline and data-processing metrics are persisted for operational monitoring, including execution status, processing duration, records written, validation results and source-object activity.

These metrics feed the Power BI monitoring layer, providing visibility from pipeline execution through to data quality outcomes.

---

## Technology Stack

| Area | Technology |
|---|---|
| Data Platform | Microsoft Fabric |
| Storage | OneLake / Lakehouse |
| Orchestration | Fabric Data Pipelines |
| Processing | PySpark, Python, SQL |
| Table Format | Delta Lake |
| Source Systems | SAP Business One (HANA), QuickBooks Online, SQL Server ERP, SharePoint, REST API |
| Data Architecture | Medallion Architecture |
| Data Modelling | Dimensional Modelling, Star Schema |
| Incremental Processing | Watermark-Based Extraction, Delta MERGE |
| Analytics | Power BI Semantic Model, Power BI |
| Monitoring | Audit Logging, Data Quality Metrics, Pipeline Execution Metrics |
| Version Control | Git / GitHub |

---

## Repository Structure

```text
enterprise-finance-data-platform/
│
├── images/
│   ├── enterprise-finance-data-platform-architecture.png
│   ├── master-pipeline-end-to-end-execution.png
│   ├── silver-layer-transformation-pipeline.png
│   ├── metadata-driven-incremental-pipeline.png
│   ├── incremental-watermark-logic.png
│   ├── enterprise-finance-semantic-model.png
│   ├── executive-financial-overview.png
│   ├── data-quality-validation.png
│   └── pipeline-operations-monitoring.png
│
├── notebooks/
│   ├── 01_qbo_incremental_ingestion.ipynb
│   │   └── Metadata-driven incremental QuickBooks ingestion with watermark management
│   │
│   ├── 02_silver_customer_scd2.ipynb
│   │   └── Silver-layer customer transformation and SCD Type 2 processing
│   │
│   └── 03_gold_business_model.ipynb
│       └── Gold-layer dimensional modelling and business-ready dataset generation
│
├── sql/
│   └── 01_control_tables.sql
│       └── Metadata configuration, watermark tracking and audit/control table definitions
│
└── README.md
    └── Architecture, implementation approach and engineering documentation
```

---

## Key Engineering Outcomes

The implementation demonstrates the following Data Engineering capabilities:

- Consolidated heterogeneous finance and ERP sources into a common Microsoft Fabric data platform.
- Replaced source-specific ingestion patterns with reusable metadata-driven orchestration.
- Implemented parameterised ingestion across multiple source objects.
- Implemented incremental processing with persistent watermark state and controlled restart behaviour.
- Established Bronze, Silver and Gold processing boundaries for raw preservation, conformance and business modelling.
- Implemented SCD Type 2 processing where historical dimensional changes need to be preserved.
- Implemented dependency-aware transformation and Delta MERGE processing.
- Integrated data quality validation and reconciliation into the processing lifecycle.
- Centralised audit logging and pipeline execution monitoring.
- Designed processing for idempotency and controlled reruns.
- Built a dimensional Gold layer for analytics-ready consumption.
- Implemented a reusable Power BI semantic model for cross-entity reporting.
- Exposed both business analytics and platform operational health through Power BI.

---

## Implementation Evidence

The repository contains selected implementation artefacts from the platform rather than only architectural documentation.

### SQL Control Layer

`sql/01_control_tables.sql`

Contains the control and operational metadata structures used by the platform, including configuration, watermark tracking and audit-related definitions.

### Incremental Ingestion

`notebooks/01_qbo_incremental_ingestion.ipynb`

Demonstrates metadata-driven QuickBooks incremental ingestion, watermark resolution and restartable processing.

### Silver Transformation & SCD Type 2

`notebooks/02_silver_customer_scd2.ipynb`

Demonstrates Silver-layer customer conformance and historical change management using SCD Type 2 processing.

### Gold Business Model

`notebooks/03_gold_business_model.ipynb`

Demonstrates Gold-layer dimensional modelling and generation of business-ready analytical datasets.

Together, these artefacts provide implementation evidence across the major platform layers:

**Control Plane → Ingestion → Silver Transformation → Gold Modelling → Semantic Consumption**

---

## Design Principles

The platform was developed around several core engineering principles:

**Configuration over duplication**  
Reusable pipelines are driven by metadata rather than creating independent implementations for every source object.

**Raw data preservation**  
Bronze retains source-aligned data to support traceability, replay and investigation.

**Separation of responsibilities**  
Bronze, Silver and Gold layers have clearly defined responsibilities for ingestion, conformance and business modelling.

**Incremental by design**  
Watermark-based extraction reduces unnecessary processing while maintaining persistent state between executions.

**Failure-safe state management**  
Successful watermark state is advanced only after successful processing.

**Idempotent processing**  
Delta MERGE and controlled extraction windows allow processing to be safely rerun without creating duplicate business records.

**Dependency-aware orchestration**  
Transformation order reflects relationships between dimensions and facts.

**Quality before consumption**  
Data quality and reconciliation controls are integrated into processing rather than left solely to the reporting layer.

**Operational observability**  
Pipeline execution and data-processing metrics are captured to support monitoring, troubleshooting and auditability.

**Centralised business logic**  
Curated Gold models and the Power BI semantic layer provide reusable business definitions across downstream reporting.

---

## End-to-End Platform Flow

```text
Source Systems
      │
      ▼
Metadata & Configuration
      │
      ▼
Fabric Data Pipelines
      │
      ▼
Bronze Layer
Raw / Source-Aligned Data
      │
      ▼
Silver Layer
Validated / Cleansed / Conformed
      │
      ▼
Data Quality & Reconciliation
      │
      ▼
Gold Layer
Dimensions / Facts / Business Rules
      │
      ▼
Power BI Semantic Model
      │
      ▼
Executive & Operational Reporting
```

Across the processing lifecycle, watermark management, audit logging, error handling, data quality controls and monitoring provide the operational framework required for reliable and recoverable data processing.

---

## Project Summary

This project demonstrates the engineering of a multi-source enterprise data platform rather than an isolated ETL pipeline.

The solution combines ingestion, metadata-driven orchestration, incremental processing, Medallion Architecture, data quality, dimensional modelling, semantic modelling and operational monitoring within Microsoft Fabric.

The resulting architecture provides a scalable foundation for integrating heterogeneous finance and ERP systems while maintaining traceability, recoverability, data reliability and consistent analytical definitions across the organisation.
