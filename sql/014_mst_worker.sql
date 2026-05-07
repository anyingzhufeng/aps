-- ================================================================
-- APS 生产排程系统 - 主数据：员工
-- 文件：014_mst_worker.sql
-- 说明：员工主数据表，包含人员基本信息、技能分类、用工类型
-- ================================================================

-- ----------------------------
-- 表：mst_worker（员工主数据）
-- ----------------------------
CREATE TABLE IF NOT EXISTS mst_worker (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    factory_id      BIGINT          NULL                        COMMENT '所属工厂ID',
    workshop_id     BIGINT          NULL                        COMMENT '所属车间ID',
    worker_code     VARCHAR(20)      NOT NULL                    COMMENT '员工工号（唯一）',
    worker_name     VARCHAR(100)     NOT NULL                    COMMENT '员工姓名',
    id_card_no      VARCHAR(20)      NULL                        COMMENT '身份证号码',
    worker_type     VARCHAR(20)      NOT NULL    DEFAULT 'DIRECT' COMMENT '人员类型：DIRECT-直接人工/INDIRECT-间接人工',
    employment_type VARCHAR(20)      NOT NULL    DEFAULT 'FULL_TIME' COMMENT '用工类型：FULL_TIME-全职/PART_TIME-兼职/TEMPORARY-临时',
    join_date       DATE            NOT NULL                    COMMENT '入职日期',
    leave_date      DATE            NULL                        COMMENT '离职日期（NULL表示在职）',
    gender          VARCHAR(10)     NULL                        COMMENT '性别：M/F',
    birth_date      DATE            NULL                        COMMENT '出生日期',
    phone           VARCHAR(20)     NULL                        COMMENT '联系电话',
    email           VARCHAR(100)    NULL                        COMMENT '电子邮箱',
    department      VARCHAR(50)     NULL                        COMMENT '所属部门',
    position        VARCHAR(50)     NULL                        COMMENT '岗位/职位',
    is_active       TINYINT(1)      NOT NULL    DEFAULT 1         COMMENT '是否在职：1-是，0-否',
    is_deleted      TINYINT(1)      NOT NULL    DEFAULT 0         COMMENT '软删除标记：1-删除，0-正常',
    version         INT              NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',
    created_at      DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '创建人',
    updated_by      VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_worker_code (worker_code),
    KEY idx_worker_workshop (workshop_id),
    KEY idx_worker_factory (factory_id),
    KEY idx_worker_type (worker_type),
    KEY idx_worker_active (is_active, is_deleted),
    CONSTRAINT fk_worker_workshop FOREIGN KEY (workshop_id) REFERENCES mst_workshop(id),
    CONSTRAINT fk_worker_factory FOREIGN KEY (factory_id) REFERENCES mst_factory(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='员工主数据表';

-- ----------------------------
-- 示例数据
-- ----------------------------
INSERT INTO mst_worker (factory_id, workshop_id, worker_code, worker_name, worker_type, employment_type, join_date, phone, department, position) VALUES
(1, 1, 'W001', '张三', 'DIRECT', 'FULL_TIME', '2020-03-15', '13800001001', '生产部', '操作工'),
(1, 1, 'W002', '李四', 'DIRECT', 'FULL_TIME', '2020-06-01', '13800001002', '生产部', '操作工'),
(1, 2, 'W003', '王五', 'DIRECT', 'PART_TIME', '2021-01-10', '13800001003', '生产部', '操作工'),
(1, NULL, 'W004', '赵六', 'INDIRECT', 'FULL_TIME', '2019-08-20', '13800001004', '技术部', '技术员');
