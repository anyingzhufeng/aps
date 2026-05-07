-- ============================================================
-- 055: inv_stock（库存现存量表）
-- 说明：记录各仓库各物料的实时库存快照，支持批次、序列号、库位维度
-- 依赖：mst_item(008), mst_warehouse(035), mst_warehouse_location(053)
-- ============================================================

CREATE TABLE inv_stock (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    item_id             BIGINT          NOT NULL                    COMMENT '物料ID（mst_item.id）',
    warehouse_id        BIGINT          NOT NULL                    COMMENT '仓库ID（mst_warehouse.id）',
    location_id         BIGINT          NULL                        COMMENT '库位ID（mst_warehouse_location.id）',
    lot_no              VARCHAR(128)    NULL                        COMMENT '批次号',
    serial_no           VARCHAR(128)    NULL                        COMMENT '序列号',
    stock_qty           DECIMAL(18,6)   NOT NULL    DEFAULT 0        COMMENT '库存数量',
    reserved_qty        DECIMAL(18,6)   NOT NULL    DEFAULT 0        COMMENT '预留数量',
    available_qty       DECIMAL(18,6)   NOT NULL    GENERATED ALWAYS AS (stock_qty - reserved_qty) STORED COMMENT '可用数量',
    unit_code           VARCHAR(16)     NOT NULL                    COMMENT '计量单位',
    shelf_life_date     DATE            NULL                        COMMENT '有效期',
    quarantine_qty      DECIMAL(18,6)   NOT NULL    DEFAULT 0        COMMENT '隔离/检疫数量',
    inspection_status   VARCHAR(16)     NOT NULL    DEFAULT 'PASSED' COMMENT '检验状态：PENDING/PASSED/REJECTED/RELEASED',
    last_inbound_date   DATETIME        NULL                        COMMENT '最后入库时间',
    last_outbound_date  DATETIME        NULL                        COMMENT '最后出库时间',
    average_cost        DECIMAL(18,4)   NULL                        COMMENT '移动平均成本',
    currency_code       VARCHAR(8)      NOT NULL    DEFAULT 'CNY'   COMMENT '币种',
    is_active           TINYINT         NOT NULL    DEFAULT 1        COMMENT '是否有效',
    remarks             NVARCHAR(500)   NULL,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    version             INT             NOT NULL    DEFAULT 0        COMMENT '版本号（乐观锁）',
    is_deleted          TINYINT(1)      NOT NULL    DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_item_wh_loc_lot (item_id, warehouse_id, location_id, lot_no),
    KEY idx_item_id      (item_id),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_location_id  (location_id),
    KEY idx_lot_no       (lot_no),
    KEY idx_is_active    (is_active),
    KEY idx_available_qty (available_qty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存现存量表';

-- 初始化示例数据
INSERT INTO inv_stock (id, item_id, warehouse_id, location_id, lot_no, stock_qty, reserved_qty, unit_code, is_active) VALUES
    (1,  1, 1, 1, 'LOT-2026-001', 1000.000, 0.000, 'PCS', 1),
    (2,  1, 1, 2, 'LOT-2026-002',  500.000, 50.000, 'PCS', 1),
    (3,  2, 1, 1, 'LOT-2026-001', 2000.000, 0.000, 'KG',  1),
    (4,  3, 2, 3, NULL,            300.000, 0.000, 'SET', 1),
    (5,  4, 1, 4, 'LOT-2026-003',  150.000, 20.000, 'M',   1);