-- ============================================================
-- APS开发文档 · SQL文件 #060
-- 表名：mst_workshop（车间表）
-- 说明：APS系统车间基础数据表（002已有，本文件为补充/完整版本）
-- 创建时间：2026-05-04
-- ============================================================

CREATE TABLE IF NOT EXISTS `mst_workshop` (
    `id`                BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    `workshop_code`     VARCHAR(32)     NOT NULL                    COMMENT '车间编码',
    `workshop_name`     VARCHAR(128)    NOT NULL                    COMMENT '车间名称',
    `factory_id`        BIGINT          NOT NULL                    COMMENT '所属工厂ID（mst_factory.id）',
    `sub_workshop_id`   BIGINT          NULL                        COMMENT '所属子车间ID（自关联mst_workshop.id）',
    `workshop_type`     VARCHAR(16)     NOT NULL    DEFAULT 'ASSEMBLY' COMMENT '车间类型：ASSEMBLY=装配车间，PROCESS=加工车间，MIXED=混合车间',
    `location_code`     VARCHAR(64)     NULL                        COMMENT '物理位置编码',
    `address`           NVARCHAR(256)   NULL                        COMMENT '地址',
    `manager_id`        BIGINT          NULL                        COMMENT '负责人ID（mst_employee.id）',
    `manager_name`      VARCHAR(64)     NULL                        COMMENT '负责人姓名（冗余）',
    `phone`             VARCHAR(32)     NULL                        COMMENT '联系电话',
    `capacity_hours`    DECIMAL(8,2)    NULL        DEFAULT 24.00   COMMENT '日产能工时（小时）',
    `efficiency_target` DECIMAL(5,2)    NULL        DEFAULT 100.00  COMMENT '效率目标（%）',
    `status`            VARCHAR(16)     NOT NULL    DEFAULT 'ACTIVE'    COMMENT '状态：ACTIVE=启用，INACTIVE=停用',
    `is_virtual`        TINYINT         NOT NULL    DEFAULT 0       COMMENT '是否虚拟车间',
    `priority`          INT             NULL        DEFAULT 100     COMMENT '调度优先级（越小越优先）',
    `description`       NVARCHAR(500)   NULL                        COMMENT '备注说明',
    `version`           INT             NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',
    `created_by`        VARCHAR(64)     NOT NULL                    COMMENT '创建人',
    `created_at`        DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_by`        VARCHAR(64)     NULL                        COMMENT '修改人',
    `updated_at`        DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_workshop_code` (`workshop_code`),
    KEY `idx_factory_id` (`factory_id`),
    KEY `idx_sub_workshop_id` (`sub_workshop_id`),
    KEY `idx_workshop_type` (`workshop_type`),
    KEY `idx_status` (`status`),
    KEY `idx_manager_id` (`manager_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车间基础信息表';
