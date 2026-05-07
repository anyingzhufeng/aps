-- ================================================================
-- APS 生产排程系统 - 主数据：员工-技能关联
-- 文件：015_mst_worker_skill.sql
-- 说明：员工技能矩阵，记录每位员工具备的技能及其等级
-- ================================================================

-- ----------------------------
-- 表：mst_worker_skill（员工-技能关联）
-- ----------------------------
CREATE TABLE IF NOT EXISTS mst_worker_skill (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    worker_id       BIGINT          NOT NULL                    COMMENT '员工ID（外键→mst_worker.id）',
    skill_id        BIGINT          NOT NULL                    COMMENT '技能ID（外键→mst_skill.id）',
    skill_level     VARCHAR(20)     NOT NULL    DEFAULT 'LEVEL_1' COMMENT '技能等级：LEVEL_1-初级/LEVEL_2-中级/LEVEL_3-高级/LEVEL_4-技师',
    certified_date  DATE            NOT NULL                    COMMENT '认证日期',
    expiry_date     DATE            NULL                        COMMENT '证书有效期（NULL表示永久）',
    proficiency_pct DECIMAL(5,2)    NULL                        COMMENT '熟练度百分比（0-100），用于排程优先级',
    is_active       TINYINT(1)      NOT NULL    DEFAULT 1       COMMENT '是否有效：1-是，0-否',
    is_deleted      TINYINT(1)      NOT NULL    DEFAULT 0       COMMENT '软删除标记',
    version         INT              NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',
    created_at      DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '创建人',
    updated_by      VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_worker_skill (worker_id, skill_id),
    KEY idx_skill_worker (skill_id, worker_id),
    KEY idx_worker_active (worker_id, is_active, is_deleted),
    CONSTRAINT fk_ws_worker FOREIGN KEY (worker_id) REFERENCES mst_worker(id),
    CONSTRAINT fk_ws_skill FOREIGN KEY (skill_id) REFERENCES mst_skill(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='员工-技能关联表';

-- ----------------------------
-- 示例数据
-- ----------------------------
INSERT INTO mst_worker_skill (worker_id, skill_id, skill_level, certified_date, proficiency_pct) VALUES
(1, 1, 'LEVEL_2', '2020-04-01', 85.00),
(1, 2, 'LEVEL_1', '2020-05-15', 70.00),
(2, 1, 'LEVEL_3', '2020-06-01', 95.00),
(2, 3, 'LEVEL_2', '2020-07-20', 80.00),
(3, 2, 'LEVEL_1', '2021-02-01', 60.00);