-- ================================================================
-- SQL #020：sch_milp_param（排程参数配置表）
-- APS开发文档 §2.3.2 / 序号 22
-- 创建时间：2026-05-01
-- 说明：用户可配置每种约束的权重和开关，影响求解器行为
-- ================================================================

USE aps;

-- ---------------------------------------------------------------
-- 2.3.2 排程参数配置表
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sch_milp_param (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键',
    param_key       VARCHAR(100)   NOT NULL COMMENT '参数键（唯一）',
    param_value     VARCHAR(500)   NOT NULL COMMENT '参数值（JSON/字符串）',
    param_type      VARCHAR(20)    NOT NULL COMMENT '类型：DECIMAL / INT / BOOL / STRING / JSON',
    category        VARCHAR(30)     NOT NULL COMMENT '分类：HARD_CONSTRAINT / SOFT_CONSTRAINT / ALGORITHM / BUSINESS',
    description     VARCHAR(500)    DEFAULT NULL COMMENT '参数描述',
    min_value       VARCHAR(100)   DEFAULT NULL COMMENT '最小值（校验用）',
    max_value       VARCHAR(100)   DEFAULT NULL COMMENT '最大值（校验用）',
    default_value   VARCHAR(500)   DEFAULT NULL COMMENT '默认值',
    options_json    JSON           DEFAULT NULL COMMENT '可选值列表（JSON数组）',
    is_active       TINYINT(1)      NOT NULL DEFAULT 1 COMMENT '是否启用：1=启用 0=禁用',
    is_override     TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否可被工单级别覆盖',
    version         INT             NOT NULL DEFAULT 0 COMMENT '乐观锁版本号',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(50)     NOT NULL COMMENT '创建人',
    updated_by      VARCHAR(50)     NOT NULL COMMENT '更新人',
    is_deleted      TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '软删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_param_key (param_key)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='排程参数配置表'
;

-- ---------------------------------------------------------------
-- 核心参数示例数据
-- ---------------------------------------------------------------
INSERT INTO sch_milp_param (param_key, param_value, param_type, category, description, min_value, max_value, default_value, is_active, created_by, updated_by) VALUES
-- ===== 冻结期与计划范围 =====
('frozen_window_hours',    '8',    'INT',    'BUSINESS',       '冻结窗口时长（小时），冻结期内工单不允许重排',   '0',   '168',  '8',    1, 'system', 'system'),
('planning_horizon_days', '14',   'INT',    'BUSINESS',       '计划周期天数（从当前日期起算）',               '1',   '90',   '14',   1, 'system', 'system'),
('max_schedule_horizon_days', '30', 'INT',   'BUSINESS',       '最大计划期天数（手动触发排程时）',              '1',   '365',  '30',   1, 'system', 'system'),

-- ===== 求解器全局参数 =====
('max_solve_time_sec',     '300',  'INT',    'ALGORITHM',      '最大求解时间（秒）',                          '10',  '3600', '300',  1, 'system', 'system'),
('max_iterations',        '1000', 'INT',    'ALGORITHM',      '最大迭代次数（启发式/GA）',                   '100', '100000','1000',1, 'system', 'system'),
('time_limit_per_wo_sec', '60',   'INT',    'ALGORITHM',      '单个工单最大求解时间（秒）',                  '5',   '300',  '60',   1, 'system', 'system'),
('solver_mode',           '"AUTO"', 'STRING','ALGORITHM',     '求解器模式：AUTO / HEURISTIC / GA / CP_SAT / MILP', NULL, NULL, '"AUTO"', 1, 'system', 'system'),
('enable_parallel_solver','true',  'BOOL',   'ALGORITHM',      '启用并行求解（多初始解）',                    NULL,  NULL,   'true',  1, 'system', 'system'),

-- ===== 硬约束（必须满足） =====
('hard_machine_available',   'true', 'BOOL', 'HARD_CONSTRAINT', '设备可用性约束（维护停机不得排入）',         NULL, NULL, 'true',  1, 'system', 'system'),
('hard_skill_match',         'true', 'BOOL', 'HARD_CONSTRAINT', '技能匹配约束（操作员必须具备所需技能）',     NULL, NULL, 'true',  1, 'system', 'system'),
('hard_calendar_worktime',  'true', 'BOOL', 'HARD_CONSTRAINT', '日历工作时间约束（仅在班次时间内排程）',     NULL, NULL, 'true',  1, 'system', 'system'),
('hard_no_split_operation',  'true', 'BOOL', 'HARD_CONSTRAINT', '工序不可拆分（一个工序必须在同一设备连续完成）', NULL, NULL, 'true', 1, 'system', 'system'),
('hard_sequence_dependency', 'true', 'BOOL', 'HARD_CONSTRAINT', '工序顺序约束（必须按工艺路线顺序执行）',    NULL, NULL, 'true',  1, 'system', 'system'),
('hard_no_overload',         'true', 'BOOL', 'HARD_CONSTRAINT', '设备不过载约束（不超过设备产能）',           NULL, NULL, 'true',  1, 'system', 'system'),
('hard_bom_requirement',     'true', 'BOOL', 'HARD_CONSTRAINT', '物料齐套约束（库存不足不得开工）',           NULL, NULL, 'true',  1, 'system', 'system'),

-- ===== 软约束（优化目标） =====
('soft_minimize_tardiness',    'true',  'BOOL',    'SOFT_CONSTRAINT', '最小化延迟工单数',                              NULL, NULL, 'true',  1, 'system', 'system'),
('soft_minimize_tardiness_wt', '10.0', 'DECIMAL', 'SOFT_CONSTRAINT', '延迟惩罚权重（越大越不能接受延迟）',             '0.1', '100', '10.0', 1, 'system', 'system'),
('soft_minimize_setup',        'true',  'BOOL',    'SOFT_CONSTRAINT', '最小化换线/换模时间',                          NULL, NULL, 'true',  1, 'system', 'system'),
('soft_minimize_setup_wt',     '1.5',  'DECIMAL', 'SOFT_CONSTRAINT', '换线惩罚权重',                                 '0.0', '50',  '1.5',  1, 'system', 'system'),
('soft_maximize_utilization',  'true',  'BOOL',    'SOFT_CONSTRAINT', '最大化设备利用率',                            NULL, NULL, 'true',  1, 'system', 'system'),
('soft_utilization_target',    '85.0', 'DECIMAL', 'SOFT_CONSTRAINT', '利用率目标值（%）',                          '50', '100', '85.0', 1, 'system', 'system'),
('soft_minimize_work_in_process','false','BOOL',  'SOFT_CONSTRAINT', '最小化在制品（WIP）数量',                    NULL, NULL, 'false', 1, 'system', 'system'),
('soft_balance_load',          'false', 'BOOL',    'SOFT_CONSTRAINT', '均衡工作中心负载',                            NULL, NULL, 'false', 1, 'system', 'system'),
('soft_priority_fifo',         'false', 'BOOL',    'SOFT_CONSTRAINT', '优先处理早到工单（FIFO）',                   NULL, NULL, 'false', 1, 'system', 'system'),
('soft_minimize_overtime',     'false', 'BOOL',    'SOFT_CONSTRAINT', '最小化加班时间',                              NULL, NULL, 'false', 1, 'system', 'system'),

-- ===== 遗传算法（GA）专用参数 =====
('ga_population_size',    '100', 'INT',   'ALGORITHM',  'GA 种群大小',                                 '20',  '500',  '100',  1, 'system', 'system'),
('ga_generations',        '200', 'INT',   'ALGORITHM',  'GA 最大代数',                                 '10',  '2000', '200',  1, 'system', 'system'),
('ga_mutation_rate',      '0.1', 'DECIMAL','ALGORITHM', 'GA 变异率',                                   '0.01','0.5',  '0.1',  1, 'system', 'system'),
('ga_crossover_rate',    '0.8', 'DECIMAL','ALGORITHM', 'GA 交叉率',                                   '0.3', '1.0',  '0.8',  1, 'system', 'system'),
('ga_elite_count',        '10',  'INT',   'ALGORITHM',  'GA 精英保留个数',                             '1',   '50',   '10',   1, 'system', 'system'),

-- ===== CP-SAT 专用参数 =====
('cp_max_time_sec',      '300', 'INT',   'ALGORITHM',  'CP-SAT 最大求解时间（秒）',                   '10',  '1800', '300',  1, 'system', 'system'),
('cp_num_search_workers','0',   'INT',   'ALGORITHM',  'CP-SAT 并行线程数（0=自动）',                  '0',   '32',   '0',    1, 'system', 'system'),
('cp_log_progression',   'false','BOOL', 'ALGORITHM',  '是否输出迭代日志',                            NULL,  NULL,   'false',1, 'system', 'system'),

-- ===== 甘特图与用户体验 =====
('gantt_refresh_interval_sec', '30',   'INT',   'BUSINESS', '甘特图自动刷新间隔（秒），0=不自动刷新',   '0',   '300',  '30',   1, 'system', 'system'),
('gantt_default_zoom',   '"DAY"', 'STRING','BUSINESS', '甘特图默认缩放级别：MINUTE / HOUR / DAY / WEEK', NULL, NULL, '"DAY"', 1, 'system', 'system'),
('notify_on_complete',   'true',  'BOOL', 'BUSINESS', '排程完成后是否发送通知',                       NULL, NULL, 'true',  1, 'system', 'system'),
('notify_on_failure',    'true',  'BOOL', 'BUSINESS', '排程失败时是否发送通知',                      NULL, NULL, 'true',  1, 'system', 'system')
;
