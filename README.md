# APS 高级计划排程系统

制造业 MES 核心系统，支持遗传算法（GA）、约束规划（CP-SAT）、混合整数规划（MILP）三种排程算法。

## 技术栈

| 层级 | 技术 |
|------|------|
| 前端 | Vue 3 + TypeScript + Vite + Pinia + Vue Router |
| 后端 | .NET 8 + C# + ASP.NET Core |
| ORM | Entity Framework Core 8 |
| 数据库 | MySQL 8 / PostgreSQL 14 |
| 算法 | 遗传算法 / Google OR-Tools CP-SAT / MILP |
| 部署 | Docker Compose |

## 功能模块

- **工单管理**：CRUD + 状态流转（草稿→发布→生产→完工）
- **排程引擎**：GA / CP-SAT / MILP / 启发式 4种算法
- **甘特图**：排程结果可视化
- **库存管理**：物料批次 + 可用量 + 调整
- **齐套检查**：工单开工前物料齐套验证
- **异常管理**：工单异常上报 → 确认 → 解决
- **后台 Worker**：定时扫描待排工单，自动触发排程

## 快速启动

```bash
# 后端
cd csharp && dotnet restore && dotnet run --project APS.Api

# 前端
cd frontend && npm install && npm run dev

# Docker 完整环境
docker-compose up -d
```

## API 文档

启动后访问：http://localhost:5000/swagger

## 目录结构

```
code/
├── csharp/          .NET 8 后端（DDD 分层）
│   ├── Domain/      实体、枚举、值对象
│   ├── Application/ 应用服务
│   ├── Api/         控制器 + DI 配置
│   ├── Algorithm/   排程求解器
│   ├── Infrastructure/ EF Core + Repositories
│   └── Worker/      后台服务
├── frontend/        Vue 3 前端
│   └── src/
│       ├── views/   页面组件
│       ├── api/     axios 封装
│       └── router/  路由配置
├── sql/             建表脚本（按序号执行）
└── docker-compose.yml
```

## 算法说明

| 算法 | 适用场景 | 速度 |
|------|---------|------|
| GA（遗传算法） | 一般排程，<100工序 | 1-10秒 |
| CP-SAT | 复杂约束，>100工序 | 10-60秒 |
| MILP | 最优解要求高 | 分钟级 |
| HEURISTIC | 快速原型验证 | 毫秒级 |