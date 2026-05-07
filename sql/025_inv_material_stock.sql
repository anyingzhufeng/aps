-- ================================================================
-- APS 生产排程系统 - 业务数据：物料库存
-- 文件：025_inv_material_stock.sql
-- 说明：记录各仓库中每个物料的实时库存数量与状态
-- ================================================================

CREATE TABLE IF NOT EXISTS inv_material_stock (
    id              CHAR(36)         NOT NULL    COMMENT 'UUID 主键',
    item_id         CHAR(36)         NOT NULL    COMMENT '物料ID（关联 mst_item.id）',
    warehouse_code  VARCHAR(50)      NOT NULL    COMMENT '仓库编码',
    location_code   VARCHAR(50)      NULL        COMMENT '库位编码（可选）',
    quantity        DECIMAL(18,6)   NOT NULL    DEFAULT 0 COMMENT '当前库存数量',
    reserved_qty    DECIMAL(18,6)   NOT NULL    DEFAULT 0 COMMENT '已预留数量（工单占用）',
    available_qty   DECIMAL(18,6)   NOT NULL    GENERATED ALWAYS AS (quantity - reserved_qty) STORED COMMENT '可用数量（计算字段）',
    unit_code       VARCHAR(20)      NOT NULL    DEFAULT 'PC' COMMENT '计量单位编码',
    lot_no          VARCHAR(100)    NULL        COMMENT '批次号',
    expiry_date     DATE             NULL        COMMENT '有效期（用于食材/化工类物料）',
    warehouse_zone  VARCHAR(50)      NULL        COMMENT '库区（如原材料区 / 成品区）',
    status          TINYINT          NOT NULL    DEFAULT 1 COMMENT '状态：1=正常 0=冻结 9=已用尽',
    version         INT              NOT NULL    DEFAULT 0 COMMENT '乐观锁版本号',
    created_at      DATETIME(3)      NOT NULL    DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
    updated_at      DATETIME(3)      NOT NULL    DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
    created_by      VARCHAR(100)     NULL        COMMENT '创建人',
    updated_by      VARCHAR(100)     NULL        COMMENT '更新人',
    deleted_at      DATETIME(3)      NULL        COMMENT '软删除时间',
    remark          VARCHAR(500)     NULL        COMMENT '备注',

    PRIMARY KEY (id),
    UNIQUE KEY uk_item_warehouse_lot (item_id, warehouse_code, lot_no, location_code),

    -- 按物料+仓库做预留锁
    INDEX idx_item_id (item_id),
    INDEX idx_warehouse_code (warehouse_code),
    INDEX idx_status (status),
    INDEX idx_expiry_date (expiry_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='物料库存表';

-- ================================================================
-- 触发器示例：工单确认时自动扣减可用库存（可按需在业务层实现）
-- 以下为概念触发器（MySQL 8.0 支持）
-- ================================================================
/*
DELIMITER $$
CREATE TRIGGER trg_wo_confirmed_reserve
AFTER UPDATE ON ord_work_order
FOR EACH ROW
BEGIN
    IF NEW.status = 20 AND OLD.status <> 20 THEN
        -- 工单状态变为"已确认"，预留所需物料
        INSERT INTO inv_material_reserved (wo_id, item_id, qty, reserved_at)
        SELECT NEW.id, b.item_id, b.required_qty * NEW.planned_qty, NOW(3)
        FROM mst_bom_line b
        WHERE b.bom_id IN (
            SELECT id FROM mst_bom WHERE item_id = NEW.item_id AND is_active = 1 LIMIT 1
        );
    END IF;
END$$
DELIMITER ;
*/