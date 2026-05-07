-- ================================================================
-- 071 sch_demand_constraint（排程需求约束表）
-- 约束类型：资源容量约束、时间窗约束、优先顺序约束
-- 建立时间：2026-05-05
-- ================================================================

CREATE TABLE sch_demand_constraint (
    id                BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '主键',
    demand_id         BIGINT          NOT NULL    COMMENT '排程需求ID，关联 sch_schedule_demand.id',
    constraint_type   VARCHAR(32)     NOT NULL    COMMENT '约束类型：RESOURCE_CAP/TIME_WINDOW/PRIORITY/SEQUENCING/BUFFER',
    constraint_code   VARCHAR(64)     NOT NULL    COMMENT '约束编码',
    constraint_name   VARCHAR(128)    NOT NULL    COMMENT '约束名称',
    resource_id       BIGINT          NULL        COMMENT '资源ID（如工位/产线/模具），TYPE为RESOURCE_CAP时必填',
    resource_type     VARCHAR(32)     NULL        COMMENT '资源类型：MACHINE/WORKCENTER/TOOL/MOLD',
    min_value         DECIMAL(18,4)   NULL        COMMENT '约束下限值',
    max_value         DECIMAL(18,4)   NULL        COMMENT '约束上限值',
    time_window_start DATETIME        NULL        COMMENT '时间窗开始时间',
    time_window_end   DATETIME        NULL        COMMENT '时间窗结束时间',
    priority_weight   DECIMAL(5,2)    NULL        DEFAULT 1.00 COMMENT '优先级权重（1-10）',
    is_hard           TINYINT(1)      NOT NULL    DEFAULT 1 COMMENT '是否硬约束：1=硬约束（必须满足），0=软约束（优化目标）',
    is_active         TINYINT(1)      NOT NULL    DEFAULT 1 COMMENT '是否启用',
    expression        VARCHAR(512)    NULL        COMMENT '约束表达式（JSON格式）',
    remark            VARCHAR(500)    NULL        COMMENT '备注说明',
    created_by        VARCHAR(64)     NOT NULL    COMMENT '创建人',
    created_at        DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by        VARCHAR(64)     NULL        COMMENT '修改人',
    updated_at        DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version           INT             NOT NULL    DEFAULT 0 COMMENT '乐观锁版本号',

    PRIMARY KEY (id),
    INDEX idx_demand_id (demand_id),
    INDEX idx_constraint_type (constraint_type),
    INDEX idx_resource_id (resource_id),
    INDEX idx_is_active (is_active),
    INDEX idx_time_window (time_window_start, time_window_end)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='排程需求约束表';

-- 典型约束场景说明：
-- 1. 资源容量约束（RESOURCE_CAP）：某工位每日最大加工数量不超过200件
-- 2. 时间窗约束（TIME_WINDOW）：某模具只能在工作日08:00-18:00使用
-- 3. 优先顺序约束（PRIORITY）：工单A必须先于工单B完成
-- 4. 排序约束（SEQUENCING）：同一产品连续生产数量不得低于批量最小值
-- 5. 安全缓冲约束（BUFFER）：某关键物料库存不得低于安全库存