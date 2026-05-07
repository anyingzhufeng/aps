-- ================================================================
-- APS 开发文档 - SQL 文件 #063
-- 表名：mst_production_line（生产线基础信息表）
-- 文档章节：第 3 章·表结构设计 → 3.3 基础主数据
-- 说明：记录APS系统所管理的生产线基础信息，是排产和资源分配的核心维度之一。
--       一条生产线属于一个车间（workshop），可包含多个工位（station）。
-- 创建时间：2026-05-04
-- ================================================================

-- ----------------------------
-- 1. 表结构
-- ----------------------------
CREATE TABLE IF NOT EXISTS `mst_production_line` (
    `id`                BIGINT         NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    `line_code`        VARCHAR(50)    NOT NULL                    COMMENT '生产线编码（全局唯一）',
    `line_name`        VARCHAR(200)   NOT NULL                    COMMENT '生产线名称',
    `workshop_id`      BIGINT         NOT NULL                    COMMENT '所属车间ID（mst_workshop.id）',
    `line_type`        VARCHAR(32)    NOT NULL                    COMMENT '生产线类型：ASSEMBLY/MACHINING/MIXED/PACKING',
    `capacity_units`   INT            NOT NULL    DEFAULT 0        COMMENT '标准产能（单位/小时）',
    `efficiency`       DECIMAL(5,2)   NOT NULL    DEFAULT 100.00   COMMENT '效率系数（%），默认100',
    `status`           VARCHAR(16)    NOT NULL                    COMMENT '状态：ACTIVE/INACTIVE/MAINTENANCE/SCRAPPED',
    `sort_order`       INT            NOT NULL    DEFAULT 0        COMMENT '排序序号',
    `description`      VARCHAR(500)   NULL                        COMMENT '生产线说明',
    `created_by`       VARCHAR(64)    NOT NULL                    COMMENT '创建人',
    `created_at`       DATETIME       NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_by`       VARCHAR(64)    NULL                        COMMENT '修改人',
    `updated_at`       DATETIME       NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `version`          INT            NOT NULL    DEFAULT 1        COMMENT '乐观锁版本号',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_line_code` (`line_code`),
    KEY `idx_workshop_id` (`workshop_id`),
    KEY `idx_line_type` (`line_type`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='生产线基础信息表';

-- ----------------------------
-- 2. 初始数据
-- ----------------------------
INSERT INTO `mst_production_line` (`line_code`, `line_name`, `workshop_id`, `line_type`, `capacity_units`, `efficiency`, `status`, `sort_order`, `created_by`) VALUES
('PL-A1-001', 'A1车间·组装线1号线',   1, 'ASSEMBLY',   120, 95.50, 'ACTIVE',    1, 'SYSTEM'),
('PL-A1-002', 'A1车间·组装线2号线',   1, 'ASSEMBLY',   100, 98.00, 'ACTIVE',    2, 'SYSTEM'),
('PL-A1-003', 'A1车间·柔性混合线',     1, 'MIXED',       80, 92.00, 'ACTIVE',    3, 'SYSTEM'),
('PL-B2-001', 'B2车间·机加线1号线',    2, 'MACHINING',   60, 90.00, 'ACTIVE',    1, 'SYSTEM'),
('PL-B2-002', 'B2车间·机加线2号线',    2, 'MACHINING',   55, 88.00, 'ACTIVE',    2, 'SYSTEM'),
('PL-C3-001', 'C3车间·包装线1号线',    3, 'PACKING',     200, 97.00, 'ACTIVE',   1, 'SYSTEM');

-- ----------------------------
-- 3. 文档同步标记
-- ----------------------------
-- 本文件对应文档位置：第 3 章 → 3.3 基础主数据 → 063 mst_production_line
-- 文档路径：/home/claw/.openclaw/workspace/docs/APS开发文档.md
