-- 068_sch_demand_wo（排程需求工单关联表）
-- 记录每次排程中参与的具体工单及其优先级、紧急程度
-- 一个需求可关联多个工单，一个工单可在多次排程中被关联

CREATE TABLE IF NOT EXISTS `sch_demand_wo` (
    `id`                BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    `demand_id`         BIGINT          NOT NULL                    COMMENT '排程需求ID（sch_schedule_demand.id）',
    `wo_id`             BIGINT          NOT NULL                    COMMENT '工单ID（ord_work_order.id）',
    `priority`          INT             NOT NULL    DEFAULT 100      COMMENT '工单优先级（1最高，数字越大越低）',
    `urgent_level`      VARCHAR(16)     NOT NULL    DEFAULT 'NORMAL' COMMENT '紧急程度：URGENT/HIGH/NORMAL/LOW',
    `due_date_weight`   DECIMAL(5,2)    NOT NULL    DEFAULT 1.0      COMMENT '交期权重系数（影响延迟惩罚）',
    `quantity_weight`   DECIMAL(5,2)    NOT NULL    DEFAULT 1.0      COMMENT '数量权重系数（影响批量工单）',
    `pre_assigned_line` BIGINT          NULL                        COMMENT '预分配产线（可选，为空则由求解器自动分配）',
    `pre_assigned_date` DATE            NULL                        COMMENT '预分配日期（可选）',
    `is_fixed`          TINYINT(1)      NOT NULL    DEFAULT 0        COMMENT '是否固定（固定则不允许调整位置）',
    `scheduled`        TINYINT(1)      NOT NULL    DEFAULT 0        COMMENT '本次是否排入',
    `scheduled_line_id` BIGINT          NULL                        COMMENT '排入产线ID',
    `scheduled_start`   DATETIME        NULL                        COMMENT '排入开始时间',
    `scheduled_end`     DATETIME        NULL                        COMMENT '排入结束时间',
    `delay_days`        INT             NULL                        COMMENT '延迟天数（正值表示延迟，负值表示提前）',
    `remark`            VARCHAR(500)    NULL                        COMMENT '备注',
    `created_by`        VARCHAR(64)     NOT NULL                    COMMENT '创建人',
    `created_at`        DATETIME        NOT NULL                    COMMENT '创建时间',
    `updated_by`        VARCHAR(64)     NULL                        COMMENT '修改人',
    `updated_at`        DATETIME        NOT NULL                    COMMENT '修改时间',
    `version`           INT             NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_demand_wo` (`demand_id`, `wo_id`),
    INDEX `idx_demand_id` (`demand_id`),
    INDEX `idx_wo_id` (`wo_id`),
    INDEX `idx_priority` (`priority`),
    INDEX `idx_scheduled` (`scheduled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='排程需求工单关联表';
