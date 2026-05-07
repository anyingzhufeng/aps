-- ============================================================
-- APS开发文档 附表：mst_location（工位/工序位置）
-- 对应文档：第4章 4.2.6 节
-- 状态：已完成
-- ============================================================

-- 工位（工序执行地点）表
CREATE TABLE `mst_location` (
    `location_id`      CHAR(36)      NOT NULL        COMMENT '工位ID（UUID）',
    `workcenter_id`    CHAR(36)      DEFAULT NULL    COMMENT '所属工段ID（可空，表示独立工位）',
    `location_code`    VARCHAR(50)   NOT NULL        COMMENT '工位代码（如 WP-001）',
    `location_name`    VARCHAR(100)  NOT NULL        COMMENT '工位名称',
    `location_type`   VARCHAR(20)   NOT NULL        COMMENT '工位类型：STATION=工位，POINT=工序点，STORE=存储点',
    `capacity_qty`    DECIMAL(10,2) DEFAULT NULL    COMMENT '容量（同时容纳的数量）',
    `throughput_hours`DECIMAL(10,4) DEFAULT NULL    COMMENT '单位产能（件/小时）',
    `setup_minutes`   INT           DEFAULT 0       COMMENT '准备时间（分钟）',
    `teardown_minutes`INT           DEFAULT 0       COMMENT '收尾时间（分钟）',
    `is_active`       TINYINT(1)    NOT NULL DEFAULT 1 COMMENT '是否启用',
    `created_at`      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`location_id`),
    UNIQUE KEY `uk_code` (`location_code`),
    KEY `idx_workcenter` (`workcenter_id`),
    CONSTRAINT `fk_location_workcenter` FOREIGN KEY (`workcenter_id`) REFERENCES `mst_workcenter` (`workcenter_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工位（工序执行地点）表';
