-- ================================================================
-- 表：mst_employee_type（员工类型表）
-- 说明：定义系统中员工的不同类型，如正式员工、临时工、外包员工、实习生等
-- 依赖：mst_department(037)
-- ================================================================

CREATE TABLE mst_employee_type (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    type_code           VARCHAR(64)     NOT NULL    COMMENT '员工类型编码',
    type_name           NVARCHAR(100)   NOT NULL    COMMENT '员工类型名称',
    type_name_en        VARCHAR(100)    NULL        COMMENT '员工类型英文名',
    category            VARCHAR(32)     NULL        COMMENT '类别：FULL_TIME=全职，PART_TIME=兼职，TEMPORARY=临时，OUTSOURCE=外包，INTERN=实习',
    billing_type        VARCHAR(32)     NULL        COMMENT '计费方式：HOURLY=按小时，DAILY=按天，MONTHLY=月薪',
    hourly_rate         DECIMAL(10,2)   NULL        COMMENT '小时费率',
    daily_rate          DECIMAL(10,2)   NULL        COMMENT '日费率',
    monthly_rate        DECIMAL(12,2)   NULL        COMMENT '月薪费率',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    sort_order          INT             NOT NULL    DEFAULT 0,
    remarks             NVARCHAR(500)   NULL,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_type_code (type_code),
    KEY idx_is_active   (is_active),
    KEY idx_category    (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='员工类型表';

-- 初始化员工类型数据
INSERT INTO mst_employee_type (id, type_code, type_name, category, billing_type, sort_order) VALUES
    (1,  'FULL_TIME',   '正式员工',     'FULL_TIME',   'MONTHLY',  1),
    (2,  'PART_TIME',   '兼职员工',     'PART_TIME',   'HOURLY',   2),
    (3,  'TEMPORARY',   '临时工',       'TEMPORARY',   'DAILY',    3),
    (4,  'OUTSOURCE',   '外包员工',     'OUTSOURCE',   'MONTHLY',  4),
    (5,  'INTERN',      '实习生',       'INTERN',      'MONTHLY',  5);
