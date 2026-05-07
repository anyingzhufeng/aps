-- ============================================================
-- 054: mst_quality_check（质检项目定义表）
-- ============================================================

CREATE TABLE mst_quality_check (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键',
    check_code      VARCHAR(50)     NOT NULL COMMENT '质检项目编码',
    check_name      NVARCHAR(100)   NOT NULL COMMENT '质检项目名称',
    check_type      VARCHAR(20)     NOT NULL DEFAULT 'INSPECTION' COMMENT '类型: INSPECTION/MEASUREMENT/TEST',
    apply_to        VARCHAR(20)     NOT NULL COMMENT '适用对象: PRODUCT/ITEM/WO/MATERIAL',
    spec_min        DECIMAL(18,4)   DEFAULT NULL COMMENT '规格下限',
    spec_max        DECIMAL(18,4)   DEFAULT NULL COMMENT '规格上限',
    spec_value      DECIMAL(18,4)   DEFAULT NULL COMMENT '规格值（固定值）',
    unit            VARCHAR(20)     DEFAULT NULL COMMENT '计量单位',
    sampling_rate   DECIMAL(5,4)    DEFAULT 1.0000 COMMENT '抽检比例',
    severity        VARCHAR(10)     NOT NULL DEFAULT 'NORMAL' COMMENT '严重等级: CRITICAL/MAJOR/MINOR/NORMAL',
    is_active       TINYINT(1)      NOT NULL DEFAULT 1 COMMENT '是否启用',
    remark          NVARCHAR(500)   DEFAULT NULL COMMENT '备注',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(50)     NOT NULL DEFAULT 'system' COMMENT '创建人',
    updated_by      VARCHAR(50)     NOT NULL DEFAULT 'system' COMMENT '更新人',
    version         INT             NOT NULL DEFAULT 0 COMMENT '版本号（乐观锁）',
    is_deleted      TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '软删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_check_code (check_code),
    KEY idx_apply_to (apply_to),
    KEY idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='质检项目定义表';

-- ============================================================
-- 055: mst_quality_inspection（质检记录表）
-- ============================================================

CREATE TABLE mst_quality_inspection (
    id                  BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键',
    inspection_no       VARCHAR(50)     NOT NULL COMMENT '质检单号',
    inspection_type     VARCHAR(20)     NOT NULL COMMENT '质检类型: IQC/OQC/IPQC/FQC',
    source_type         VARCHAR(20)     NOT NULL COMMENT '来源类型: WORK_ORDER/PURCHASE/TRANSFER',
    source_no           VARCHAR(50)     NOT NULL COMMENT '来源单号',
    item_id             BIGINT          DEFAULT NULL COMMENT '物料/产品ID（mst_item.id）',
    workshop_id         BIGINT          DEFAULT NULL COMMENT '车间ID（mst_workshop.id）',
    workcenter_id       BIGINT          DEFAULT NULL COMMENT '产线ID（mst_workcenter.id）',
    machine_id          BIGINT          DEFAULT NULL COMMENT '设备ID（mst_machine.id）',
    inspector_id        VARCHAR(50)     DEFAULT NULL COMMENT '质检员账号',
    inspection_date     DATE            NOT NULL COMMENT '质检日期',
    sample_size         INT             NOT NULL DEFAULT 1 COMMENT '抽样数量',
    qualified_qty       INT             NOT NULL DEFAULT 0 COMMENT '合格数量',
    defective_qty       INT             NOT NULL DEFAULT 0 COMMENT '不合格数量',
    pass_rate           DECIMAL(5,2)    DEFAULT NULL COMMENT '合格率（%）',
    result_status       VARCHAR(20)     NOT NULL DEFAULT 'PENDING' COMMENT '质检结果: PENDING/PASS/FAIL/REWORK',
    check_point_id      BIGINT          DEFAULT NULL COMMENT '质检点ID（mst_quality_check.id）',
    actual_value        DECIMAL(18,4)   DEFAULT NULL COMMENT '实测值',
    is_within_spec      TINYINT(1)      DEFAULT NULL COMMENT '是否在规格内',
    defect_description  NVARCHAR(500)   DEFAULT NULL COMMENT '不合格描述',
    disposition         VARCHAR(20)     DEFAULT NULL COMMENT '处置方式: ACCEPT/REJECT/REWORK/RETURN',
    remark              NVARCHAR(500)   DEFAULT NULL COMMENT '备注',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by          VARCHAR(50)     NOT NULL DEFAULT 'system' COMMENT '创建人',
    updated_by          VARCHAR(50)     NOT NULL DEFAULT 'system' COMMENT '更新人',
    version             INT             NOT NULL DEFAULT 0 COMMENT '版本号（乐观锁）',
    is_deleted          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '软删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_inspection_no (inspection_no),
    KEY idx_inspection_type (inspection_type),
    KEY idx_source (source_type, source_no),
    KEY idx_inspection_date (inspection_date),
    KEY idx_result_status (result_status),
    KEY idx_item_id (item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='质检记录表';