-- ================================================================
-- APS 生产排程系统 - 排程数据：供需平衡记录表
-- 文件：086_sch_demand_supply_balance.sql
-- 说明：记录每个调度需求在各时间点的供给量与需求量平衡状态，用于APS闭环追踪与供给匹配分析
-- 作者：Claude Auto
-- 创建时间：2026-05-07
-- ================================================================

-- ----------------------------
-- Table: sch_demand_supply_balance
-- ----------------------------
DROP TABLE IF EXISTS sch_demand_supply_balance;

CREATE TABLE sch_demand_supply_balance (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    demand_id           BIGINT           NOT NULL                        COMMENT '关联需求ID（sch_schedule_demand）',
    balance_date        DATE             NOT NULL                        COMMENT '平衡日期',
    period_type         VARCHAR(16)      NOT NULL                        COMMENT '周期类型：DAY/WEEK/MONTH',
    period_value        VARCHAR(32)      NOT NULL                        COMMENT '周期值（如 2026-05-05）',
    total_demand_qty    DECIMAL(18,6)    NOT NULL                        COMMENT '总需求数量',
    total_supply_qty    DECIMAL(18,6)    NOT NULL                        COMMENT '总供给数量',
    shortage_qty        DECIMAL(18,6)    NOT NULL        DEFAULT 0.000   COMMENT '缺口数量（需求-供给>0时）',
    surplus_qty         DECIMAL(18,6)    NOT NULL        DEFAULT 0.000   COMMENT '剩余数量（供给-需求>0时）',
    fill_rate           DECIMAL(6,4)     NULL                            COMMENT '满足率（供给/需求）',
    supply_source_type  VARCHAR(16)      NULL                            COMMENT '主要供给来源类型',
    supply_source_code  VARCHAR(64)      NULL                            COMMENT '主要供给来源编码',
    demand_priority     INT              NULL                            COMMENT '需求优先级',
    balance_status      VARCHAR(16)      NOT NULL    DEFAULT 'UNBALANCED' COMMENT '平衡状态：BALANCED/UNBALANCED/OVER_SUPPLY/UNDER_SUPPLY',
    notes               TEXT             NULL                            COMMENT '备注',
    created_by          VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version             INT              NOT NULL    DEFAULT 0           COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    KEY idx_demand_date (demand_id, balance_date),
    KEY idx_balance_status (balance_status),
    KEY idx_period (period_type, period_value)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='供需平衡记录表';