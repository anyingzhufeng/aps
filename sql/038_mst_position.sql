-- ================================================================
-- 表：mst_position（职位/岗位主数据）
-- 序号：038
-- 说明：职位/岗位主数据，定义组织架构中的岗位信息
-- ================================================================

CREATE TABLE mst_position (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    position_code       VARCHAR(64)     NOT NULL    COMMENT '职位编码',
    position_name       NVARCHAR(200)  NOT NULL    COMMENT '职位名称',
    position_name_en    VARCHAR(200)    NULL        COMMENT '职位英文名',
    dept_id             BIGINT          NULL        COMMENT '所属部门ID',
    parent_id           BIGINT          NULL        COMMENT '上级职位ID',
    position_level      INT             NULL        COMMENT '职级（1=基层，2=中层，3=高层）',
    is_leader           TINYINT         NOT NULL    DEFAULT 0 COMMENT '是否管理岗（1=是，0=否）',
    skill_required      JSON            NULL        COMMENT '任职资格/技能要求 JSON',
    job_description      TEXT            NULL        COMMENT '岗位职责描述',
    min_salary           DECIMAL(12,2)   NULL        COMMENT '最低薪资',
    max_salary           DECIMAL(12,2)   NULL        COMMENT '最高薪资',
    headcount_plan      INT             NOT NULL    DEFAULT 0 COMMENT '编制人数',
    headcount_actual    INT             NOT NULL    DEFAULT 0 COMMENT '实有人数',
    is_active           TINYINT         NOT NULL    DEFAULT 1 COMMENT '是否有效（1=有效，0=无效）',
    sort_order          INT             NOT NULL    DEFAULT 0 COMMENT '排序号',
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_position_code (position_code),
    KEY idx_dept_id     (dept_id),
    KEY idx_parent_id   (parent_id),
    KEY idx_is_leader   (is_leader),
    KEY idx_is_active   (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='职位/岗位主数据表';

-- 初始数据示例
INSERT INTO mst_position (id, position_code, position_name, dept_id, position_level, is_leader, is_active, sort_order) VALUES
(1, 'POS-001', '车间主任', 1, 2, 1, 1, 1),
(2, 'POS-002', '班组长', 1, 1, 1, 1, 2),
(3, 'POS-003', '操作工', 1, 1, 0, 1, 10),
(4, 'POS-004', '设备工程师', 1, 1, 0, 1, 3),
(5, 'POS-005', '质量工程师', 1, 1, 0, 1, 3),
(6, 'POS-006', '生产计划员', 1, 1, 0, 1, 3),
(7, 'POS-007', '仓库管理员', 1, 1, 0, 1, 3);
