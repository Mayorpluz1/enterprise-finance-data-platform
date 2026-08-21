# Enterprise Finance Data Platform

Production-Grade Multi-Source Data Engineering Solution on Microsoft Fabric

End-to-end metadata-driven data platform integrating heterogeneous finance and ERP systems into a governed Lakehouse architecture for trusted analytics and enterprise reporting.


# Project Overview

This project demonstrates the design and implementation of a production-oriented enterprise data platform built on Microsoft Fabric to consolidate fragmented financial and operational data from multiple business entities and source systems.

The platform implements a metadata-driven ingestion framework, Medallion Architecture (Bronze, Silver and Gold), incremental data processing, data quality validation, audit logging, error handling, orchestration, dimensional modelling and semantic reporting.

The solution is designed around real-world Data Engineering principles including scalability, maintainability, observability, recoverability and data reliability.

# Business Problem

A multi-entity organisation operating across the United Kingdom, Spain and Czech Republic maintains financial and operational data across multiple independent systems.

The fragmented architecture creates several challenges:

* Inconsistent reporting across business entities
* Manual data consolidation and reconciliation
* Multiple versions of business-critical metrics
* Limited visibility into data pipeline failures
* Repeated ingestion and transformation logic
* Difficulty tracing data from source systems to reporting
* Limited scalability when onboarding additional datasets

The objective of this project is to engineer a centralised, governed and scalable data platform that provides a reliable single source of truth for downstream analytics and reporting.

![Enterprise Finance Data Platform Architecture](enterprise-finance-data-platform-architecture.png)
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

* Metadata & Configuration Management — controls source onboarding and pipeline behaviour
* Data Quality & Reconciliation — validates completeness, consistency and business rules
* Audit Logging — captures pipeline execution, processing status and record-level metrics
* Error Handling & Recoverability — captures failures and supports controlled reruns
* Monitoring & Observability — provides visibility into pipeline health and failed processing stages
* Incremental Processing — reduces unnecessary reprocessing through watermark-driven ingestion and Delta MERGE

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

![Master Pipeline End-to-End Execution](master-pipeline-end-to-end-execution.png)

### Dependency-Aware Silver Transformation

Silver-layer processing is orchestrated according to data dependencies. Foundational dimensions are processed before dependent dimensions and fact datasets to support referential integrity and controlled transformation sequencing.

The pipeline coordinates notebook-based transformations across dimensions, transactional facts and downstream datasets.

![Silver Layer Transformation Pipeline](silver-layer-transformation-pipeline.png)

## Incremental Ingestion & Watermark Management

The platform implements metadata-driven incremental ingestion to minimise unnecessary source extraction and support reliable restartable processing.

### Metadata-Driven Incremental Pipeline

The QuickBooks ingestion pipeline retrieves incremental configuration from the metadata control layer, executes the parameterised ingestion notebook, and updates watermark state only after successful processing.

![Metadata-Driven Incremental Pipeline](metadata-driven-incremental-pipeline.png)

### Watermark Resolution Logic

Incremental extraction windows are resolved dynamically for each configured entity. The implementation reads the previous successful watermark, supports initial seeding for new entities, applies a configurable overlap to protect against timestamp boundary conditions, and calculates the effective extraction start time for each run.

![Incremental Watermark Logic](incremental-watermark-logic.png)
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

![Enterprise Finance Semantic Model](enterprise-finance-semantic-model.png)

## Analytics & Business Outcomes

The Power BI reporting layer consumes the curated Gold-layer data through the enterprise semantic model, providing a consistent view of financial and operational performance across the organisation.

The reporting solution enables stakeholders to analyse:

- Revenue and profitability performance
- Budget versus actual performance
- Customer and product performance
- Accounts receivable and cash collection
- Inventory performance
- Financial position and general ledger reporting

The semantic model centralises business measures and reporting logic, ensuring that dashboards use consistent definitions across business entities.


## Analytics & Business Consumption

The curated Gold-layer datasets are exposed through a Power BI semantic model, providing a consistent analytical layer across the three business entities.

The reporting layer supports executive and finance analysis across revenue, gross margin, budget performance, customers, products and financial position.

![Executive Financial Overview](executive-financial-overview.png)

The dashboard demonstrates the final consumption path of the platform:

**Source Systems → Bronze → Silver → Gold → Semantic Model → Power BI**

Rather than embedding business logic independently within individual reports, reusable measures and analytical relationships are maintained through the semantic model to provide consistent reporting across the platform.

## Data Quality & Validation

Data quality controls are integrated into the processing lifecycle to validate data before it is consumed by downstream reporting.

Validation results are captured and exposed through an operational dashboard, providing visibility into passed and failed checks, expected and observed values, and validation timestamps.

![Data Quality and Validation](data-quality-validation.png)

This provides an auditable view of data quality and helps identify issues before unreliable data reaches business reporting.

## Pipeline Monitoring & Observability

Pipeline execution metadata is captured to provide operational visibility across the platform.

The monitoring layer tracks pipeline runs, execution status, processing duration, records written and source-object activity, enabling failed or abnormal processing to be identified and investigated.

![Pipeline Operations and Monitoring](pipeline-operations-monitoring.png)

This closes the operational loop between ingestion, transformation and reporting by making pipeline health and data-processing outcomes visible from a central monitoring view.
