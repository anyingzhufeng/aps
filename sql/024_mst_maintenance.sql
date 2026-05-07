-- ================================================================
-- APS 生产排程系统 - 主数据：设备维护计划
-- 文件：024_mst_maintenance.sql
-- 说明：记录每台设备的维护计划（预防性/纠正性/预测性维护）
-- ================================================================

-- ----------------------------
-- 表：mst_maintenance（设备维护计划）
-- ----------------------------
CREATE TABLE IF NOT EXISTS mst_maintenance (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    machine_id      BIGINT          NOT NULL                    COMMENT '设备ID',
    maint_type     VARCHAR(20)     NOT NULL                    COMMENT '维护类型：PREVENTIVE-预防性/CORRECTIVE-纠正性/PREDICTIVE-预测性',
    plan_date       DATE            NOT NULL                    COMMENT '计划维护日期',
    plan_hours      DECIMAL(6,2)    NOT NULL                    COMMENT '计划维护时长（小时）',
    duration_hours  DECIMAL(6,2)   NULL                        COMMENT '实际维护时长（小时）',
    status          VARCHAR(20)     NOT NULL    DEFAULT 'PLANNED' COMMENT '状态：PLANNED-已计划/IN_PROGRESS-进行中/COMPLETED-已完成/CANCELLED-已取消',
    description     VARCHAR(500)    NULL                        COMMENT '维护描述',
    performed_by    VARCHAR(100)    NULL                        COMMENT '执行人',
    actual_date     DATE            NULL                        COMMENT '实际完成日期',
    is_deleted      TINYINT(1)      NOT NULL    DEFAULT 0         COMMENT '软删除标记：1-删除，0-正常',
    version         INT             NOT NULL    DEFAULT 0         COMMENT '乐观锁版本号',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(100)    NOT NULL    DEFAULT 'system' COMMENT '创建人',
    updated_by      VARCHAR(100)    NOT NULL    DEFAULT 'system' COMMENT '更新人',
    PRIMARY KEY (id),
    KEY idx_maint_plan_date (plan_date),
    KEY idx_maint_machine_date (machine_id, plan_date),
    KEY idx_maint_status (status, is_deleted),
    CONSTRAINT fk_maint_machine FOREIGN KEY (machine_id) REFERENCES mst_machine(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备维护计划表';

-- ----------------------------
-- 示例数据
-- ----------------------------
INSERT INTO mst_maintenance (machine_id, maint_type, plan_date, plan_hours, status, description) VALUES
(1, 'PREVENTIVE',  '2026-05-10', 4.00, 'PLANNED',    '月度预防性维护：润滑、清洁、校准'),
(1, 'CORRECTIVE',  '2026-04-15', 8.00, 'COMPLETED',  '紧急维修：更换磨损轴承'),
(2, 'PREVENTIVE',  '2026-05-15', 3.00, 'PLANNED',    '双月预防性维护'),
(3, 'PREDICTIVE',  '2026-06-01', 2.00, 'PLANNED',    '预测性维护：AOI精度校准'),
(4, 'PREVENTIVE',  '2026-05-20', 2.50, 'PLANNED',    '贴片机定期维护');
