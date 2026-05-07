-- ================================================================
-- APS 生产排程系统 - 主数据：排班表
-- 文件：039_mst_shift_assignment.sql
-- 说明：排班主表，记录每个工作中心/产线在特定日期的排班计划
-- 文档：APS开发文档 § 表清单 #018
-- ================================================================

-- ----------------------------
-- 表：mst_shift_assignment（排班表）
-- ----------------------------
DROP TABLE IF EXISTS mst_shift_assignment;
CREATE TABLE mst_shift_assignment (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '排班记录ID',
    workcenter_id       BIGINT          NOT NULL                        COMMENT '工作中心ID（外键→mst_workcenter.id）',
    shift_id            BIGINT          NOT NULL                        COMMENT '班次ID（外键→mst_shift.id）',
    assignment_date     DATE            NOT NULL                        COMMENT '排班日期',
    shift_type          VARCHAR(20)     NOT NULL    DEFAULT 'REGULAR'   COMMENT '班次类型：REGULAR-常规/OT-加班/SHIFT-倒班',
    capacity_hours      DECIMAL(6,2)    NOT NULL                        COMMENT '计划产能（小时）',
    assigned_workers    INT             NOT NULL    DEFAULT 0           COMMENT '已分配工人数',
    max_workers         INT             NOT NULL                        COMMENT '最大可容纳工人数',
    utilization_target  DECIMAL(5,2)    NULL        DEFAULT 0.85        COMMENT '产能利用率目标（0.00-1.00）',
    is_active           TINYINT(1)      NOT NULL    DEFAULT 1           COMMENT '是否启用：1=启用 0=停用',
    status              VARCHAR(20)     NOT NULL    DEFAULT 'PUBLISHED'  COMMENT '状态：PLANNED-已计划/PUBLISHED-已发布/IN_PROGRESS-进行中/COMPLETED-已完成/CANCELED-已取消',
    remarks             VARCHAR(500)    NULL                            COMMENT '备注',
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by          VARCHAR(100)    NOT NULL    DEFAULT 'system'   COMMENT '创建人',
    updated_by          VARCHAR(100)    NOT NULL    DEFAULT 'system'   COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_wc_shift_date (workcenter_id, shift_id, assignment_date),
    KEY idx_assignment_date (assignment_date, is_active),
    KEY idx_workcenter_date (workcenter_id, assignment_date, status),
    KEY idx_status (status, is_active),
    CONSTRAINT fk_sa_workcenter FOREIGN KEY (workcenter_id) REFERENCES mst_workcenter(id),
    CONSTRAINT fk_sa_shift FOREIGN KEY (shift_id) REFERENCES mst_shift(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='排班表（工作中心-班次-日期）';

-- ----------------------------
-- 示例数据
-- ----------------------------
INSERT INTO mst_shift_assignment (workcenter_id, shift_id, assignment_date, capacity_hours, assigned_workers, max_workers, status) VALUES
(1, 1, '2026-05-01', 8.00, 10, 12, 'PUBLISHED'),
(1, 2, '2026-05-01', 8.00, 8, 12, 'PUBLISHED'),
(2, 1, '2026-05-01', 8.00, 6, 8, 'PUBLISHED'),
(1, 1, '2026-05-02', 8.00, 10, 12, 'PUBLISHED'),
(1, 2, '2026-05-02', 8.00, 9, 12, 'PUBLISHED');