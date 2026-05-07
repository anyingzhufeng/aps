-- ===============================================================
-- 表名称: mst_production_order
-- 表说明: 生产订单主数据（APS 生产计划主体）
-- 创建时间: 2026-04-29
-- 创建人: AI Assistant
-- ===============================================================

CREATE TABLE IF NOT EXISTS mst_production_order (
    id                      VARCHAR(64)      NOT NULL                        COMMENT '主键ID',
    order_no                VARCHAR(64)      NOT NULL                        COMMENT '生产订单号（ERP 同步或 APS 生成）',
    source_system           VARCHAR(32)      NULL                            COMMENT '来源系统：ERP / MES / APS',
    factory_id              VARCHAR(64)      NOT NULL                        COMMENT '工厂ID（外键 -> mst_factory）',
    workshop_id             VARCHAR(64)      NULL                            COMMENT '车间ID（外键 -> mst_workshop）',
    product_code            VARCHAR(64)      NOT NULL                        COMMENT '产品编码（外键 -> mst_item.item_code）',
    product_name            VARCHAR(256)     NULL                            COMMENT '产品名称',
    bom_code                VARCHAR(64)      NULL                            COMMENT 'BOM 编码（外键 -> mst_bom）',
    routing_code            VARCHAR(64)      NULL                            COMMENT '工艺路线编码（外键 -> mst_routing）',
    plan_quantity           DECIMAL(18,6)    NOT NULL                        COMMENT '计划生产数量',
    completed_quantity      DECIMAL(18,6)    NOT NULL    DEFAULT 0.000      COMMENT '已完成数量',
    scrapped_quantity       DECIMAL(18,6)    NOT NULL    DEFAULT 0.000      COMMENT '报废数量',
    order_status            VARCHAR(16)      NOT NULL    DEFAULT 'DRAFT'     COMMENT '订单状态：DRAFT / RELEASED / IN_PROGRESS / COMPLETED / CLOSED / CANCELLED',
    priority                INT              NOT NULL    DEFAULT 100         COMMENT '优先级（数字越小优先级越高）',
    demand_date             DATE             NOT NULL                        COMMENT '需求日期（交期）',
    planned_start_date      DATE             NULL                            COMMENT '计划开始日期',
    planned_end_date        DATE             NULL                            COMMENT '计划结束日期',
    actual_start_date       DATE             NULL                            COMMENT '实际开始日期',
    actual_end_date         DATE             NULL                            COMMENT '实际完成日期',
    planning_horizon_hours  INT              NULL                            COMMENT '排程规划时长（小时）',
    frozen_window_hours     INT              NOT NULL    DEFAULT 8           COMMENT '冻结窗口（小时），冻结窗口内不允许重排',
    release_time            DATETIME         NULL                            COMMENT '订单下达时间',
    closed_time             DATETIME         NULL                            COMMENT '订单关闭时间',
    client_order_no         VARCHAR(64)      NULL                            COMMENT '客户订单号',
    sales_order_no          VARCHAR(64)      NULL                            COMMENT '销售订单号',
    notes                   TEXT             NULL                            COMMENT '备注',
    is_active               TINYINT(1)       NOT NULL    DEFAULT 1           COMMENT '是否有效（1=有效，0=无效）',
    created_by              VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at              DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by              VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at              DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version                 INT              NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_order_no (order_no),
    KEY idx_factory (factory_id),
    KEY idx_workshop (workshop_id),
    KEY idx_product (product_code),
    KEY idx_status (order_status),
    KEY idx_priority (priority),
    KEY idx_demand_date (demand_date),
    KEY idx_planned_start (planned_start_date),
    KEY idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='生产订单主数据表（APS 排产主体对象）';
