-- =====================================================
-- 090 sch_demand_supply_balance（供需平衡记录表）
-- 建表时间：2026-05-07 09:00
-- 说明：记录APS排程系统中每个物料每个时间周期的供需平衡状态，
--       是供需平衡分析的核心数据，用于追溯供需缺口的来源
-- =====================================================
CREATE TABLE sch_demand_supply_balance (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    balance_no          VARCHAR(64)      NOT NULL                        COMMENT '平衡记录编号（唯一）',
    schedule_date       DATE             NOT NULL                        COMMENT '排程日期（快照日期）',
    item_code           VARCHAR(64)      NOT NULL                        COMMENT '物料编码',
    item_name           VARCHAR(256)     NULL                            COMMENT '物料名称',
    workshop_code       VARCHAR(64)      NULL                            COMMENT '车间编码',
    workcenter_code     VARCHAR(64)      NULL                            COMMENT '工作中心编码',
    period_type         VARCHAR(16)      NOT NULL    DEFAULT 'DAY'       COMMENT '周期类型：DAY/WEEK/MONTH',
    period_start        DATE             NOT NULL                        COMMENT '周期开始日期',
    period_end          DATE             NOT NULL                        COMMENT '周期结束日期',
    demand_qty          DECIMAL(18,6)    NOT NULL    DEFAULT 0.000       COMMENT '总需求数量',
    supply_qty          DECIMAL(18,6)    NOT NULL    DEFAULT 0.000       COMMENT '总供给数量',
    allocated_qty       DECIMAL(18,6)    NOT NULL    DEFAULT 0.000       COMMENT '已分配数量',
    frozen_qty          DECIMAL(18,6)    NOT NULL    DEFAULT 0.000       COMMENT '冻结数量',
    available_qty       DECIMAL(18,6)    NOT NULL    DEFAULT 0.000       COMMENT '可用数量（supply - allocated - frozen）',
    shortage_qty        DECIMAL(18,6)    NOT NULL    DEFAULT 0.000       COMMENT '短缺数量（demand > available 时为正）',
    surplus_qty         DECIMAL(18,6)    NOT NULL    DEFAULT 0.000       COMMENT '过剩数量（available > demand 时为正）',
    balance_status      VARCHAR(16)      NOT NULL    DEFAULT 'BALANCED' COMMENT '平衡状态：BALANCED/SHORTAGE/SURPLUS/UNDEFINED',
    demand_sources      TEXT             NULL                            COMMENT '需求来源明细（JSON格式）',
    supply_sources      TEXT             NULL                            COMMENT '供给来源明细（JSON格式）',
    shortage_action     VARCHAR(32)      NULL                            COMMENT '短缺处理方式：NONE/EXPAND_CAPACITY/SPLIT_ORDER/SAFE_STOCK',
    notes               TEXT             NULL                            COMMENT '备注',
    created_by          VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version             INT              NOT NULL    DEFAULT 0           COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_balance_no (balance_no),
    KEY idx_schedule_item (schedule_date, item_code),
    KEY idx_item_period (item_code, period_start, period_end),
    KEY idx_workshop (workshop_code),
    KEY idx_status (balance_status),
    KEY idx_shortage (shortage_qty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='供需平衡记录表';
