-- ============================================================
-- 050: mst_cost_element（成本要素表）
-- ============================================================

CREATE TABLE mst_cost_element (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    element_code        VARCHAR(64)     NOT NULL    COMMENT '成本要素编码',
    element_name        NVARCHAR(100)   NOT NULL    COMMENT '成本要素名称',
    element_type        VARCHAR(32)     NOT NULL    COMMENT '类型：MATERIAL=材料，LABOR=人工，OVERHEAD=制造费用，ENERGY=能源，MAINTENANCE=维护，其他=OTHER',
    category            VARCHAR(32)     NULL        COMMENT '分类：DIRECT=直接，INDIRECT=间接',
    unit_cost           DECIMAL(12,4)   NULL        COMMENT '标准单位成本',
    currency            VARCHAR(10)     NOT NULL    DEFAULT 'CNY',
    cost_unit           VARCHAR(20)     NULL        COMMENT '成本单位：PCS=件，KG=千克，HOUR=小时，SET=套',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    sort_order          INT             NOT NULL    DEFAULT 0,
    remarks             NVARCHAR(500)   NULL,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_element_code (element_code),
    KEY idx_element_type (element_type),
    KEY idx_is_active   (is_active),
    KEY idx_category    (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成本要素表';

-- 初始化成本要素数据（示例）
INSERT INTO mst_cost_element (id, element_code, element_name, element_type, category, sort_order) VALUES
    (1,  'MAT_001',    '原材料成本',        'MATERIAL',   'DIRECT',   1),
    (2,  'LAB_001',    '直接人工成本',      'LABOR',      'DIRECT',   2),
    (3,  'MAT_002',    '辅料成本',          'MATERIAL',   'INDIRECT', 3),
    (4,  'ENG_001',    '能源成本（电）',     'ENERGY',     'INDIRECT', 4),
    (5,  'ENG_002',    '能源成本（气）',    'ENERGY',     'INDIRECT', 5),
    (6,  'MNT_001',    '设备维护成本',      'MAINTENANCE','INDIRECT', 6),
    (7,  'OVH_001',    '制造费用（其他）',  'OVERHEAD',   'INDIRECT', 7),
    (8,  'OTH_001',    '其他成本',          'OTHER',      'INDIRECT', 8);