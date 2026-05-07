-- ================================================================
-- APS 生产排程系统 - 主数据：设备-技能关联
-- 文件：023_mst_machine_skill.sql
-- 说明：记录每台设备具备的技能及其熟练度等级
-- ================================================================

-- ----------------------------
-- 表：mst_machine_skill（设备-技能关联）
-- ----------------------------
CREATE TABLE IF NOT EXISTS mst_machine_skill (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    machine_id      BIGINT          NOT NULL                    COMMENT '设备ID',
    skill_id        BIGINT          NOT NULL                    COMMENT '技能ID',
    proficiency     VARCHAR(10)     NOT NULL    DEFAULT 'QUALIFIED' COMMENT '熟练度：QUALIFIED-合格/TRAINED-培训中/MASTER-大师级',
    certified_date  DATE            NOT NULL                    COMMENT '认证日期',
    expiry_date     DATE            NULL                        COMMENT '证书有效期（NULL表示永久）',
    is_active       TINYINT(1)      NOT NULL    DEFAULT 1         COMMENT '是否有效：1-是，0-否',
    is_deleted      TINYINT(1)      NOT NULL    DEFAULT 0         COMMENT '软删除标记：1-删除，0-正常',
    version         INT             NOT NULL    DEFAULT 0         COMMENT '乐观锁版本号',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(100)    NOT NULL    DEFAULT 'system' COMMENT '创建人',
    updated_by      VARCHAR(100)    NOT NULL    DEFAULT 'system' COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_machine_skill (machine_id, skill_id),
    KEY idx_skill (skill_id),
    KEY idx_machine_active (machine_id, is_active, is_deleted),
    CONSTRAINT fk_ms_machine FOREIGN KEY (machine_id) REFERENCES mst_machine(id) ON DELETE CASCADE,
    CONSTRAINT fk_ms_skill FOREIGN KEY (skill_id) REFERENCES mst_skill(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备-技能关联表';

-- ----------------------------
-- 示例数据
-- ----------------------------
INSERT INTO mst_machine_skill (machine_id, skill_id, proficiency, certified_date) VALUES
-- 设备1（SMTC-001）具备技能
(1, 1, 'MASTER',   '2021-03-01'),
(1, 3, 'QUALIFIED', '2021-06-15'),
-- 设备2（SMTC-002）具备技能
(2, 1, 'QUALIFIED', '2021-03-01'),
(2, 2, 'QUALIFIED', '2021-07-01'),
(2, 3, 'TRAINED',   '2022-01-10'),
-- 设备3（AOI-001）具备技能
(3, 4, 'MASTER',     '2020-11-01'),
(3, 5, 'QUALIFIED',  '2021-02-01');
