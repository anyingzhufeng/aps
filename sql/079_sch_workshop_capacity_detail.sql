-- ================================================================
-- APS 生产排程系统 - 排程数据：车间产能明细（已存在SQL 078，同名补充）
-- 文件：079_sch_workshop_capacity_detail.sql
-- 说明：sch_workshop_capacity 的班次/工位级明细产能
-- ================================================================

DROP TABLE IF EXISTS sch_workshop_capacity_detail;
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE sch_workshop_capacity_detail (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    workshop_code       VARCHAR(64)      NOT NULL                        COMMENT '车间编码',
    period_type         VARCHAR(16)      NOT NULL                        COMMENT '周期类型：DAY/WEEK/MONTH',
    period_value        VARCHAR(32)      NOT NULL                        COMMENT '周期值（如 2026-05-05）',
    shift_code          VARCHAR(32)      NULL                            COMMENT '班次编码（白班/夜班等）',
    line_code           VARCHAR(64)      NULL                            COMMENT '产线编码',
    station_code        VARCHAR(64)      NULL                            COMMENT '工位编码',
    available_hours     DECIMAL(8,2)     NOT NULL                        COMMENT '可用产能（小时）',
    overtime_hours      DECIMAL(8,2)     NULL         DEFAULT 0.00       COMMENT '可加班产能（小时）',
    efficiency_rate     DECIMAL(5,4)     NULL         DEFAULT 1.0000    COMMENT '效率系数',
    utilization_cap     DECIMAL(5,4)     NULL         DEFAULT 0.8500    COMMENT '产能上限利用率',
    created_by          VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version             INT              NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    KEY idx_workshop_period (workshop_code, period_type, period_value),
    KEY idx_shift (shift_code),
    KEY idx_line (line_code),
    KEY idx_station (station_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='车间产能明细表（班次/产线/工位级）';
