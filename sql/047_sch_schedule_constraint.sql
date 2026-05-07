-- ================================================================
-- 表：sch_schedule_constraint（排程约束配置表）
-- 说明：存储排程引擎的约束规则和参数配置，支持灵活启用/禁用各类约束
-- 依赖：mst_workcenter(003), mst_machine(004), mst_calendar(013)
-- ================================================================

DROP TABLE IF EXISTS sch_schedule_constraint;
CREATE TABLE sch_schedule_constraint (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '约束配置ID',
    constraint_code      VARCHAR(64)     NOT NULL                        COMMENT '约束编码',
    constraint_name      NVARCHAR(128)   NOT NULL                        COMMENT '约束名称',
    constraint_type      TINYINT          NOT NULL                        COMMENT '约束类型：1=产能约束 2=物料约束 3=工艺约束 4=交期约束 5=资源约束 9=自定义',
    category            VARCHAR(32)     NOT NULL                        COMMENT '约束类别：CAPACITY=产能 MATERIAL=物料 PROCESS=工艺 DUE_DATE=交期 RESOURCE=资源 CUSTOM=自定义',
    priority_level      TINYINT          NOT NULL    DEFAULT 50           COMMENT '优先级（1=最高，100=最低）',
    scope_type          TINYINT          NOT NULL    DEFAULT 1           COMMENT '作用范围：1=全局 2=车间级 3=工作中心级 4=设备级',
    scope_id            BIGINT          NULL                             COMMENT '范围关联ID（工作中心ID/设备ID等）',
    target_type         TINYINT          NOT NULL                        COMMENT '约束对象类型：1=工作中心 2=设备 3=工序 4=工单',
    target_id           BIGINT          NULL                             COMMENT '约束对象ID',
    constraint_key       VARCHAR(128)    NOT NULL                        COMMENT '约束参数键（如：max_overload_pct, min_lot_size）',
    operator            VARCHAR(16)     NOT NULL                        COMMENT '比较操作符：>=, <=, =, <, >, BETWEEN, IN',
    threshold_value     DECIMAL(20,4)   NULL                             COMMENT '阈值数值',
    threshold_value2    DECIMAL(20,4)   NULL                             COMMENT '阈值2（用于BETWEEN操作符）',
    value_set           JSON             NULL                             COMMENT '值集合（用于IN操作符）',
    is_hard             TINYINT          NOT NULL    DEFAULT 1           COMMENT '是否硬约束：1=硬约束 0=软约束',
    is_active           TINYINT          NOT NULL    DEFAULT 1           COMMENT '是否启用',
    effort_coefficient  DECIMAL(5,2)     NOT NULL    DEFAULT 1.0          COMMENT '松紧系数（0.1~10.0，越小越严格）',
    description         NVARCHAR(500)   NULL                             COMMENT '约束描述',
    formula_expression  VARCHAR(500)    NULL                             COMMENT '公式表达式（高级约束用）',
    exception_teams     JSON             NULL                             COMMENT '豁免班组列表（JSON数组）',
    exception_shifts    JSON             NULL                             COMMENT '豁免班次列表（JSON数组）',
    valid_from          DATETIME         NULL                             COMMENT '生效开始时间',
    valid_to            DATETIME         NULL                             COMMENT '生效结束时间',
    created_by          VARCHAR(64)      NOT NULL    DEFAULT 'system'   COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NOT NULL    DEFAULT 'system'   COMMENT '更新人',
    updated_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted          TINYINT          NOT NULL    DEFAULT 0           COMMENT '软删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_constraint_code (constraint_code),
    KEY idx_constraint_type (constraint_type),
    KEY idx_category (category),
    KEY idx_scope (scope_type, scope_id),
    KEY idx_target (target_type, target_id),
    KEY idx_is_active (is_active),
    KEY idx_is_hard (is_hard),
    KEY idx_priority (priority_level),
    KEY idx_valid_period (valid_from, valid_to)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='排程约束配置表';

-- 初始化默认约束规则（示例）
INSERT INTO sch_schedule_constraint (id, constraint_code, constraint_name, constraint_type, category, priority_level, scope_type, target_type, constraint_key, operator, threshold_value, is_hard, effort_coefficient, description) VALUES
(1,  'CAPACITY_MAX_OVERLOAD',  '产能最大超载率',         1, 'CAPACITY',   20, 1, 1, 'max_overload_pct',    '<=', 20.00,  1, 1.0, '全局产能最大允许超载20%'),
(2,  'CAPACITY_MIN_UTIL',      '产能最小利用率',         1, 'CAPACITY',   50, 1, 1, 'min_utilization_pct', '>=', 60.00,  0, 1.2, '全局产能最低利用率要求60%（软约束）'),
(3,  'MATERIAL_BUFFER_MAX',   '最大物料缓冲量',          2, 'MATERIAL',   30, 1, 4, 'max_buffer_days',      '<=', 7.00,   1, 1.0, '工单物料缓冲不超过7天'),
(4,  'PROCESS_SKILL_MATCH',   '工序技能匹配',            3, 'PROCESS',    10, 1, 3, 'skill_match_required', '=',  1.00,   1, 1.0, '工序必须由具备相应技能的工人执行'),
(5,  'DUEDATE_SAFETY_BUFFER', '交期安全缓冲',           4, 'DUE_DATE',   40, 1, 4, 'safety_buffer_hours', '>=', 24.00,  0, 1.5, '工单交货前至少保留24小时缓冲（软约束）'),
(6,  'RESOURCE_LOCK_CTL',     '资源锁定控制',           5, 'RESOURCE',   15, 4, 2, 'lock_allowed',         'IN',  NULL,   1, 1.0, '关键设备不允许锁定');

-- 更新自增主键
INSERT INTO sch_schedule_constraint (id) VALUES (100) ON DUPLICATE KEY UPDATE id=id;
ALTER TABLE sch_schedule_constraint AUTO_INCREMENT = 101;
