-- =====================================================
-- 089_sch_demand_forecast（需求预测表）
-- 建表时间：2026-05-07 06:00
-- 说明：记录APS排程系统中的需求预测数据，支持销售预测、
--       季节性预测、历史预测等，作为排程需求的重要输入来源
-- =====================================================
CREATE TABLE sch_demand_forecast (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    forecast_no         VARCHAR(64)      NOT NULL                        COMMENT '预测单号（唯一）',
    source_type         VARCHAR(16)      NOT NULL                        COMMENT '预测来源：SALES_FORECAST/SEASONAL/HISTORICAL/MRP/MANUAL',
    source_no           VARCHAR(64)      NULL                            COMMENT '来源单据号',
    item_code           VARCHAR(64)      NOT NULL                        COMMENT '物料编码',
    item_name           VARCHAR(256)     NULL                            COMMENT '物料名称',
    workshop_code       VARCHAR(64)      NULL                            COMMENT '车间编码（可选，预测级别）',
    workcenter_code     VARCHAR(64)      NULL                            COMMENT '工作中心编码（可选）',
    forecast_qty        DECIMAL(18,6)    NOT NULL                        COMMENT '预测数量',
    unit_code           VARCHAR(16)      NULL                            COMMENT '单位',
    forecast_date       DATE             NOT NULL                        COMMENT '预测日期（需求发生日期）',
    period_type         VARCHAR(16)      NOT NULL    DEFAULT 'DAY'       COMMENT '周期类型：DAY/WEEK/MONTH',
    period_value        VARCHAR(32)      NULL                            COMMENT '周期值',
    confidence_level    DECIMAL(5,2)     NULL                            COMMENT '预测置信度（百分比）',
    forecast_method     VARCHAR(32)      NULL                            COMMENT '预测方法：MOVING_AVG/EXPONENTIAL/SEASONAL/MANUAL',
    priority            INT              NULL        DEFAULT 5           COMMENT '预测优先级（1最高）',
    demand_type         VARCHAR(16)      NOT NULL    DEFAULT 'FORECAST'  COMMENT '需求类型：FORECAST/ORDER/RESERVATION',
    allow_overwrite     TINYINT          NOT NULL    DEFAULT 1           COMMENT '允许被订单覆盖：0=否，1=是',
    effective_date      DATE             NOT NULL                        COMMENT '生效日期',
    expiry_date         DATE             NULL                            COMMENT '失效日期',
    notes               TEXT             NULL                            COMMENT '备注',
    created_by          VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version             INT              NOT NULL    DEFAULT 0           COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_forecast_no (forecast_no),
    KEY idx_item_date (item_code, forecast_date),
    KEY idx_source (source_type, source_no),
    KEY idx_workshop (workshop_code),
    KEY idx_effective (effective_date, expiry_date),
    KEY idx_demand_type (demand_type, forecast_method)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='需求预测表';
