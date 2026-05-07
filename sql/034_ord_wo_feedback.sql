-- ================================================================
-- 034_ord_wo_feedback.sql
-- 工单反馈/报工表（FWB）
-- ================================================================

-- 工单工序反馈表（Forward Flush Feedback）：记录每个工序的实际完工情况
CREATE TABLE ord_wo_feedback (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    wo_id               BIGINT          NOT NULL    COMMENT '工单ID',
    wo_code             VARCHAR(64)     NOT NULL    COMMENT '工单编号',
    operation_id        BIGINT          NOT NULL    COMMENT '工序ID',
    operation_seq       INT             NOT NULL    COMMENT '工序序号',
    feedback_no         VARCHAR(64)     NOT NULL    COMMENT '反馈单编号',
    feedback_type       TINYINT         NOT NULL    COMMENT '反馈类型：1=正常报工，2=补报，3=返修报工',
    plan_qty            DECIMAL(18,6)   NOT NULL    COMMENT '计划数量',
    feedback_qty        DECIMAL(18,6)   NOT NULL    COMMENT '实际反馈数量',
    qualified_qty       DECIMAL(18,6)   NOT NULL    COMMENT '合格数量',
    scrap_qty           DECIMAL(18,6)   NULL        DEFAULT 0 COMMENT '报废数量',
    rework_qty          DECIMAL(18,6)   NULL        DEFAULT 0 COMMENT '返修数量',
    reject_qty          DECIMAL(18,6)   NULL        DEFAULT 0 COMMENT '拒收数量',
    start_time          DATETIME        NULL        COMMENT '实际开始时间',
    end_time            DATETIME        NULL        COMMENT '实际结束时间',
    workcenter_id       BIGINT          NOT NULL    COMMENT '工作中心ID',
    machine_id          BIGINT          NULL        COMMENT '设备ID',
    worker_id           BIGINT          NULL        COMMENT '作业人员ID',
    team_id             VARCHAR(64)     NULL        COMMENT '班组ID',
    labor_hours         DECIMAL(10,2)   NULL        COMMENT '实际工时（小时）',
    machine_hours       DECIMAL(10,2)   NULL        COMMENT '机器工时（小时）',
    defect_desc         NVARCHAR(500)   NULL        COMMENT '不良描述',
    feedback_status     TINYINT         NOT NULL    DEFAULT 1 COMMENT '状态：1=已提交，2=已确认，3=已审核',
    inspector           VARCHAR(64)     NULL        COMMENT '审核人',
    inspect_time        DATETIME        NULL        COMMENT '审核时间',
    remark              NVARCHAR(500)   NULL        COMMENT '备注',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NOT NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_feedback_no (feedback_no),
    KEY idx_wo_id       (wo_id),
    KEY idx_operation_id (operation_id),
    KEY idx_feedback_type (feedback_type),
    KEY idx_feedback_status (feedback_status),
    KEY idx_workcenter_id (workcenter_id),
    KEY idx_created_at  (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工单工序反馈表';

-- 工单反馈行项目（每条反馈包含的明细物料消耗）
CREATE TABLE ord_wo_feedback_item (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    feedback_id         BIGINT          NOT NULL    COMMENT '反馈主表ID',
    material_id         BIGINT          NOT NULL    COMMENT '物料ID',
    material_code       VARCHAR(64)     NOT NULL    COMMENT '物料编码',
    material_name       NVARCHAR(200)  NULL        COMMENT '物料名称',
    unit                VARCHAR(20)     NULL        COMMENT '单位',
    plan_consume_qty    DECIMAL(18,6)   NULL        COMMENT '计划消耗数量',
    actual_consume_qty  DECIMAL(18,6)   NULL        COMMENT '实际消耗数量',
    lot_no              VARCHAR(100)    NULL        COMMENT '批次号',
    warehouse_id        BIGINT          NULL        COMMENT '仓库ID',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_feedback_id (feedback_id),
    KEY idx_material_id (material_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工单反馈行项目表';
