-- ================================================================
-- 032_mst_cost_center.sql
-- 成本中心表（MCC）
-- ================================================================

-- 成本中心表：用于APS与ERP/MES系统对接时，按成本中心统计产能成本
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE mst_cost_center (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    cc_code             VARCHAR(64)     NOT NULL    COMMENT '成本中心编码',
    cc_name             NVARCHAR(200)   NOT NULL    COMMENT '成本中心名称',
    cc_type             TINYINT         NOT NULL    DEFAULT 1 COMMENT '类型：1=生产，2=辅助，3=管理',
    parent_id           BIGINT          NULL        COMMENT '上级成本中心ID（树形）',
    factory_id          BIGINT          NULL        COMMENT '所属工厂ID',
    workshop_id         BIGINT          NULL        COMMENT '所属车间ID（可选）',
    workcenter_id       BIGINT          NULL        COMMENT '所属工作中心ID（可选）',
    manager_account     VARCHAR(64)     NULL        COMMENT '负责人账号',
    cost_rate           DECIMAL(18,4)   NULL        COMMENT '单位时间成本（元/小时）',
    currency            VARCHAR(10)     NOT NULL    DEFAULT 'CNY' COMMENT '币种',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_cc_code (cc_code),
    KEY idx_parent_id   (parent_id),
    KEY idx_factory_id  (factory_id),
    KEY idx_workshop_id (workshop_id),
    KEY idx_is_active   (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成本中心表';

-- 成本中心与资源（设备/人员）关联关系表
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE rel_cost_center_resource (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    cc_id               BIGINT          NOT NULL    COMMENT '成本中心ID',
    resource_type       TINYINT         NOT NULL    COMMENT '资源类型：1=设备，2=人员',
    resource_id         BIGINT          NOT NULL    COMMENT '资源ID（machine_id 或 worker_id）',
    cost_share_ratio    DECIMAL(5,4)    NOT NULL    DEFAULT 1.0000 COMMENT '成本分摊比例',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_cc_resource (cc_id, resource_type, resource_id),
    KEY idx_resource    (resource_type, resource_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成本中心与资源关联表';
