-- ============================================================
-- 077 sch_workshop_capacity（车间产能配置表）
-- APS项目 - 高级计划排程系统
-- ============================================================

CREATE TABLE sch_workshop_capacity (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT   COMMENT '主键',
    workshop_code       VARCHAR(64)      NOT NULL                         COMMENT '车间编码',
    period_type         VARCHAR(16)      NOT NULL                         COMMENT '周期类型：DAY/WEEK/MONTH',
    period_value        VARCHAR(32)      NOT NULL                         COMMENT '周期值（如 2026-05-05 或 2026-W19）',
    available_hours     DECIMAL(8,2)     NOT NULL                         COMMENT '可用产能（小时）',
    overtime_hours      DECIMAL(8,2)     NULL         DEFAULT 0.00      COMMENT '可加班产能（小时）',
    efficiency_rate     DECIMAL(5,4)     NULL         DEFAULT 1.0000    COMMENT '效率系数',
    utilization_cap     DECIMAL(5,4)     NULL         DEFAULT 0.8500    COMMENT '产能上限利用率',
    created_by          VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version             INT              NOT NULL    DEFAULT 0           COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_workshop_period (workshop_code, period_type, period_value),
    KEY idx_period (period_type, period_value)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='车间产能配置表';
