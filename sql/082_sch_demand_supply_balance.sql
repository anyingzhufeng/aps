-- ================================================================
-- APS 生产排程系统 - 排程数据：需求供给平衡表
-- 文件：082_sch_demand_supply_balance.sql
-- 说明：记录每个需求与可用供给的平衡分析结果，用于排程决策与可视化
-- 作者：Claude Auto
-- 创建时间：2026-05-06
-- ================================================================

DROP TABLE IF EXISTS sch_demand_supply_balance;
CREATE TABLE sch_demand_supply_balance (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    demand_id           BIGINT           NOT NULL                        COMMENT '需求ID（sch_schedule_demand）',
    demand_date         DATE             NOT NULL                        COMMENT '需求日期',
    product_code        VARCHAR(64)      NOT NULL                        COMMENT '产品编码',
    demand_quantity     DECIMAL(18,6)    NOT NULL                        COMMENT '需求数量',
    supply_quantity     DECIMAL(18,6)    NOT NULL    DEFAULT 0.000      COMMENT '已分配供给数量',
    shortage_quantity   DECIMAL(18,6)    NOT NULL    DEFAULT 0.000      COMMENT '缺口数量（demand - supply）',
    surplus_quantity    DECIMAL(18,6)    NOT NULL    DEFAULT 0.000      COMMENT '过剩数量（supply - demand）',
    fulfillment_rate    DECIMAL(8,4)     NOT NULL    DEFAULT 0.0000    COMMENT '满足率（0-1）',
    balance_status      VARCHAR(16)      NOT NULL                        COMMENT '平衡状态：BALANCED/SHORTAGE/SURPLUS',
    analysis_level      VARCHAR(16)      NOT NULL                        COMMENT '分析层级：PRODUCT/WORKCENTER/LINE',
    created_by          VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version             INT              NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    KEY idx_demand (demand_id),
    KEY idx_demand_date (demand_date),
    KEY idx_product (product_code),
    KEY idx_status (balance_status),
    KEY idx_analysis (demand_date, balance_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='需求供给平衡表';
