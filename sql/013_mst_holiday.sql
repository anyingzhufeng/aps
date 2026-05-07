-- ================================================================
-- APS 生产排程系统 - 主数据：节假日
-- 文件：013_mst_holiday.sql
-- 说明：节假日定义表，支持按日期范围批量定义或单日定义
-- ================================================================

-- ----------------------------
-- 表：mst_holiday（节假日定义）
-- ----------------------------
CREATE TABLE IF NOT EXISTS mst_holiday (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    factory_id      BIGINT          NULL                        COMMENT '所属工厂ID（NULL表示全局适用）',
    holiday_code    VARCHAR(20)      NOT NULL                    COMMENT '节假日代码',
    holiday_name    VARCHAR(100)     NOT NULL                    COMMENT '节假日名称：元旦/春节/国庆等',
    holiday_type    VARCHAR(20)      NOT NULL    DEFAULT 'NATIONAL' COMMENT '节假日类型：NATIONAL/FACTORY/CUSTOM',
    holiday_date    DATE            NULL                        COMMENT '单日节假日日期（period_type=DATE时使用）',
    period_start    DATE            NULL                        COMMENT '节假日区间开始日期（period_type=PERIOD时使用）',
    period_end      DATE            NULL                        COMMENT '节假日区间结束日期（period_type=PERIOD时使用）',
    period_type     VARCHAR(10)      NOT NULL    DEFAULT 'DATE' COMMENT '类型：DATE单日/PERIOD区间',
    is_paid         TINYINT(1)      NOT NULL    DEFAULT 1         COMMENT '是否带薪：1-是，0-否',
    shift_required  TINYINT(1)      NOT NULL    DEFAULT 0         COMMENT '是否需要调休班：1-是，0-否',
    remark          VARCHAR(500)    NULL                        COMMENT '备注说明',
    is_active       TINYINT(1)      NOT NULL    DEFAULT 1         COMMENT '是否启用：1-是，0-否',
    is_deleted      TINYINT(1)      NOT NULL    DEFAULT 0         COMMENT '软删除标记',
    version         INT              NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',
    created_at      DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '创建人',
    updated_by      VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_holiday_code (holiday_code),
    KEY idx_holiday_date (holiday_date),
    KEY idx_holiday_period (period_start, period_end),
    KEY idx_holiday_factory (factory_id),
    CONSTRAINT fk_holiday_factory FOREIGN KEY (factory_id) REFERENCES mst_factory(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='节假日定义表';

-- ----------------------------
-- 示例数据
-- ----------------------------
INSERT INTO mst_holiday (factory_id, holiday_code, holiday_name, holiday_type, holiday_date, period_type, is_paid, shift_required) VALUES
(NULL, 'NEW_YEAR_2026', '2026年元旦', 'NATIONAL', '2026-01-01', 'DATE', 1, 0),
(NULL, 'SPRING_FESTIVAL_2026', '2026年春节', 'NATIONAL', NULL, 'PERIOD', 1, 1);
