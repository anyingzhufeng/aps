-- ============================================================
-- 088 mst_production_order_detail（生产订单明细表）
-- 生产订单的明细行，记录批次拆分、子项构成等
-- ============================================================

DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE mst_production_order_detail (
    id                      BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    production_order_id      BIGINT           NOT NULL                        COMMENT '关联生产订单主表ID',
    line_no                 INT              NOT NULL                        COMMENT '行号',
    batch_no                VARCHAR(64)      NULL                            COMMENT '批次号（拆批后）',
    item_code               VARCHAR(64)      NOT NULL                        COMMENT '子项物料编码',
    item_name               VARCHAR(256)     NULL                            COMMENT '子项物料名称',
    qty                     DECIMAL(18,6)    NOT NULL                        COMMENT '数量',
    unit_code               VARCHAR(16)      NULL                            COMMENT '单位',
    workcenter_code         VARCHAR(64)      NULL                            COMMENT '工作中心编码',
    target_start_date       DATE             NULL                            COMMENT '计划开始日期',
    target_end_date         DATE             NULL                            COMMENT '计划结束日期',
    actual_start_date       DATE             NULL                            COMMENT '实际开始日期',
    actual_end_date         DATE             NULL                            COMMENT '实际结束日期',
    line_status             VARCHAR(16)      NOT NULL    DEFAULT 'PENDING'   COMMENT '行状态：PENDING/IN_PROGRESS/COMPLETED/CLOSED',
    remarks                 TEXT             NULL                            COMMENT '备注',
    created_by              VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at              DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by              VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at              DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version                 INT              NOT NULL    DEFAULT 0           COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    KEY idx_production_order (production_order_id),
    KEY idx_batch (batch_no),
    KEY idx_item (item_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='生产订单明细表';
