-- ================================================================
-- SQL #011：mst_worker / mst_worker_skill / mst_shift_assignment（人员、技能、排班）
-- APS开发文档 §2.2.3
-- ================================================================

-- ----------------------------
-- 表：mst_worker（人员主数据）
-- ----------------------------
DROP TABLE IF EXISTS mst_worker;
CREATE TABLE mst_worker (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    worker_code     VARCHAR(20)     NOT NULL                        COMMENT '工号',
    worker_name     NVARCHAR(100)  NOT NULL                        COMMENT '姓名',
    id_card_no      VARCHAR(20)     NULL                             COMMENT '身份证号',
    workshop_id     BIGINT          NULL                             COMMENT '所属车间（外键→mst_workshop.id）',
    workcenter_id   BIGINT          NULL                             COMMENT '所属工作中心（外键→mst_workcenter.id）',
    worker_type     VARCHAR(20)     NOT NULL                        COMMENT '人员类型：DIRECT=直接人工，INDIRECT=间接人工',
    employment_type VARCHAR(20)     NOT NULL                        COMMENT '用工形式：FULL_TIME=正式，PART_TIME=兼职，TEMPORARY=临时',
    join_date       DATE            NOT NULL                        COMMENT '入职日期',
    leave_date      DATE            NULL                             COMMENT '离职日期（NULL表示在职）',
    is_active       TINYINT         NOT NULL    DEFAULT 1          COMMENT '是否在职：0=离职，1=在职',
    status          TINYINT         NOT NULL    DEFAULT 1          COMMENT '状态：0=草稿，1=生效，2=禁用',
    remark          VARCHAR(500)    NULL                             COMMENT '备注',
    created_by      VARCHAR(50)     NOT NULL                        COMMENT '创建人',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by      VARCHAR(50)     NULL                             COMMENT '更新人',
    updated_at      DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted      TINYINT         NOT NULL    DEFAULT 0          COMMENT '逻辑删除：0=未删除，1=已删除',
    version         INT             NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_worker_code (worker_code),
    INDEX idx_worker_workshop (workshop_id),
    INDEX idx_worker_workcenter (workcenter_id),
    INDEX idx_worker_active (is_active, worker_type),
    CONSTRAINT fk_worker_workshop FOREIGN KEY (workshop_id) REFERENCES mst_workshop(id),
    CONSTRAINT fk_worker_workcenter FOREIGN KEY (workcenter_id) REFERENCES mst_workcenter(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='人员主数据表';

-- ----------------------------
-- 表：mst_worker_skill（人员技能矩阵）
-- ----------------------------
DROP TABLE IF EXISTS mst_worker_skill;
CREATE TABLE mst_worker_skill (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    worker_id       BIGINT          NOT NULL                        COMMENT '人员ID（外键→mst_worker.id）',
    skill_id        BIGINT          NOT NULL                        COMMENT '技能ID（外键→mst_skill.id）',
    proficiency     VARCHAR(20)     NOT NULL    DEFAULT 'QUALIFIED' COMMENT '熟练度：TRAINEE=学徒，QUALIFIED=合格，SENIOR=高级，MASTER=大师',
    certified_date  DATE            NOT NULL                        COMMENT '认证日期',
    expiry_date     DATE            NULL                             COMMENT '证书有效期（NULL表示永久有效）',
    is_active       TINYINT         NOT NULL    DEFAULT 1          COMMENT '是否有效：0=失效，1=有效',
    status          TINYINT         NOT NULL    DEFAULT 1          COMMENT '状态：0=草稿，1=生效，2=禁用',
    remark          VARCHAR(500)    NULL                             COMMENT '备注',
    created_by      VARCHAR(50)     NOT NULL                        COMMENT '创建人',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by      VARCHAR(50)     NULL                             COMMENT '更新人',
    updated_at      DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted      TINYINT         NOT NULL    DEFAULT 0          COMMENT '逻辑删除：0=未删除，1=已删除',
    version         INT             NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_worker_skill (worker_id, skill_id),
    INDEX idx_ws_skill (skill_id),
    CONSTRAINT fk_ws_worker FOREIGN KEY (worker_id) REFERENCES mst_worker(id),
    CONSTRAINT fk_ws_skill FOREIGN KEY (skill_id) REFERENCES mst_skill(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='人员技能矩阵表';

-- ----------------------------
-- 表：mst_shift_assignment（人员排班表）
-- ----------------------------
DROP TABLE IF EXISTS mst_shift_assignment;
CREATE TABLE mst_shift_assignment (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    worker_id       BIGINT          NOT NULL                        COMMENT '人员ID（外键→mst_worker.id）',
    shift_id        BIGINT          NOT NULL                        COMMENT '班次ID（外键→mst_shift.id）',
    calendar_id     BIGINT          NOT NULL                        COMMENT '日历ID（外键→mst_calendar.id）',
    shift_date      DATE            NOT NULL                        COMMENT '排班日期',
    status          VARCHAR(20)     NOT NULL    DEFAULT 'SCHEDULED' COMMENT '状态：SCHEDULED=已排班，CONFIRMED=已确认，ABSENT=缺勤，LEAVE=请假',
    check_in_time   DATETIME        NULL                             COMMENT '实际签到时间',
    check_out_time  DATETIME        NULL                             COMMENT '实际签退时间',
    remark          NVARCHAR(200)   NULL                             COMMENT '备注/说明',
    created_by      VARCHAR(50)     NOT NULL                        COMMENT '创建人',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by      VARCHAR(50)     NULL                             COMMENT '更新人',
    updated_at      DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted      TINYINT         NOT NULL    DEFAULT 0          COMMENT '逻辑删除：0=未删除，1=已删除',
    version         INT             NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_worker_shift_date (worker_id, shift_date),
    INDEX idx_sa_shift (shift_id),
    INDEX idx_sa_calendar (calendar_id),
    INDEX idx_sa_date (shift_date),
    INDEX idx_sa_status (status),
    CONSTRAINT fk_sa_worker FOREIGN KEY (worker_id) REFERENCES mst_worker(id),
    CONSTRAINT fk_sa_shift FOREIGN KEY (shift_id) REFERENCES mst_shift(id),
    CONSTRAINT fk_sa_calendar FOREIGN KEY (calendar_id) REFERENCES mst_calendar(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='人员排班表';
