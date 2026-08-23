/* ============================================================
   Enterprise Finance Data Platform
   Control & Audit Table Definitions

   Active control framework:
   - ctl.ingestion_config_v2
   - ctl.watermark_tracker
   - audit.pipeline_execution_log
   - audit.platform_ingestion_audit
   ============================================================ */


/* ============================================================
   1. INGESTION CONFIGURATION
   Defines source, target and load behaviour per source object.
   ============================================================ */

CREATE TABLE ctl.ingestion_config_v2
(
    ingestion_id                INT             NOT NULL,
    source_system               VARCHAR(100)    NOT NULL,
    source_company              VARCHAR(100)    NOT NULL,
    source_type                 VARCHAR(50)     NOT NULL,
    source_connection_name      VARCHAR(200)    NULL,
    source_schema               VARCHAR(100)    NULL,
    source_object               VARCHAR(200)    NOT NULL,
    source_query                VARCHAR(4000)   NULL,

    target_lakehouse            VARCHAR(200)    NOT NULL,
    target_schema               VARCHAR(100)    NOT NULL,
    target_table                VARCHAR(200)    NOT NULL,
    target_line_table           VARCHAR(200)    NULL,

    load_type                   VARCHAR(50)     NOT NULL,
    watermark_column            VARCHAR(200)    NULL,
    last_watermark              DATETIME2       NULL,

    load_sequence               INT             NOT NULL,
    is_active                   BIT             NOT NULL,

    api_query_template          VARCHAR(4000)   NULL,
    response_collection         VARCHAR(200)    NULL,
    page_size                   INT             NULL,
    supports_pagination         BIT             NULL,

    created_date                DATETIME2       NOT NULL,
    modified_date               DATETIME2       NOT NULL
);


/* ============================================================
   2. WATERMARK TRACKER
   Stores only successfully committed incremental state.
   ============================================================ */

CREATE TABLE ctl.watermark_tracker
(
    source_system               VARCHAR(100)    NOT NULL,
    source_company              VARCHAR(100)    NOT NULL,
    source_object               VARCHAR(200)    NOT NULL,

    last_successful_watermark   DATETIME2       NULL,
    last_pipeline_run_id        VARCHAR(200)    NULL,
    last_run_status             VARCHAR(50)     NULL,
    updated_on                  DATETIME2       NULL
);


/* ============================================================
   3. PIPELINE EXECUTION LOG
   Run-level observability for master/orchestration pipelines.
   ============================================================ */

CREATE TABLE audit.pipeline_execution_log
(
    pipeline_run_id             VARCHAR(200)    NULL,
    pipeline_name               VARCHAR(200)    NOT NULL,
    start_time                  DATETIME2       NOT NULL,
    end_time                    DATETIME2       NULL,
    status                      VARCHAR(50)     NOT NULL,

    initiated_by                VARCHAR(200)    NULL,
    trigger_type                VARCHAR(100)    NULL,
    duration_seconds            BIGINT          NULL,
    error_message               VARCHAR(4000)   NULL,
    created_utc                 DATETIME2       NULL
);


/* ============================================================
   4. PLATFORM INGESTION AUDIT
   Source-object/entity-level ingestion monitoring.
   ============================================================ */

CREATE TABLE audit.platform_ingestion_audit
(
    pipeline_run_id             VARCHAR(200)    NOT NULL,
    ingestion_id                BIGINT          NULL,
    pipeline_name               VARCHAR(200)    NOT NULL,

    source_system               VARCHAR(100)    NOT NULL,
    source_company              VARCHAR(100)    NOT NULL,
    source_object               VARCHAR(200)    NOT NULL,
    target_table                VARCHAR(200)    NOT NULL,

    load_type                   VARCHAR(50)     NULL,
    status                      VARCHAR(50)     NOT NULL,
    rows_written                BIGINT          NOT NULL,

    started_utc                 DATETIME2       NOT NULL,
    completed_utc               DATETIME2       NOT NULL,
    duration_seconds            BIGINT          NULL,

    error_message               VARCHAR(4000)   NULL,
    audit_logged_utc            DATETIME2       NOT NULL
);
