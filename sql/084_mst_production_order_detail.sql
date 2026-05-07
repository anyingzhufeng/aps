-- ================================================================
-- APS 生产排程系统 - 主数据：生产订单明细表
-- 文件：084_mst_production_order_detail.sql
-- 说明：生产订单的明细行，记录每个订单的产品明细和分批计划
-- 作者：Claude Auto
-- 创建时间：2026-05-06
-- ================================================================

DROP TABLE IF EXISTS mst_production_order_detail;
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE mst_production_order_detail (
    id                      VARCHAR(64)      NOT NULL                        COMMENT '主键ID',
    production_order_id     VARCHAR(64)      NOT NULL                        COMMENT '生产订单ID（外键 -> mst_production_order）',
    line_no                 INT              NOT NULL                        COMMENT '行号',
    product_code            VARCHAR(64)      NOT NULL                        COMMENT '产品编码',
    product_name            VARCHAR(256)     NULL                            COMMENT '产品名称',
    specification           VARCHAR(256)     NULL                            COMMENT '规格型号',
    unit_code               VARCHAR(16)      NULL                            COMMENT '单位',
    plan_quantity           DECIMAL(18,6)    NOT NULL                        COMMENT '计划数量',
    completed_quantity      DECIMAL(18,6)    NOT NULL    DEFAULT 0.000      COMMENT '已完成数量',
    shipped_quantity        DECIMAL(18,6)    NOT NULL    DEFAULT 0.000      COMMENT '已发货数量',
    scrapped_quantity       DECIMAL(18,6)    NOT NULL    DEFAULT 0.000      COMMENT '报废数量',
    demand_date             DATE             NULL                            COMMENT '需求日期',
    planned_start_date      DATE             NULL                            COMMENT '计划开始日期',
    planned_end_date        DATE             NULL                            COMMENT '计划完成日期',
    actual_start_date       DATE             NULL                            COMMENT '实际开始日期',
    actual_end_date         DATE             NULL                            COMMENT '实际完成日期',
    production_batch_no     VARCHAR(64)      NULL                            COMMENT '生产批次号',
    warehouse_id            VARCHAR(64)      NULL                            COMMENT '交货仓库ID',
    is_closed               TINYINT(1)       NOT NULL    DEFAULT 0           COMMENT '是否关闭（1=已关闭，0=未关闭）',
    closed_time             DATETIME         NULL                            COMMENT '关闭时间',
    notes                   TEXT             NULL                            COMMENT '备注',
    is_active               TINYINT(1)       NOT NULL    DEFAULT 1           COMMENT '是否有效',
    created_by              VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at              DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by              VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at              DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version                 INT              NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_order_line (production_order_id, line_no),
    KEY idx_production_order (production_order_id),
    KEY idx_product (product_code),
    KEY idx_batch (production_batch_no),
    KEY idx_demand_date (demand_date),
    KEY idx_is_closed (is_closed),
    KEY idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='生产订单明细表';
