using Microsoft.EntityFrameworkCore;
using APS.Application.Services;
using APS.Infrastructure.Data;
using APS.Infrastructure.Repositories;
using APS.Worker.Services;

var builder = WebApplication.CreateBuilder(args);

// ===== EF Core DbContext =====
builder.Services.AddDbContext<ApsDbContext>(options =>
    options.UseMySql(
        builder.Configuration.GetConnectionString("DefaultDb")
            ?? throw new InvalidOperationException("Missing DefaultDb connection string"),
        ServerVersion.AutoDetect("8.0"),
        mysql => mysql.EnableRetryOnFailure(3)
    )
    // 切换 PostgreSQL：
    // options.UseNpgsql(builder.Configuration.GetConnectionString("PostgresDb"));
);

// ===== Repository DI =====
builder.Services.AddScoped<IWorkOrderRepository, WorkOrderRepository>();
builder.Services.AddScoped<IScheduleRepository, ScheduleRepository>();
builder.Services.AddScoped<IStockRepository, StockRepository>();

// ===== Application Services DI =====
builder.Services.AddScoped<WorkOrderService>();
builder.Services.AddScoped<SchedulingService>();
builder.Services.AddScoped<KittingService>();
builder.Services.AddScoped<ExceptionService>();

// ===== Worker（后台排程服务）=====
builder.Services.AddHostedService<SchedulingWorker>();

// ===== Controllers =====
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// ===== Swagger（开发时）=====
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();
app.MapControllers();

// ===== 数据库自动迁移（生产环境建议注释）=====
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<ApsDbContext>();
    db.Database.EnsureCreated();
}

app.Run();