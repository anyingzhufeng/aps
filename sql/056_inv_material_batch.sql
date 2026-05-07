-- ================================================================
-- APS 生产排程系统 - 物料批次表
-- 文件：056_inv_material_batch.sql
-- 说明：物料批次信息表，记录每个物料的批次级库存详情
-- 参考：APS开发文档 §2.2.3 表清单 #56
-- ================================================================

-- 物料批次表
CREATE TABLE inv_material_batch (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    material_code       VARCHAR(64)     NOT NULL    COMMENT '物料编码（关联mst_item.item_code）',
    batch_no            VARCHAR(64)     NOT NULL    COMMENT '批次号',
    warehouse_id        BIGINT          NOT NULL    COMMENT '仓库ID（关联mst_warehouse.id）',
    location_id         BIGINT          NULL        COMMENT '库位ID（关联mst_warehouse_location.id）',
    quantity            DECIMAL(12,4)   NOT NULL    DEFAULT 0 COMMENT '当前库存数量',
    available_qty       DECIMAL(12,4)   NOT NULL    DEFAULT 0 COMMENT '可用数量（扣除预留）',
    reserved_qty        DECIMAL(12,4)   NOT NULL    DEFAULT 0 COMMENT '已预留数量',
    incoming_qty        DECIMAL(12,4)   NOT NULL    DEFAULT 0 COMMENT '在途数量（已采购/在制）',
    unit_code           VARCHAR(16)     NOT NULL    DEFAULT 'PCS' COMMENT '单位',
    manufacture_date     DATE            NULL        COMMENT '生产/入库日期',
    expiry_date         DATE            NULL        COMMENT '有效期（NULL=永不过期）',
    supplier_id         BIGINT          NULL        COMMENT '供应商ID',
    purchase_order_no   VARCHAR(64)     NULL        COMMENT '采购单号',
    quality_status      VARCHAR(32)     NOT NULL    DEFAULT 'QUALIFIED' COMMENT '质量状态：QUALIFIED=合格，REJECTED=不合格，PENDING=待检，LOCKED=冻结',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    sort_order          INT             NOT NULL    DEFAULT 0,
    remarks             NVARCHAR(500)   NULL,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_material_batch (material_code, batch_no),
    KEY idx_warehouse_id     (warehouse_id),
    KEY idx_location_id      (location_id),
    KEY idx_quality_status   (quality_status),
    KEY idx_expiry_date      (expiry_date),
    KEY idx_is_active        (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物料批次表';

-- 初始化示例数据
INSERT INTO inv_material_batch (id, material_code, batch_no, warehouse_id, location_id, quantity, available_qty, unit_code, manufacture_date, quality_status, is_active, sort_order) VALUES
    (1,  'MAT-RAW-001',  'BAT-2026-0001', 1, 1,  5000.0000, 5000.0000, 'KG',   '2026-04-01', 'QUALIFIED', 1, 1),
    (2,  'MAT-RAW-002',  'BAT-2026-0002', 1, 2,  3000.0000, 3000.0000, 'KG',   '2026-04-05', 'QUALIFIED', 1, 2),
    (3,  'MAT-PART-001', 'BAT-2026-0003', 1, 3,  8000.0000, 7500.0000, 'PCS',  '2026-04-10', 'QUALIFIED', 1, 3),
    (4,  'MAT-PACK-001', 'BAT-2026-0004', 2, 5,  2000.0000, 2000.0000, 'BOX',  '2026-04-15', 'QUALIFIED', 1, 4);
