using APS.Application.Services;
using APS.Domain.Entities;

namespace APS.Api.Controllers;

/// <summary>
/// 工单管理 API
/// </summary>
[ApiController]
[Route("api/v1/work-orders")]
public class WorkOrderController : ControllerBase
{
    private readonly WorkOrderService _woService = new();

    /// <summary>创建工单（草稿）</summary>
    [HttpPost]
    public ActionResult<OrdWorkOrder> Create([FromBody] CreateWorkOrderDto dto)
    {
        var wo = _woService.CreateWorkOrder(dto);
        return CreatedAtAction(nameof(GetById), new { id = wo.Id }, wo);
    }

    /// <summary>根据ID查询工单</summary>
    [HttpGet("{id:long}")]
    public ActionResult<OrdWorkOrder> GetById(long id)
    {
        // TODO: replace with actual repo query
        var wo = new OrdWorkOrder { Id = id, WoNumber = "WO-20260502-0001" };
        if (wo.Id == 0) return NotFound();
        return Ok(wo);
    }

    /// <summary>查询工单列表（分页）</summary>
    [HttpGet]
    public ActionResult<PagedResult<OrdWorkOrder>> GetList(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] string? status = null,
        [FromQuery] long? itemId = null)
    {
        // TODO: replace with actual repo query
        var list = new List<OrdWorkOrder>();
        return Ok(new PagedResult<OrdWorkOrder>(list, page, pageSize, 0));
    }

    /// <summary>发布工单</summary>
    [HttpPost("{id:long}/release")]
    public ActionResult Release(long id)
    {
        var wo = new OrdWorkOrder { Id = id, Status = "DRAFT" };
        _woService.ReleaseWorkOrder(wo);
        return Ok(new { message = "工单已发布", woNumber = wo.WoNumber });
    }

    /// <summary>启动工单</summary>
    [HttpPost("{id:long}/start")]
    public ActionResult Start(long id)
    {
        var wo = new OrdWorkOrder { Id = id, Status = "RELEASED" };
        _woService.StartWorkOrder(wo);
        return Ok(new { message = "工单已启动" });
    }

    /// <summary>完成工单</summary>
    [HttpPost("{id:long}/complete")]
    public ActionResult Complete(long id, [FromBody] CompleteWorkOrderDto dto)
    {
        var wo = new OrdWorkOrder { Id = id };
        _woService.CompleteWorkOrder(wo, dto.CompletedQty);
        return Ok(new { message = "工单已完成", completedQty = dto.CompletedQty });
    }

    /// <summary>取消工单</summary>
    [HttpPost("{id:long}/cancel")]
    public ActionResult Cancel(long id, [FromBody] CancelWorkOrderDto dto)
    {
        return Ok(new { message = "工单已取消", reason = dto.Reason });
    }
}

/// <summary>
/// 排程管理 API
/// </summary>
[ApiController]
[Route("api/v1/schedules")]
public class ScheduleController : ControllerBase
{
    private readonly SchedulingService _schService = new();

    /// <summary>触发排程</summary>
    [HttpPost("run")]
    public ActionResult RunSchedule([FromBody] RunScheduleDto dto)
    {
        var result = _schService.CreateScheduleResult(dto.FactoryId, dto.AlgorithmType ?? "GA");
        return AcceptedAtAction(nameof(GetById), new { id = result.Id }, result);
    }

    /// <summary>获取排程结果</summary>
    [HttpGet("{id:long}")]
    public ActionResult<SchScheduleResult> GetById(long id)
    {
        var result = new SchScheduleResult { Id = id };
        if (result.Id == 0) return NotFound();
        return Ok(result);
    }

    /// <summary>获取排程列表</summary>
    [HttpGet]
    public ActionResult<PagedResult<SchScheduleResult>> GetList(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] long? factoryId = null)
    {
        return Ok(new PagedResult<SchScheduleResult>(new List<SchScheduleResult>(), page, pageSize, 0));
    }

    /// <summary>发布排程结果</summary>
    [HttpPost("{id:long}/publish")]
    public ActionResult Publish(long id)
    {
        var result = new SchScheduleResult { Id = id, Status = "DRAFT" };
        _schService.Publish(result);
        return Ok(new { message = "排程结果已发布" });
    }

    /// <summary>获取甘特图数据</summary>
    [HttpGet("{id:long}/gantt")]
    public ActionResult GetGanttData(long id)
    {
        // TODO: return gantt-formatted data
        return Ok(new { scheduleId = id, operations = new List<object>() });
    }
}

/// <summary>
/// 异常管理 API
/// </summary>
[ApiController]
[Route("api/v1/exceptions")]
public class ExceptionController : ControllerBase
{
    private readonly ExceptionService _excService = new();

    [HttpGet]
    public ActionResult GetList([FromQuery] long? workOrderId = null)
    {
        return Ok(new List<ExcWorkOrderException>());
    }

    [HttpPost("{id:long}/resolve")]
    public ActionResult Resolve(long id, [FromBody] ResolveExceptionDto dto)
    {
        var exc = new ExcWorkOrderException { Id = id };
        _excService.ResolveException(exc, dto.Resolution);
        return Ok(new { message = "异常已处理" });
    }
}

// ===================== 共用 DTO / 类 =====================

public class CompleteWorkOrderDto
{
    public decimal CompletedQty { get; set; }
}

public class CancelWorkOrderDto
{
    public string? Reason { get; set; }
}

public class RunScheduleDto
{
    public long FactoryId { get; set; }
    public string? AlgorithmType { get; set; }
    public long? WorkOrderId { get; set; }
    public DateTime? FromDate { get; set; }
    public DateTime? ToDate { get; set; }
}

public class ResolveExceptionDto
{
    public string Resolution { get; set; } = string.Empty;
}

public class PagedResult<T>
{
    public IList<T> Items { get; }
    public int Page { get; }
    public int PageSize { get; }
    public int TotalCount { get; }
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)PageSize);

    public PagedResult(IList<T> items, int page, int pageSize, int totalCount)
    {
        Items = items;
        Page = page;
        PageSize = pageSize;
        TotalCount = totalCount;
    }
}

[ApiController]
public abstract class ControllerBase : Microsoft.AspNetCore.Mvc.ControllerBase { }
