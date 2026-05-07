-- =====================================================
-- 091 mst_workshop_schedule_config（车间排程配置表）
-- =====================================================
-- 用途：记录每个车间的排程参数配置，包括优化目标、约束权重、算法选择等
-- 父级：mst_workshop (车间基础信息表)
-- =====================================================

CREATE TABLE mst_workshop_schedule_config (
    config_id          VARCHAR(36)  NOT NULL COMMENT '配置主键UUID',
    workshop_code      VARCHAR(20)  NOT NULL COMMENT '车间编码',
    config_version     VARCHAR(10)  NOT NULL DEFAULT 'V1' COMMENT '配置版本',
    optimizer_type     VARCHAR(20)  NOT NULL DEFAULT 'MILP' COMMENT '优化器类型：MILP/Heuristic/Hybrid',
    objective_function VARCHAR(50)  NOT NULL DEFAULT 'makespan' COMMENT '优化目标：makespan/flowtime/lateness/setup',
    priority_rule      VARCHAR(50)  NOT NULL DEFAULT 'FIFO' COMMENT '调度优先级规则',
    allow_split_wo     TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '是否允许工单拆分',
    allow_overload     TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '是否允许超负荷',
    max_utilization    DECIMAL(5,2) NOT NULL DEFAULT 100.00 COMMENT '最大利用率上限(%)',
    min_utilization    DECIMAL(5,2) NOT NULL DEFAULT 0.00 COMMENT '最小利用率下限(%)',
    setup_time_mode    VARCHAR(20)  NOT NULL DEFAULT 'fixed' COMMENT '换型时间模式：fixed/dynamic/sequence_dependent',
    release_date_mode  VARCHAR(20)  NOT NULL DEFAULT 'immediate' COMMENT '工单释放模式：immediate/horizon/batch',
    frozen_horizon_hrs  INT          NOT NULL DEFAULT 0 COMMENT '冻结区间（小时），区间内不重新排程',
    lookahead_days     INT          NOT NULL DEFAULT 7 COMMENT '排程展望期（天）',
    schedule_horizon_hrs INT         NOT NULL DEFAULT 168 COMMENT '排程总窗口（小时）',
    weight_makespan    DECIMAL(6,3) NOT NULL DEFAULT 1.000 COMMENT '目标权重：总完工时间',
    weight_flowtime    DECIMAL(6,3) NOT NULL DEFAULT 0.500 COMMENT '目标权重：总流经时间',
    weight_tardiness   DECIMAL(6,3) NOT NULL DEFAULT 2.000 COMMENT '目标权重：总延迟量',
    weight_setup       DECIMAL(6,3) NOT NULL DEFAULT 0.300 COMMENT '目标权重：总换型时间',
    weight_workload    DECIMAL(6,3) NOT NULL DEFAULT 0.100 COMMENT '目标权重：负荷均衡',
    penalty_overload   DECIMAL(8,3) NOT NULL DEFAULT 1000.000 COMMENT '超负荷惩罚系数',
    penalty_split      DECIMAL(8,3) NOT NULL DEFAULT 500.000 COMMENT '工单拆分惩罚系数',
    time_limit_seconds INT          NOT NULL DEFAULT 300 COMMENT 'MILP求解时间限制（秒）',
    mip_gap            DECIMAL(6,5) NOT NULL DEFAULT 0.001 COMMENT 'MIP最优性间隙',
    threads            INT          NOT NULL DEFAULT 4 COMMENT '求解线程数',
    is_active          TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '是否启用',
    remarks            VARCHAR(500) NULL COMMENT '备注',
    created_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by         VARCHAR(36)  NULL COMMENT '创建人',
    updated_by         VARCHAR(36)  NULL COMMENT '更新人',
    PRIMARY KEY (config_id),
    UNIQUE KEY uk_workshop_version (workshop_code, config_version),
    KEY idx_workshop_code (workshop_code),
    KEY idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='车间排程配置表';
