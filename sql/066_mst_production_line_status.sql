-- 066_mst_production_line_status（产线状态记录表）
-- 记录产线每日状态快照，用于产能分析和历史追溯
-- 与 mst_production_line 关联，记录每条产线在特定日期的状态

CREATE TABLE IF NOT EXISTS `mst_production_line_status` (
    `id`                BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    `line_id`           BIGINT          NOT NULL                    COMMENT '产线ID（mst_production_line.id）',
    `stat_date`         DATE            NOT NULL                    COMMENT '统计日期',
    `status`            VARCHAR(16)     NOT NULL                    COMMENT '状态：ACTIVE/INACTIVE/MAINTENANCE/HOLIDAY',
    `planned_hours`     DECIMAL(5,2)    NOT NULL    DEFAULT 0        COMMENT '计划工时',
    `available_hours`   DECIMAL(5,2)    NOT NULL    DEFAULT 0        COMMENT '可用工时',
    `actual_hours`      DECIMAL(5,2)    NOT NULL    DEFAULT 0        COMMENT '实际工时',
    `output_units`      INT             NOT NULL    DEFAULT 0        COMMENT '实际产出数量',
    `downtime_minutes`  INT             NOT NULL    DEFAULT 0        COMMENT '停机时间（分钟）',
    `efficiency`        DECIMAL(5,2)    NOT NULL    DEFAULT 100.00   COMMENT '效率（%）',
    `oee`               DECIMAL(5,2)    NOT NULL    DEFAULT 0        COMMENT '设备综合效率（OEE）',
    `quality_rate`      DECIMAL(5,2)    NOT NULL    DEFAULT 100.00   COMMENT '质量合格率（%）',
    `created_by`        VARCHAR(64)     NOT NULL                    COMMENT '创建人',
    `created_at`        DATETIME        NOT NULL                    COMMENT '创建时间',
    `updated_by`        VARCHAR(64)     NULL                        COMMENT '修改人',
    `updated_at`        DATETIME        NOT NULL                    COMMENT '修改时间',
    `version`           INT             NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_line_date` (`line_id`, `stat_date`),
    INDEX `idx_stat_date` (`stat_date`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产线状态记录表';
