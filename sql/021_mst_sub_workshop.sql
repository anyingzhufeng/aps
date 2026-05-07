-- ============================================================
-- APS开发文档 附表：mst_sub_workshop（车间细分区域）
-- 对应文档：第4章 4.2.5 节
-- 状态：待编写
-- ============================================================

-- 子车间（工段/产线分区）表
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE `mst_sub_workshop` (
    `sub_workshop_id`   CHAR(36)      NOT NULL        COMMENT '子车间ID（UUID）',
    `workshop_id`       CHAR(36)      NOT NULL        COMMENT '所属车间ID',
    `sub_workshop_code` VARCHAR(50)   NOT NULL        COMMENT '子车间代码（如 A段/B段）',
    `sub_workshop_name` VARCHAR(100)  NOT NULL        COMMENT '子车间名称',
    `area_sqm`          DECIMAL(10,2) DEFAULT NULL    COMMENT '面积（平方米）',
    `description`       VARCHAR(500)  DEFAULT NULL    COMMENT '描述',
    `is_active`        TINYINT(1)    NOT NULL DEFAULT 1 COMMENT '是否启用',
    `created_at`       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`sub_workshop_id`),
    UNIQUE KEY `uk_code` (`workshop_id`, `sub_workshop_code`),
    KEY `idx_workshop` (`workshop_id`),
    CONSTRAINT `fk_sub_workshop_workshop` FOREIGN KEY (`workshop_id`) REFERENCES `mst_workshop` (`workshop_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='子车间（工段/产线分区）表';
