-- ================================================================
-- APS 生产排程系统 - 主数据：员工-班次关联
-- 文件：016_mst_worker_shift.sql
-- 说明：记录员工与班次的关联关系，用于排程时确定员工可用时间窗口
-- ================================================================

-- ----------------------------
-- 表：mst_worker_shift（员工-班次关联）
-- ----------------------------
CREATE TABLE IF NOT EXISTS mst_worker_shift (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    worker_id           BIGINT          NOT NULL                    COMMENT '员工ID（外键→mst_worker.id）',
    shift_id            BIGINT          NOT NULL                    COMMENT '班次ID（外键→mst_shift.id）',
    shift_date          DATE            NOT NULL                    COMMENT '班次所属日期',
    is_assigned         TINYINT(1)      NOT NULL    DEFAULT 1       COMMENT '是否已排班：1-已排，0-待排',
    assignment_type     VARCHAR(20)     NOT NULL    DEFAULT 'REGULAR' COMMENT '排班类型：REGULAR-常规/OT-加班/ONCALL-待命',
    work_hours          DECIMAL(5,2)    NULL                        COMMENT '实际工时（可因请假/早退而调整）',
    break_minutes       INT             NOT NULL    DEFAULT 0       COMMENT '休息时长（分钟）',
    overtime_minutes    INT             NOT NULL    DEFAULT 0       COMMENT '加班时长（分钟）',
    status              VARCHAR(20)     NOT NULL    DEFAULT 'SCHEDULED' COMMENT '状态：SCHEDULED-已排班/ON_LEAVE-请假/ABSENT-缺勤/CANCELED-取消',
    remarks             VARCHAR(500)    NULL                        COMMENT '备注（如请假原因等）',
    is_deleted          TINYINT(1)      NOT NULL    DEFAULT 0       COMMENT '软删除标记',
    version             INT             NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by          VARCHAR(100)    NOT NULL    DEFAULT 'system' COMMENT '创建人',
    updated_by          VARCHAR(100)    NOT NULL    DEFAULT 'system' COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_worker_shift_date (worker_id, shift_id, shift_date),
    KEY idx_shift_date (shift_date, is_deleted),
    KEY idx_worker_date (worker_id, shift_date, is_deleted),
    KEY idx_shift_status (shift_id, status, is_deleted),
    CONSTRAINT fk_wsh_worker FOREIGN KEY (worker_id) REFERENCES mst_worker(id),
    CONSTRAINT fk_wsh_shift FOREIGN KEY (shift_id) REFERENCES mst_shift(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='员工-班次关联表';

-- ----------------------------
-- 示例数据
-- ----------------------------
INSERT INTO mst_worker_shift (worker_id, shift_id, shift_date, work_hours, break_minutes, status) VALUES
(1, 1, '2026-05-01', 8.00, 60, 'SCHEDULED'),
(2, 1, '2026-05-01', 8.00, 60, 'SCHEDULED'),
(3, 2, '2026-05-01', 8.00, 60, 'SCHEDULED'),
(1, 1, '2026-05-02', 8.00, 60, 'SCHEDULED'),
(2, 2, '2026-05-02', 8.00, 60, 'SCHEDULED');