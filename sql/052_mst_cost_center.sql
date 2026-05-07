-- ============================================================
-- 052: mst_cost_center（成本中心表）
-- ============================================================

CREATE TABLE mst_cost_center (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    cost_center_code    VARCHAR(64)     NOT NULL    COMMENT '成本中心编码',
    cost_center_name    NVARCHAR(200)   NOT NULL    COMMENT '成本中心名称',
    cost_center_name_en VARCHAR(200)    NULL        COMMENT '成本中心英文名',
    dept_id             BIGINT          NULL        COMMENT '关联部门ID（mst_department.id）',
    parent_id           BIGINT          NULL        COMMENT '父成本中心ID（self-reference）',
    cost_center_type    VARCHAR(32)     NULL        COMMENT '成本中心类型：PRODUCTION=生产，SUPPORT=支持，MANAGEMENT=管理，SALES=销售',
    manager_employee_id BIGINT          NULL        COMMENT '负责人员工ID',
    budget_amount       DECIMAL(15,2)   NULL        COMMENT '预算金额',
    currency_code       VARCHAR(8)      NOT NULL    DEFAULT 'CNY' COMMENT '币种',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    sort_order          INT             NOT NULL    DEFAULT 0,
    remarks             NVARCHAR(500)   NULL,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_cost_center_code (cost_center_code),
    KEY idx_dept_id      (dept_id),
    KEY idx_parent_id    (parent_id),
    KEY idx_is_active    (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成本中心表';

-- 初始化示例数据
INSERT INTO mst_cost_center (id, cost_center_code, cost_center_name, cost_center_type, is_active, sort_order) VALUES
    (1,  'CC-1001', '生产一部',      'PRODUCTION', 1, 1),
    (2,  'CC-1002', '生产二部',      'PRODUCTION', 1, 2),
    (3,  'CC-2001', '研发部',        'SUPPORT',    1, 3),
    (4,  'CC-3001', '人力资源部',    'MANAGEMENT', 1, 4),
    (5,  'CC-4001', '销售一部',      'SALES',       1, 5);
