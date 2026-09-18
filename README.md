Enterprise Finance Data Platform
Production-Oriented Multi-Source Data Engineering Solution on Microsoft Fabric

End-to-end metadata-driven data platform integrating multi-country finance and ERP data into a governed Microsoft Fabric Lakehouse for trusted analytics, financial reporting and operational monitoring.

Table of Contents
Project Overview
Business Problem
Business Requirements
Solution Architecture
Metadata-Driven Ingestion
Pipeline Orchestration and Execution
Incremental Ingestion and Watermark Management
QuickBooks Incremental Ingestion Example
Medallion Architecture
Slowly Changing Dimension Type 2
Gold Dimensional Model
Power BI Semantic Model
Analytics and Business Consumption
Data Quality and Reconciliation
Pipeline Monitoring and Observability
Failure Recovery and Idempotency
Technology Stack
Repository Structure
Implementation Evidence
Engineering Design Principles
Key Engineering Capabilities Demonstrated
End-to-End Platform Flow
Project Summary
Portfolio Context
Project Overview

This project demonstrates the design and implementation of a production-oriented enterprise data platform built on Microsoft Fabric.

The platform consolidates fragmented financial and operational data from multiple business entities and heterogeneous source systems into a centralised analytical platform.

The solution implements:

Metadata-driven ingestion and orchestration
Full and incremental data loading
Persistent watermark management
Medallion Architecture — Bronze, Silver and Gold
PySpark, Python and SQL transformations
Delta Lake and Delta MERGE
Data quality and reconciliation controls
Slowly Changing Dimension Type 2 processing
Dimensional modelling
Failure recovery and idempotent processing
Audit logging and operational monitoring
Power BI semantic modelling and reporting

The engineering design focuses on scalability, maintainability, traceability, recoverability, observability and data reliability.

Business Problem

A multi-entity organisation operating across the United Kingdom, Spain and Czech Republic maintains financial and operational data across independent systems.

The fragmented data landscape creates several challenges:

Manual consolidation of financial and operational data
Inconsistent reporting across business entities
Multiple definitions of business-critical metrics
Repeated source-specific ingestion logic
Limited visibility into pipeline and data-quality failures
Difficulty tracing data from source systems to reporting
Complex onboarding of additional datasets
Limited support for reliable incremental processing

The objective was to design a centralised, governed and scalable data platform that provides a consistent analytical foundation for finance and operational reporting.

Business Requirements

The platform was designed around the following requirements:

Consolidate multi-company financial and operational data into Microsoft Fabric.
Support heterogeneous source technologies.
Reduce duplicated ingestion logic through metadata-driven processing.
Support both full and incremental loading.
Preserve source-aligned historical data for traceability and replay.
Validate data quality before analytical consumption.
Standardise heterogeneous source structures into conformed datasets.
Build reusable dimensions and fact tables around explicit business grain.
Provide consistent KPIs through a reusable Power BI semantic model.
Capture pipeline execution, processing and data-quality metrics.
Support controlled recovery and safe reruns following failures.
Allow new datasets to be onboarded primarily through configuration.
Solution Architecture

The platform follows a layered architecture that separates source ingestion, transformation, business modelling and analytical consumption.




Architecture Flow
SAP Business One (HANA) ──┐
QuickBooks Online ─────────┤
SQL Server ERP ────────────┤
SharePoint / Files ────────┤
REST APIs ─────────────────┘
             │
             ▼
   Metadata & Configuration
             │
             ▼
 Microsoft Fabric Data Pipelines
             │
             ▼
   Full / Incremental Loading
             │
             ▼
┌─────────────────────────────┐
│ BRONZE                      │
│ Raw / Source-Aligned Data   │
│ Historical Preservation     │
└─────────────────────────────┘
             │
             ▼
┌─────────────────────────────┐
│ SILVER                      │
│ Validated / Cleansed        │
│ Standardised / Conformed    │
│ SCD Type 2 where required   │
└─────────────────────────────┘
             │
             ▼
   Data Quality & Reconciliation
             │
             ▼
┌─────────────────────────────┐
│ GOLD                        │
│ Dimensions / Facts          │
│ Business Rules              │
│ Analytics-Ready Models      │
└─────────────────────────────┘
             │
             ▼
     Power BI Semantic Model
             │
             ▼
 Executive & Operational Reporting

Cross-cutting controls provide metadata management, watermark state, audit logging, error handling, data quality, reconciliation and operational monitoring throughout the processing lifecycle.

Metadata-Driven Ingestion

Rather than creating a separate ingestion pipeline for every source object, ingestion behaviour is externalised into metadata and configuration.

Configuration controls characteristics such as:

Source system and company
Source object
Source type and connection
Target Lakehouse, schema and table
Load strategy
Processing sequence
Watermark configuration
Pagination behaviour where applicable
Active or inactive processing status

The orchestration framework reads this metadata dynamically to determine what should run, how it should run and where the data should be written.

This reduces duplicated pipeline logic and allows additional datasets to be onboarded primarily through configuration.

Pipeline Orchestration and Execution

The master orchestration pipeline coordinates processing across the platform.




The execution pattern includes:

Start execution logging.
Read configuration metadata.
Discover active source objects.
Resolve full or incremental load strategy.
Execute Bronze ingestion.
Run dependency-aware Silver transformations.
Build Gold business models.
Execute data-quality and reconciliation controls.
Make curated datasets available for semantic consumption.
Record final execution status and processing metrics.
Dependency-Aware Transformation

Silver-layer processing is orchestrated according to dataset dependencies.




Foundational dimensions are processed before dependent dimensions and fact datasets, supporting referential integrity and predictable transformation sequencing.

Incremental Ingestion and Watermark Management

The platform implements a reusable metadata-driven incremental ingestion strategy for source objects where incremental extraction is supported.




For an incremental execution, the processing framework:

Retrieves the configured source and entity metadata.
Determines the required load strategy.
Reads the last successfully committed watermark.
Resolves the effective extraction window.
Executes the appropriate parameterised ingestion process.
Writes source-aligned data into Bronze.
Records execution and processing metrics.
Advances the successful watermark only after successful processing.
Failure-Safe Watermark Strategy




The successful watermark represents the last committed processing boundary.

The framework:

Reads the previous successful watermark
Supports initial seeding for newly onboarded entities
Applies configurable overlap where required
Calculates the effective extraction start time
Protects against late-arriving records and timestamp-boundary conditions
Keeps successful state independent from failed processing attempts
Advances the successful watermark only after successful completion

If processing fails, the successful watermark is not advanced.

The next execution therefore restarts from the previous committed processing boundary rather than skipping records affected by the failed execution.

Downstream Delta MERGE processing supports safe overlapping extraction windows by updating existing business records or inserting new records instead of blindly appending duplicates.

QuickBooks Incremental Ingestion Example

The repository includes QuickBooks Online as a concrete implementation of the wider incremental-ingestion architecture.

Implementation:

notebooks/01_qbo_incremental_ingestion.ipynb

The notebook demonstrates:

Configuration-driven processing
REST API extraction
Watermark resolution
Incremental extraction windows
Pagination
Bronze persistence
Processing metrics
Controlled failure handling
Restartable processing
Successful-state advancement

QuickBooks is the implementation example; the wider architecture allows equivalent ingestion behaviour to be configured according to the capabilities of other source objects.

Medallion Architecture
Bronze — Raw and Traceable

Bronze preserves source-aligned data with minimal transformation.

Key responsibilities:

Preserve source fidelity
Maintain ingestion metadata
Support replay and investigation
Provide traceability back to source
Preserve the foundation for downstream reprocessing
Silver — Validated and Conformed

Silver transforms heterogeneous source data into validated and standardised enterprise datasets.

Processing includes:

Schema enforcement
Data-type standardisation
Null and completeness validation
Duplicate handling
Business-rule validation
Referential-integrity controls
Cross-source standardisation
Delta MERGE processing
SCD Type 2 where historical attributes must be retained
Gold — Business Ready

Gold provides curated analytical structures designed for business consumption.

The layer contains:

Dimension tables
Fact tables
Explicit business grain
Surrogate-key relationships
Conformed dimensions
Reusable business rules
Analytics-ready datasets
Slowly Changing Dimension Type 2

Historical dimensional changes are preserved where point-in-time analysis is required.

Implementation:

notebooks/02_silver_customer_scd2.ipynb

Instead of overwriting historical attributes, SCD Type 2 processing maintains historical versions while identifying the currently active record.

This supports analytical questions such as:

What customer attributes were valid when a particular transaction occurred?

SCD Type 2 is applied selectively where historical tracking provides analytical value rather than automatically to every dimension.

Gold Dimensional Model

The Gold layer transforms validated and conformed data into business-ready dimensional structures.

Implementation:

notebooks/03_gold_business_model.ipynb

Key modelling principles include:

Explicit fact-table grain
Surrogate keys for dimensional relationships
Conformed dimensions across source systems
Controlled one-to-many relationships
Centralised business calculations
Analytics-ready star-schema structures

The resulting datasets provide the curated foundation for the Power BI semantic model.

Power BI Semantic Model

Curated Gold datasets are exposed through a reusable Power BI semantic model.




The semantic layer centralises:

Fact-to-dimension relationships
Reusable measures
Business calculations
KPI definitions
Cross-entity analytical logic

Centralising analytical definitions helps prevent individual reports from independently implementing conflicting versions of the same business metric.

Analytics and Business Consumption

The reporting layer provides business stakeholders with a consolidated view across the business entities.




Analytical areas include:

Revenue and profitability
Budget versus actual performance
Customer performance
Product performance
Accounts receivable
Cash collection
Inventory performance
Financial position
General ledger reporting

The analytical consumption path is:

Source Systems
      │
      ▼
    Bronze
      │
      ▼
    Silver
      │
      ▼
     Gold
      │
      ▼
Power BI Semantic Model
      │
      ▼
Business Reporting
Data Quality and Reconciliation

Data quality is implemented as an engineering control throughout the processing lifecycle, rather than being left solely to the reporting layer.




Controls include:

Schema validation
Required-field validation
Data-type validation
Null and completeness checks
Duplicate detection
Referential-integrity validation
Business-rule validation
Source-to-target reconciliation
Record-count reconciliation
Validation-result logging

Validation outcomes capture information such as:

Passed and failed checks
Expected and observed values
Processing status
Validation timestamps
Source and dataset context

This helps identify unreliable data before it reaches downstream business reporting.

Pipeline Monitoring and Observability

Pipeline and processing metadata are persisted to provide operational visibility across the platform.




The monitoring layer tracks:

Pipeline execution status
Start and completion timestamps
Processing duration
Records processed or written
Source-system activity
Source-object activity
Failed executions
Error information
Data-quality outcomes

These metrics provide a central operational view for identifying what failed, where it failed and the processing context around the failure.

Failure Recovery and Idempotency

The platform is designed to support controlled reruns following failures.

Failure-Safe State Management

Successful watermark state advances only after successful processing.

A failed execution therefore cannot incorrectly move the starting position of the next incremental run.

Controlled Extraction Overlap

Incremental extraction can intentionally reread a configurable processing window to protect against late-arriving records and timestamp-boundary conditions.

Delta MERGE

Downstream processing uses business keys to update existing records or insert new records instead of blindly appending duplicate records.

Together, these controls support restartable, recoverable and idempotent processing.

Technology Stack
Area	Technology
Data Platform	Microsoft Fabric
Storage	OneLake / Fabric Lakehouse
Orchestration	Fabric Data Pipelines
Processing	PySpark, Python, SQL
Table Format	Delta Lake
Data Architecture	Medallion Architecture
Data Modelling	Dimensional Modelling / Star Schema
Incremental Processing	Metadata-Driven Watermarks / Delta MERGE
Source Patterns	ERP, SQL Database, REST API, SharePoint / Files
Analytics	Power BI Semantic Model / Power BI
Monitoring	Audit Logs / Data Quality / Pipeline Metrics
Version Control	Git / GitHub
Repository Structure
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
│   ├── 02_silver_customer_scd2.ipynb
│   └── 03_gold_business_model.ipynb
│
├── sql/
│   └── 01_control_tables.sql
│
└── README.md
Implementation Evidence

This repository contains selected implementation artefacts rather than architecture documentation alone.

SQL Control Layer

sql/01_control_tables.sql

Contains control and operational metadata structures supporting:

Configuration-driven ingestion
Watermark tracking
Processing state
Auditability

The control layer demonstrates how ingestion behaviour is externalised from pipeline logic and managed through configuration.

Incremental Ingestion

notebooks/01_qbo_incremental_ingestion.ipynb

Provides a concrete QuickBooks Online implementation of the metadata-driven incremental ingestion and watermark strategy.

Silver Transformation and SCD Type 2

notebooks/02_silver_customer_scd2.ipynb

Demonstrates customer conformance and historical change management using SCD Type 2 processing.

Gold Business Model

notebooks/03_gold_business_model.ipynb

Demonstrates dimensional modelling and generation of business-ready analytical datasets.

Together, these artefacts provide implementation evidence across the major platform layers:

Control Layer
     │
     ▼
Ingestion
     │
     ▼
Bronze
     │
     ▼
Silver Transformation
     │
     ▼
Gold Modelling
     │
     ▼
Semantic Consumption
Engineering Design Principles
Configuration Over Duplication

Reusable processing behaviour is driven through metadata rather than duplicated pipeline implementations.

Separation of Responsibilities

Bronze, Silver and Gold have clearly defined responsibilities for ingestion, conformance and business modelling.

Incremental by Design

Where supported by the source, watermark-based extraction avoids unnecessary full reprocessing.

Failure-Safe State Management

Successful processing state advances only after successful execution.

Idempotent Processing

Controlled extraction windows and Delta MERGE support safe reruns.

Dependency-Aware Orchestration

Transformation order reflects dependencies between dimensions and facts.

Quality Before Consumption

Data-quality and reconciliation controls are applied before data reaches analytical consumption.

Operational Observability

Execution and processing metrics provide visibility into pipeline health and data reliability.

Centralised Business Logic

Gold models and the semantic layer provide reusable analytical definitions.

Scalability Through Metadata

New datasets can be onboarded primarily through configuration rather than duplicated orchestration logic.

Key Engineering Capabilities Demonstrated

This project demonstrates practical implementation of:

Microsoft Fabric data engineering
Metadata-driven pipeline architecture
Multi-source data integration
REST API ingestion
Full and incremental loading
Persistent watermark management
PySpark, Python and SQL transformation
Delta Lake and Delta MERGE
Medallion Architecture
SCD Type 2
Dimensional modelling
Data quality and reconciliation
Failure recovery and idempotency
Pipeline monitoring and observability
Power BI semantic modelling
Git-based version control
End-to-End Platform Flow
Source Systems
      │
      ▼
Metadata & Configuration
      │
      ▼
Microsoft Fabric Data Pipelines
      │
      ▼
Full / Incremental Load Resolution
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

Across the processing lifecycle, metadata configuration, watermark management, audit logging, error handling, data-quality controls and monitoring provide the operational framework required for reliable and recoverable processing.

Project Summary

This project demonstrates the engineering of a multi-source enterprise data platform rather than an isolated ETL pipeline.

The solution combines heterogeneous source integration, metadata-driven orchestration, configurable full and incremental ingestion, persistent watermark management, Medallion Architecture, Delta processing, SCD Type 2, dimensional modelling, data quality, operational monitoring and Power BI consumption within Microsoft Fabric.

The architecture separates reusable orchestration and control logic from source-specific implementation, providing a scalable foundation for onboarding additional datasets while maintaining consistent engineering standards.

The resulting platform is designed around data reliability, traceability, recoverability, maintainability and consistent analytical definitions.

Portfolio Context

This repository is a sanitised portfolio implementation based on enterprise finance data-engineering patterns and architecture used in professional project work.

No confidential client data, credentials or proprietary production code are included. The repository uses non-confidential implementation examples to demonstrate the engineering approach, architectural decisions and technical patterns.
