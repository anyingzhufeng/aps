-- ================================================================
-- APS 生产排程系统 - 排程执行日志
-- 文件：043_sch_schedule_log.sql
-- 说明：排程执行过程日志，记录每次排程的中间状态
-- 参考：APS开发文档 §2.3.3 §8.1 表清单
-- ================================================================

-- ----------------------------
-- 表：sch_schedule_log（排程执行日志）
-- ----------------------------
DROP TABLE IF EXISTS sch_schedule_log;
CREATE TABLE sch_schedule_log (
    id                  BIGINT          NOT NULL AUTO_INCREMENT,
    schedule_id        BIGINT          NOT NULL,                -- 关联 sch_schedule_result.id
    log_level          VARCHAR(20)     NOT NULL DEFAULT 'INFO', -- DEBUG / INFO / WARN / ERROR
    log_type           VARCHAR(50)     NOT NULL,                -- INIT / LOAD_DATA / SOLVE / POST_PROCESS / COMPLETE / FAIL
    step_code          VARCHAR(50)     DEFAULT NULL,           -- 子步骤编码
    step_name          NVARCHAR(200)   DEFAULT NULL,           -- 子步骤名称
    message            NVARCHAR(2000)  DEFAULT NULL,           -- 日志内容
    detail             JSON            DEFAULT NULL,            -- 详细数据（JSON）
    elapsed_ms         INT             DEFAULT NULL,           -- 本步骤耗时（毫秒）
    iteration          INT             DEFAULT NULL,           -- 迭代次数（遗传算法用）
    record_count       INT             DEFAULT NULL,           -- 本步骤处理记录数
    created_at         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_schedule_id (schedule_id),
    INDEX idx_log_level (log_level),
    INDEX idx_log_type (log_type),
    INDEX idx_created_at (created_at),
    CONSTRAINT fk_schedule_log_schedule FOREIGN KEY (schedule_id) REFERENCES sch_schedule_result(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
