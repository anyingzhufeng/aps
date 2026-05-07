-- ================================================================
-- 表：mst_employee_detail（员工明细表）
-- 序号：051
-- 描述：员工详细信息，包含员工多身份记录
-- ================================================================
-- DROP TABLE IF EXISTS mst_employee_detail;

CREATE TABLE mst_employee_detail (
    id                      BIGINT          NOT NULL    PRIMARY KEY,
    employee_id             BIGINT          NOT NULL    COMMENT '员工主数据ID（关联mst_employee.id）',
    identity_type           VARCHAR(32)     NOT NULL    COMMENT '身份类型：WORKER=操作工，TECHNICIAN=技术员，SUPERVISOR=班组长，ENGINEER=工程师，MANAGER=管理员',
    dept_id                 BIGINT          NOT NULL    COMMENT '所属部门ID',
    position_id             BIGINT          NULL        COMMENT '职位ID（关联mst_position.id）',
    entry_date              DATE            NOT NULL    COMMENT '入职/加入日期',
    leaving_date            DATE            NULL        COMMENT '离职/离开日期（NULL=在职）',
    employment_status       VARCHAR(32)     NOT NULL    DEFAULT 'ACTIVE' COMMENT '在职状态：ACTIVE=在职，PROBATION=试用期，LEAVE=休假，RESIGNED=离职',
    work_location           VARCHAR(200)    NULL        COMMENT '工作地点',
    reporting_to            VARCHAR(64)     NULL        COMMENT '汇报对象（员工编码）',
    emergency_contact       NVARCHAR(200)   NULL        COMMENT '紧急联系人信息 JSON',
    bank_account            VARCHAR(64)     NULL        COMMENT '银行账号',
    social_insurance_no     VARCHAR(64)     NULL        COMMENT '社保账号',
    housing_fund_no         VARCHAR(64)     NULL        COMMENT '公积金账号',
    tax_id                  VARCHAR(64)     NULL        COMMENT '纳税人识别号',
    base_salary             DECIMAL(12,2)   NULL        COMMENT '基本工资',
    overtime_rate           DECIMAL(5,2)    NULL        COMMENT '加班费率倍率',
    is_main_position        TINYINT         NOT NULL    DEFAULT 1 COMMENT '是否主岗位（一个人可有多岗位身份）',
    sort_order              INT             NOT NULL    DEFAULT 0,
    is_active               TINYINT         NOT NULL    DEFAULT 1,
    created_by              VARCHAR(64)     NULL,
    created_at              DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by              VARCHAR(64)     NULL,
    updated_at              DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_emp_identity (employee_id, identity_type),
    KEY idx_dept_id         (dept_id),
    KEY idx_position_id     (position_id),
    KEY idx_employment_status(employment_status),
    KEY idx_entry_date      (entry_date),
    KEY idx_is_active       (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='员工明细表（多身份记录）';

-- 初始化示例数据（工厂A下的示例员工身份）
-- INSERT INTO mst_employee_detail (id, employee_id, identity_type, dept_id, entry_date, employment_status, is_main_position) VALUES
--     (1, 1, 'WORKER',      101, '2025-01-15', 'ACTIVE', 1),
--     (2, 1, 'SUPERVISOR',  101, '2025-06-01', 'ACTIVE', 0),
--     (3, 2, 'TECHNICIAN',  102, '2024-03-10', 'ACTIVE', 1),
--     (4, 3, 'ENGINEER',    103, '2023-09-01', 'ACTIVE', 1),
--     (5, 4, 'MANAGER',     104, '2022-01-01', 'ACTIVE', 1);
