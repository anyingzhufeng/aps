-- ================================================================
-- 031_mst_quality_check.sql
-- 质量检验标准表（MQC）
-- ================================================================

-- 注意：本文件用于验证 write 工具是否正常工作

-- 1. 质量检验标准表（MQC）
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE mst_quality_check (
    id              BIGINT          NOT NULL    PRIMARY KEY,
    qc_code         VARCHAR(64)     NOT NULL    COMMENT '质检标准编号',
    qc_name         NVARCHAR(200)   NOT NULL    COMMENT '质检标准名称',
    qc_type         TINYINT         NOT NULL    DEFAULT 1 COMMENT '质检类型：1=来料检验IQ，2=过程检验IPQC，3=出货检验OQC',
    check_item      NVARCHAR(500)   NULL        COMMENT '检验项目',
    check_method    NVARCHAR(500)   NULL        COMMENT '检验方法',
    sample_size     INT             NULL        COMMENT '抽样数量',
    aql_level       DECIMAL(3,2)    NULL        COMMENT 'AQL接受质量限',
    spec_min        DECIMAL(18,4)   NULL        COMMENT '规格下限',
    spec_max        DECIMAL(18,4)   NULL        COMMENT '规格上限',
    unit            VARCHAR(20)     NULL        COMMENT '计量单位',
    is_active       TINYINT         NOT NULL    DEFAULT 1,
    created_by      VARCHAR(64)     NULL,
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by      VARCHAR(64)     NULL,
    updated_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_qc_code (qc_code),
    KEY idx_qc_type (qc_type),
    KEY idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='质量检验标准表';

-- 2. 质量检验结果表（QR）
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE qc_inspection_result (
    id              BIGINT          NOT NULL    PRIMARY KEY,
    qc_id           BIGINT          NOT NULL    COMMENT '关联质检标准ID',
    inspect_no      VARCHAR(64)     NOT NULL    COMMENT '检验单编号',
    lot_no          VARCHAR(100)    NULL        COMMENT '批次号',
    inspect_count   INT             NULL        COMMENT '检验数量',
    defect_count    INT             NULL        COMMENT '缺陷数量',
    inspect_result  TINYINT         NOT NULL    COMMENT '检验结果：1=通过，2=拒收，3=特采',
    inspector       VARCHAR(64)     NULL        COMMENT '检验员',
    inspect_time    DATETIME        NULL        COMMENT '检验时间',
    remark          NVARCHAR(500)   NULL        COMMENT '备注',
    is_active       TINYINT         NOT NULL    DEFAULT 1,
    created_by      VARCHAR(64)     NULL,
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by      VARCHAR(64)     NULL,
    updated_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_inspect_no (inspect_no),
    KEY idx_qc_id (qc_id),
    KEY idx_inspect_result (inspect_result),
    KEY idx_inspect_time (inspect_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='质量检验结果表';
