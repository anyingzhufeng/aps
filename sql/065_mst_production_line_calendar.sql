-- ================================================================
-- APS 开发文档 - SQL 文件 #065
-- 表名：mst_production_line_calendar（产线工作日历表）
-- 文档章节：第 3 章·表结构设计 → 3.3 基础主数据
-- 说明：记录APS系统产线的工作日历，定义每个产线在工作日的可用产能与实际排班时间。
-- ================================================================

-- ----------------------------
-- 1. 表结构
-- ----------------------------
DROP TABLE IF EXISTS `mst_production_line_calendar`;
CREATE TABLE `mst_production_line_calendar` (
    `id`                BIGINT          NOT NULL    AUTO_INCREMENT    COMMENT '主键',
    `line_id`          BIGINT          NOT NULL                       COMMENT '产线ID（mst_production_line.id）',
    `work_date`        DATE            NOT NULL                       COMMENT '工作日期',
    `shift_id`         BIGINT          NULL                           COMMENT '班次ID（mst_shift.id，可为空表示默认8小时）',
    `start_time`       TIME            NOT NULL                       COMMENT '当日开始时间',
    `end_time`         TIME            NOT NULL                       COMMENT '当日结束时间',
    `planned_hours`    DECIMAL(5,2)    NOT NULL    DEFAULT 8.00        COMMENT '计划工时（小时）',
    `available_hours`   DECIMAL(5,2)    NOT NULL    DEFAULT 8.00        COMMENT '可用工时（扣除休息/停机，实际可用于排产）',
    `break_minutes`    INT             NOT NULL    DEFAULT 0           COMMENT '休息时间（分钟）',
    `overtime_hours`   DECIMAL(5,2)    NOT NULL    DEFAULT 0.00         COMMENT '加班工时（小时）',
    `capacity_units`   INT             NULL                           COMMENT '当日产能（单位数），为空时用产线默认',
    `efficiency`       DECIMAL(5,2)    NULL                           COMMENT '当日效率系数（%），为空时用产线默认',
    `status`           VARCHAR(16)     NOT NULL    DEFAULT 'ACTIVE'   COMMENT '状态：ACTIVE（可用）/INACTIVE（停产）/HOLIDAY（假日）',
    `remark`           VARCHAR(500)    NULL                           COMMENT '备注（如计划保养、限电等）',
    `created_by`       VARCHAR(64)     NOT NULL                       COMMENT '创建人',
    `created_at`       DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_by`       VARCHAR(64)     NULL                           COMMENT '修改人',
    `updated_at`       DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `version`          INT             NOT NULL    DEFAULT 1           COMMENT '乐观锁版本号',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_line_date` (`line_id`, `work_date`),
    KEY `idx_work_date` (`work_date`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产线工作日历表';

-- ----------------------------
-- 2. 初始数据
-- ----------------------------
INSERT INTO `mst_production_line_calendar` (`line_id`, `work_date`, `start_time`, `end_time`, `planned_hours`, `available_hours`, `break_minutes`, `overtime_hours`, `capacity_units`, `efficiency`, `status`, `remark`, `created_by`) VALUES
-- PL-A1-001（组装线1号线）示例数据
(1, '2026-05-04', '08:00:00', '20:00:00', 12.00, 11.00, 60, 0.00, 120, 95.50, 'ACTIVE', '白班+中班双班生产', 'SYSTEM'),
(1, '2026-05-05', '08:00:00', '20:00:00', 12.00, 11.00, 60, 0.00, 120, 95.50, 'ACTIVE', '白班+中班双班生产', 'SYSTEM'),
-- PL-B2-001（机加线1号线）示例数据
(4, '2026-05-04', '08:00:00', '17:30:00',  9.50,  9.00, 30, 0.00,  60, 90.00, 'ACTIVE', '标准单班', 'SYSTEM'),
(4, '2026-05-05', '08:00:00', '17:30:00',  9.50,  9.00, 30, 0.00,  60, 90.00, 'ACTIVE', '标准单班', 'SYSTEM'),
-- PL-C3-001（包装线1号线）示例数据
(6, '2026-05-04', '08:00:00', '22:00:00', 14.00, 13.00, 60, 2.00, 200, 97.00, 'ACTIVE', '含2小时加班', 'SYSTEM'),
(6, '2026-05-05', '08:00:00', '22:00:00', 14.00, 13.00, 60, 2.00, 200, 97.00, 'ACTIVE', '含2小时加班', 'SYSTEM');

-- ----------------------------
-- 3. 文档同步标记
-- ----------------------------
-- 本文件对应文档位置：第 3 章 → 3.3 基础主数据 → 065 mst_production_line_calendar
-- 文档路径：/home/claw/.openclaw/workspace/docs/APS开发文档.md