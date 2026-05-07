-- ================================================================
-- 037_mst_department.sql
-- 组织架构：部门主数据
-- ================================================================

-- 部门表（工厂组织架构树）
CREATE TABLE mst_department (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    dept_code           VARCHAR(64)     NOT NULL    COMMENT '部门编码',
    dept_name           NVARCHAR(200)  NOT NULL    COMMENT '部门名称',
    dept_name_en        VARCHAR(200)    NULL        COMMENT '部门英文名',
    parent_id           BIGINT          NULL        COMMENT '上级部门ID（NULL=根部门）',
    factory_id          BIGINT          NULL        COMMENT '所属工厂ID',
    workshop_id         BIGINT          NULL        COMMENT '所属车间ID',
    dept_level          INT             NOT NULL    DEFAULT 1 COMMENT '部门层级（1=工厂级，2=车间级，3=产线级）',
    dept_type           TINYINT         NOT NULL    DEFAULT 1 COMMENT '部门类型：1=制造，2=仓库，3=品质，4=工程，5=管理',
    manager_user_id     VARCHAR(64)     NULL        COMMENT '部门负责人ID',
    cost_center_id      BIGINT          NULL        COMMENT '所属成本中心ID',
    sort_order          INT             NOT NULL    DEFAULT 0 COMMENT '排序号',
    is_virtual          TINYINT         NOT NULL    DEFAULT 0 COMMENT '是否虚拟部门（不参与排程）',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_dept_code (dept_code),
    KEY idx_parent_id   (parent_id),
    KEY idx_factory_id  (factory_id),
    KEY idx_workshop_id (workshop_id),
    KEY idx_manager_user_id (manager_user_id),
    KEY idx_cost_center_id (cost_center_id),
    KEY idx_is_active  (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='部门主数据表';

-- 职位/岗位表
CREATE TABLE mst_position (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    position_code       VARCHAR(64)     NOT NULL    COMMENT '职位编码',
    position_name       NVARCHAR(200)  NOT NULL    COMMENT '职位名称',
    dept_id             BIGINT          NOT NULL    COMMENT '所属部门ID',
    position_level      INT             NULL        COMMENT '职级（如：1=基层，2=中层，3=高层）',
    is_leader           TINYINT         NOT NULL    DEFAULT 0 COMMENT '是否管理岗',
    skill_required      JSON            NULL        COMMENT '任职资格/技能要求 JSON',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_position_code (position_code),
    KEY idx_dept_id    (dept_id),
    KEY idx_is_active  (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='职位/岗位主数据表';
