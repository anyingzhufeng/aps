-- ============================================================
-- 087 mst_production_order（生产订单主表）
-- APS排程核心输入单据，记录接收到的正式生产任务
-- ============================================================

CREATE TABLE mst_production_order (
    id                      BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    production_order_no     VARCHAR(64)      NOT NULL                        COMMENT '生产订单号（唯一）',
    source_type             VARCHAR(16)      NOT NULL                        COMMENT '来源类型：SALES_ORDER/FORECAST/MRP/MANUAL',
    source_no               VARCHAR(64)      NULL                            COMMENT '来源单据号（如销售订单号）',
    item_code               VARCHAR(64)      NOT NULL                        COMMENT '物料编码',
    item_name               VARCHAR(256)     NULL                            COMMENT '物料名称',
    workshop_code           VARCHAR(64)      NOT NULL                        COMMENT '车间编码',
    workcenter_code         VARCHAR(64)      NULL                            COMMENT '优先工作中心编码',
    production_qty          DECIMAL(18,6)    NOT NULL                        COMMENT '计划生产数量',
    completed_qty           DECIMAL(18,6)    NULL         DEFAULT 0.000      COMMENT '已完成数量',
    scheduled_qty           DECIMAL(18,6)    NULL         DEFAULT 0.000      COMMENT '已排程数量',
    demand_date             DATE             NOT NULL                        COMMENT '需求日期（交货/完工截止）',
    priority                INT              NOT NULL    DEFAULT 5           COMMENT '优先级（1最高，10最低）',
    order_status            VARCHAR(16)      NOT NULL    DEFAULT 'PENDING'   COMMENT '订单状态：PENDING/RELEASED/SCHEDULED/IN_PRODUCTION/COMPLETED/CLOSED',
    bom_code                VARCHAR(64)      NULL                            COMMENT 'BOM编码（覆盖默认BOM）',
    routing_code            VARCHAR(64)      NULL                            COMMENT '工艺路线编码（覆盖默认工艺）',
    allow_split             TINYINT          NOT NULL    DEFAULT 1           COMMENT '允许拆批：0=不允许，1=允许',
    min_lot_size            DECIMAL(18,6)    NULL                            COMMENT '最小批量',
    max_lot_size            DECIMAL(18,6)    NULL                            COMMENT '最大批量',
    notes                   TEXT             NULL                            COMMENT '备注',
    created_by              VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at              DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by              VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at              DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version                 INT              NOT NULL    DEFAULT 0           COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_production_order_no (production_order_no),
    KEY idx_source (source_type, source_no),
    KEY idx_item (item_code),
    KEY idx_workshop (workshop_code),
    KEY idx_demand_date (demand_date),
    KEY idx_status_priority (order_status, priority)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='生产订单主表';
