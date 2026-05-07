-- ================================================================
-- APS 生产排程系统 - 排程结果：派工单主表
-- 文件：072_sch_dispatch_list.sql
-- 说明：派工单主表，记录排程后的派工任务，一个派工单对应一个或多个工序
-- ================================================================

DROP TABLE IF EXISTS sch_dispatch_list;
CREATE TABLE sch_dispatch_list (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT   COMMENT '主键',
    dispatch_no         VARCHAR(64)      NOT NULL                        COMMENT '派工单编号',
    dispatch_type       VARCHAR(16)      NOT NULL                        COMMENT '派工类型：MANUAL/AUTO/SEMI',
    demand_id           VARCHAR(64)      NULL                            COMMENT '关联需求ID（可选）',
    priority            INT              NOT NULL    DEFAULT 100        COMMENT '优先级（越小越高）',
    status              VARCHAR(16)      NOT NULL    DEFAULT 'PENDING'   COMMENT '状态：PENDING/ASSIGNED/COMPLETED/CANCELLED',
    source_schedule_id  BIGINT           NULL                            COMMENT '来源排程结果ID（→sch_schedule_result.id）',
    planned_date        DATE             NOT NULL                        COMMENT '计划日期',
    workshop_code       VARCHAR(64)      NOT NULL                        COMMENT '车间编码',
    workcenter_code     VARCHAR(64)      NULL                            COMMENT '工作中心编码',
    line_code           VARCHAR(64)      NULL                            COMMENT '产线编码',
    assigned_to         VARCHAR(64)      NULL                            COMMENT '指派给（人员/班组编码）',
    assigned_at         DATETIME         NULL                            COMMENT '指派时间',
    start_time          DATETIME         NULL                            COMMENT '计划开始时间',
    end_time            DATETIME         NULL                            COMMENT '计划结束时间',
    actual_start_time   DATETIME         NULL                            COMMENT '实际开始时间',
    actual_end_time     DATETIME         NULL                            COMMENT '实际结束时间',
    output_qty          DECIMAL(18,4)    NULL                            COMMENT '实际产出数量',
    qualified_qty       DECIMAL(18,4)    NULL                            COMMENT '合格数量',
    reject_qty          DECIMAL(18,4)    NULL                            COMMENT '不良数量',
    scrap_qty           DECIMAL(18,4)    NULL                            COMMENT '报废数量',
    efficiency          DECIMAL(5,4)     NULL                            COMMENT '实际效率',
    is_split            TINYINT(1)       NOT NULL    DEFAULT 0           COMMENT '是否拆分批次',
    split_count         INT              NULL                            COMMENT '拆分批次数',
    parent_dispatch_id  BIGINT           NULL                            COMMENT '父派工单ID（拆分时引用）',
    remark              VARCHAR(500)     NULL                            COMMENT '备注',
    created_by          VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version             INT              NOT NULL    DEFAULT 0           COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_dispatch_no (dispatch_no),
    KEY idx_status (status),
    KEY idx_planned_date (planned_date),
    KEY idx_workshop (workshop_code),
    KEY idx_demand (demand_id),
    KEY idx_source_schedule (source_schedule_id),
    KEY idx_priority (priority),
    KEY idx_assigned (assigned_to)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='派工单主表';

-- 示例数据
INSERT INTO sch_dispatch_list (dispatch_no, dispatch_type, priority, status, planned_date, workshop_code, workcenter_code, assigned_to, created_by) VALUES
('DISP-20260506-001', 'AUTO', 50, 'PENDING', '2026-05-06', 'WS-001', 'WC-001', 'TEAM-A', 'system'),
('DISP-20260506-002', 'AUTO', 100, 'PENDING', '2026-05-06', 'WS-001', 'WC-002', 'TEAM-B', 'system');
