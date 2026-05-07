-- ================================================================
-- 033_mst_employee.sql
-- 员工主数据表（EMP）
-- ================================================================

-- 员工主数据表：APS系统中的员工基础信息，与HR系统同步
CREATE TABLE mst_employee (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    emp_code            VARCHAR(64)     NOT NULL    COMMENT '员工工号',
    emp_name            NVARCHAR(100)  NOT NULL    COMMENT '员工姓名',
    emp_type            TINYINT         NOT NULL    DEFAULT 1 COMMENT '员工类型：1=正式，2=临时，3=外包',
    gender              TINYINT         NULL        COMMENT '性别：1=男，2=女',
    id_card_no          VARCHAR(20)     NULL        COMMENT '身份证号',
    phone               VARCHAR(20)     NULL        COMMENT '联系电话',
    email               VARCHAR(100)    NULL        COMMENT '电子邮箱',
    department_id       VARCHAR(64)     NULL        COMMENT '所属部门编码',
    department_name     NVARCHAR(100)  NULL        COMMENT '所属部门名称',
    factory_id          BIGINT          NULL        COMMENT '所属工厂ID',
    workshop_id         BIGINT          NULL        COMMENT '所属车间ID',
    workcenter_id       BIGINT          NULL        COMMENT '所属工作中心ID',
    entry_date          DATE            NULL        COMMENT '入职日期',
    leave_date          DATE            NULL        COMMENT '离职日期',
    emp_status          TINYINT         NOT NULL    DEFAULT 1 COMMENT '员工状态：1=在职，2=离职，3=停薪留职',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_emp_code (emp_code),
    KEY idx_factory_id  (factory_id),
    KEY idx_workshop_id (workshop_id),
    KEY idx_emp_status  (emp_status),
    KEY idx_is_active   (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='员工主数据表';
