-- ================================================================
-- APS 生产排程系统 - 主数据：工厂
-- 文件：001_mst_factory.sql
-- 说明：工厂/生产基地主数据表
-- ================================================================

-- ----------------------------
-- 表：mst_factory（工厂主数据）
-- ----------------------------
CREATE TABLE IF NOT EXISTS mst_factory (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    factory_code    VARCHAR(50)     NOT NULL                    COMMENT '工厂代码',
    factory_name    VARCHAR(200)    NOT NULL                    COMMENT '工厂名称',
    factory_type    VARCHAR(50)     NOT NULL                    COMMENT '工厂类型：ELECTRONIC-电子组装/MACHINING-机加工/BATCH-批次加工',
    region          VARCHAR(100)                     DEFAULT NULL COMMENT '所属地区',
    address         VARCHAR(500)                     DEFAULT NULL COMMENT '详细地址',
    contact_name    VARCHAR(100)                     DEFAULT NULL COMMENT '联系人',
    contact_phone   VARCHAR(50)                      DEFAULT NULL COMMENT '联系电话',
    contact_email   VARCHAR(100)                     DEFAULT NULL COMMENT '联系邮箱',
    is_active       TINYINT(1)       NOT NULL    DEFAULT 1       COMMENT '是否启用：1-是，0-否',
    is_deleted      TINYINT(1)       NOT NULL    DEFAULT 0       COMMENT '软删除标记',
    version         INT              NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',
    created_at      DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '创建人',
    updated_by      VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_factory_code (factory_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工厂主数据表';
