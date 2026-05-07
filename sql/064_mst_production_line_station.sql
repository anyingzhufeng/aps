-- ================================================================
-- APS 开发文档 - SQL 文件 #064
-- 表名：mst_production_line_station（产线工位信息表）
-- 文档章节：第 3 章·表结构设计 → 3.3 基础主数据
-- 说明：记录APS系统产线下的工位（Station）信息，是排产时工序分配的最小执行单元。
-- ================================================================

-- ----------------------------
-- 1. 表结构
-- ----------------------------
DROP TABLE IF EXISTS `mst_production_line_station`;
CREATE TABLE `mst_production_line_station` (
    `id`                BIGINT          NOT NULL    AUTO_INCREMENT    COMMENT '主键',
    `station_code`     VARCHAR(64)     NOT NULL                       COMMENT '工位编码（全局唯一，格式：产线编码+序号，例如 PL-A1-001-S01）',
    `station_name`     VARCHAR(200)    NOT NULL                       COMMENT '工位名称',
    `line_id`          BIGINT          NOT NULL                       COMMENT '所属产线ID（mst_production_line.id）',
    `station_type`     VARCHAR(32)     NOT NULL                       COMMENT '工位类型：PROCESS/TRANSFER/BUFFER/QUALITY/OTHER',
    `process_code`     VARCHAR(64)     NULL                           COMMENT '对应工序编码（参考 mst_routing_op.op_code）',
    `machine_id`       BIGINT          NULL                           COMMENT '关联设备ID（mst_machine.id，可为空）',
    `worker_capacity`  INT             NOT NULL    DEFAULT 1          COMMENT '人员容量（该工位同时容纳人数）',
    `cycle_time_sec`   INT             NULL                           COMMENT '标准周期时间（秒/件），用于产能估算',
    `status`           VARCHAR(16)     NOT NULL    DEFAULT 'ACTIVE'   COMMENT '状态：ACTIVE/INACTIVE/MAINTENANCE/BROKEN',
    `sort_order`       INT             NOT NULL    DEFAULT 0           COMMENT '排序序号（在产线内的位置）',
    `description`      VARCHAR(500)    NULL                           COMMENT '工位说明',
    `created_by`       VARCHAR(64)     NOT NULL                       COMMENT '创建人',
    `created_at`       DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_by`       VARCHAR(64)     NULL                           COMMENT '修改人',
    `updated_at`       DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `version`          INT             NOT NULL    DEFAULT 1          COMMENT '乐观锁版本号',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_station_code` (`station_code`),
    KEY `idx_line_id` (`line_id`),
    KEY `idx_machine_id` (`machine_id`),
    KEY `idx_status` (`status`),
    KEY `idx_process_code` (`process_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产线工位信息表';

-- ----------------------------
-- 2. 初始数据
-- ----------------------------
INSERT INTO `mst_production_line_station` (`station_code`, `station_name`, `line_id`, `station_type`, `process_code`, `worker_capacity`, `cycle_time_sec`, `status`, `sort_order`, `created_by`) VALUES
-- PL-A1-001（组装线1号线）工位
('PL-A1-001-S01', 'A1车间组装线1号线·工位01',  1, 'PROCESS',  'OP-ASSY-01', 2, 45, 'ACTIVE',    1, 'SYSTEM'),
('PL-A1-001-S02', 'A1车间组装线1号线·工位02',  1, 'PROCESS',  'OP-ASSY-02', 2, 40, 'ACTIVE',    2, 'SYSTEM'),
('PL-A1-001-S03', 'A1车间组装线1号线·工位03',  1, 'BUFFER',   NULL,         0,  NULL,'ACTIVE',    3, 'SYSTEM'),
('PL-A1-001-S04', 'A1车间组装线1号线·工位04',  1, 'QUALITY',  'OP-QC-01',   1, 20, 'ACTIVE',    4, 'SYSTEM'),
-- PL-A1-002（组装线2号线）工位
('PL-A1-002-S01', 'A1车间组装线2号线·工位01',  2, 'PROCESS',  'OP-ASSY-01', 2, 48, 'ACTIVE',    1, 'SYSTEM'),
('PL-A1-002-S02', 'A1车间组装线2号线·工位02',  2, 'PROCESS',  'OP-ASSY-02', 2, 42, 'ACTIVE',    2, 'SYSTEM'),
('PL-A1-002-S03', 'A1车间组装线2号线·工位03',  2, 'BUFFER',   NULL,         0,  NULL,'ACTIVE',    3, 'SYSTEM'),
-- PL-B2-001（机加线1号线）工位
('PL-B2-001-S01', 'B2车间机加线1号线·工位01',  4, 'PROCESS',  'OP-MACH-01', 1, 180,'ACTIVE',    1, 'SYSTEM'),
('PL-B2-001-S02', 'B2车间机加线1号线·工位02',  4, 'PROCESS',  'OP-MACH-02', 1, 150,'ACTIVE',    2, 'SYSTEM');

-- ----------------------------
-- 3. 文档同步标记
-- ----------------------------
-- 本文件对应文档位置：第 3 章 → 3.3 基础主数据 → 064 mst_production_line_station
-- 文档路径：/home/claw/.openclaw/workspace/docs/APS开发文档.md