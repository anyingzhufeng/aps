-- ================================================================
-- APS 生产排程系统 - 主数据：班次
-- 文件：012_mst_shift.sql
-- 说明：班次定义表，归属日历，一个日历可包含多个班次
-- ================================================================

-- ----------------------------
-- 表：mst_shift（班次定义）
-- ----------------------------
CREATE TABLE IF NOT EXISTS mst_shift (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    calendar_id     BIGINT          NOT NULL                    COMMENT '所属日历ID',
    shift_code      VARCHAR(20)      NOT NULL                    COMMENT '班次代码',
    shift_name      VARCHAR(50)      NOT NULL                    COMMENT '班次名称：早班/中班/夜班',
    start_time      TIME            NOT NULL                    COMMENT '班次开始时间',
    end_time        TIME            NOT NULL                    COMMENT '班次结束时间',
    break_minutes   INT             NOT NULL    DEFAULT 0         COMMENT '休息时长（分钟）',
    shift_hours     DECIMAL(6,2)    NOT NULL                    COMMENT '有效工时（end-start-break，单位：小时）',
    is_active       TINYINT(1)      NOT NULL    DEFAULT 1         COMMENT '是否启用：1-是，0-否',
    is_deleted      TINYINT(1)      NOT NULL    DEFAULT 0         COMMENT '软删除标记',
    version         INT              NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',
    created_at      DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '创建人',
    updated_by      VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_shift_code (shift_code),
    KEY idx_shift_calendar (calendar_id),
    CONSTRAINT fk_shift_calendar FOREIGN KEY (calendar_id) REFERENCES mst_calendar(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='班次定义表';
