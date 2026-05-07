-- ================================================================
-- SQL #010：mst_calendar / mst_shift / mst_holiday（生产日历、班次、节假日）
-- APS开发文档 §2.2.2
-- ================================================================

-- ----------------------------
-- 表：mst_calendar（生产日历）
-- ----------------------------
DROP TABLE IF EXISTS mst_calendar;
CREATE TABLE mst_calendar (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    calendar_code   VARCHAR(50)     NOT NULL                        COMMENT '日历编码',
    calendar_name   NVARCHAR(200)   NOT NULL                        COMMENT '日历名称',
    factory_id      BIGINT          NOT NULL                        COMMENT '所属工厂（外键→mst_factory.id）',
    calendar_type   VARCHAR(20)     NOT NULL    DEFAULT 'STANDARD'  COMMENT '日历类型：STANDARD=标准工时，24H=24小时连续，SHIFT=班次制',
    default_flag    TINYINT         NOT NULL    DEFAULT 0          COMMENT '是否默认日历：0=否，1=是',
    status          TINYINT         NOT NULL    DEFAULT 1          COMMENT '状态：0=草稿，1=生效，2=禁用',
    remark          VARCHAR(500)    NULL                             COMMENT '备注',
    created_by      VARCHAR(50)     NOT NULL                        COMMENT '创建人',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by      VARCHAR(50)     NULL                             COMMENT '更新人',
    updated_at      DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted      TINYINT         NOT NULL    DEFAULT 0          COMMENT '逻辑删除：0=未删除，1=已删除',
    version         INT             NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_calendar_code (calendar_code),
    INDEX idx_calendar_factory (factory_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生产日历表';

-- ----------------------------
-- 表：mst_shift（班次定义）
-- ----------------------------
DROP TABLE IF EXISTS mst_shift;
CREATE TABLE mst_shift (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    calendar_id     BIGINT          NOT NULL                        COMMENT '所属日历（外键→mst_calendar.id）',
    shift_code      VARCHAR(20)     NOT NULL                        COMMENT '班次编码：A=早班，B=中班，C=晚班，D=深夜班',
    shift_name      NVARCHAR(100)   NOT NULL                        COMMENT '班次名称：早班/中班/晚班/深夜班',
    start_time      TIME            NOT NULL                        COMMENT '班次开始时间',
    end_time        TIME            NOT NULL                        COMMENT '班次结束时间',
    work_hours      DECIMAL(5,2)    NOT NULL                        COMMENT '工作时数（小时）',
    shift_order     INT             NOT NULL    DEFAULT 0          COMMENT '班次顺序（一天内排序）',
    night_flag      TINYINT         NOT NULL    DEFAULT 0          COMMENT '跨夜标识：0=当日内，1=跨到次日',
    status          TINYINT         NOT NULL    DEFAULT 1          COMMENT '状态：0=草稿，1=生效，2=禁用',
    remark          VARCHAR(500)    NULL                             COMMENT '备注',
    created_by      VARCHAR(50)     NOT NULL                        COMMENT '创建人',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by      VARCHAR(50)     NULL                             COMMENT '更新人',
    updated_at      DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted      TINYINT         NOT NULL    DEFAULT 0          COMMENT '逻辑删除：0=未删除，1=已删除',
    version         INT             NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    INDEX idx_shift_calendar (calendar_id),
    CONSTRAINT fk_shift_calendar FOREIGN KEY (calendar_id) REFERENCES mst_calendar(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班次定义表';

-- ----------------------------
-- 表：mst_holiday（节假日定义）
-- ----------------------------
DROP TABLE IF EXISTS mst_holiday;
CREATE TABLE mst_holiday (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    factory_id      BIGINT          NOT NULL                        COMMENT '所属工厂（外键→mst_factory.id）',
    holiday_date    DATE            NOT NULL                        COMMENT '节假日日期',
    holiday_name    NVARCHAR(200)   NOT NULL                        COMMENT '节假日名称',
    holiday_type    VARCHAR(20)     NOT NULL    DEFAULT 'HOLIDAY'  COMMENT '类型：HOLIDAY=全天假，WORKDAY=调休上班日',
    affect_shifts   TINYINT         NOT NULL    DEFAULT 1          COMMENT '是否影响班次安排：0=否，1=是',
    remark          VARCHAR(500)    NULL                             COMMENT '备注',
    created_by      VARCHAR(50)     NOT NULL                        COMMENT '创建人',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by      VARCHAR(50)     NULL                             COMMENT '更新人',
    updated_at      DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted      TINYINT         NOT NULL    DEFAULT 0          COMMENT '逻辑删除：0=未删除，1=已删除',
    version         INT             NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_factory_date (factory_id, holiday_date),
    INDEX idx_holiday_date (holiday_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='节假日定义表';