-- ============================================================
-- 053: mst_warehouse_location（仓库库位表）
-- ============================================================

CREATE TABLE mst_warehouse_location (
    id              BIGINT          NOT NULL    PRIMARY KEY,
    warehouse_code  VARCHAR(64)     NOT NULL    COMMENT '仓库编码（关联 mst_warehouse.warehouse_code）',
    location_code   VARCHAR(64)     NOT NULL    COMMENT '库位编码',
    location_name   NVARCHAR(200)   NOT NULL    COMMENT '库位名称',
    location_type   VARCHAR(32)     NULL        COMMENT '库位类型：STORAGE=存储区，PICK=拣货区，RECEIVING=收货区，SHIPPING=发货区，STAGE=暂存区，RETURN=退货区',
    zone_code       VARCHAR(32)     NULL        COMMENT '库区编码',
    area_code       VARCHAR(32)     NULL        COMMENT '库区细分编码',
    row_no          INT             NULL        COMMENT '排序号',
    col_no          INT             NULL        COMMENT '列序号',
    level_no        INT             NULL        COMMENT '层序号',
    max_capacity    DECIMAL(15,3)   NULL        COMMENT '最大容量',
    max_weight_kg   DECIMAL(10,3)   NULL        COMMENT '最大承重（kg）',
    width_cm        DECIMAL(8,2)    NULL        COMMENT '宽度（cm）',
    height_cm       DECIMAL(8,2)    NULL        COMMENT '高度（cm）',
    depth_cm        DECIMAL(8,2)    NULL        COMMENT '深度（cm）',
    is_active       TINYINT         NOT NULL    DEFAULT 1,
    sort_order      INT             NOT NULL    DEFAULT 0,
    remarks         NVARCHAR(500)   NULL,
    created_by      VARCHAR(64)     NULL,
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by      VARCHAR(64)     NULL,
    updated_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_warehouse_location (warehouse_code, location_code),
    KEY idx_zone_code    (zone_code),
    KEY idx_is_active   (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='仓库库位表';

-- 初始化示例数据
INSERT INTO mst_warehouse_location (id, warehouse_code, location_code, location_name, location_type, zone_code, row_no, col_no, level_no, is_active, sort_order) VALUES
    (1,  'WH-001', 'A-01-01-01', 'A区原料库1-1-1层',  'STORAGE',  'A', 1,  1,  1, 1, 1),
    (2,  'WH-001', 'A-01-01-02', 'A区原料库1-1-2层',  'STORAGE',  'A', 1,  1,  2, 1, 2),
    (3,  'WH-001', 'A-01-02-01', 'A区原料库1-2-1层',  'STORAGE',  'A', 1,  2,  1, 1, 3),
    (4,  'WH-001', 'B-01-01-01', 'B区成品库1-1-1层',  'STORAGE',  'B', 1,  1,  1, 1, 4),
    (5,  'WH-001', 'PICK-01',    '拣货区01',           'PICK',     'P', 1,  1,  1, 1, 5),
    (6,  'WH-001', 'RCV-01',     '收货区01',           'RECEIVING','R', 1,  1,  1, 1, 6),
    (7,  'WH-001', 'SHIP-01',    '发货区01',           'SHIPPING', 'S', 1,  1,  1, 1, 7),
    (8,  'WH-002', 'A-01-01-01', 'A区半成品库1-1-1层', 'STORAGE',  'A', 1,  1,  1, 1, 8);
