using Xunit;
using APS.Application.Services;
using APS.Domain.Entities;
using APS.Domain.Enums;

namespace APS.Tests.Services;

public class WorkOrderServiceTests
{
    private readonly WorkOrderService _svc = new();

    [Fact]
    public void CreateWorkOrder_ValidDto_ReturnsWoWithCode()
    {
        var dto = new CreateWorkOrderDto
        {
            ItemId = 1,
            PlanQty = 100,
            WoType = "NORMAL",
            Priority = 2
        };

        var wo = _svc.CreateWorkOrder(dto);

        Assert.NotNull(wo);
        Assert.NotEmpty(wo.WoNumber);
        Assert.StartsWith("WO-", wo.WoNumber);
        Assert.Equal(1, wo.ItemId);
        Assert.Equal(100, wo.PlanQty);
        Assert.Equal("DRAFT", wo.Status);
        Assert.Equal("NORMAL", wo.WoType);
    }

    [Fact]
    public void CreateWorkOrder_RepairType_PrefixedRP()
    {
        var dto = new CreateWorkOrderDto { ItemId = 2, PlanQty = 50, WoType = "REPAIR" };
        var wo = _svc.CreateWorkOrder(dto);
        Assert.StartsWith("RP-", wo.WoNumber);
    }

    [Fact]
    public void ReleaseWorkOrder_DraftWo_Succeeds()
    {
        var wo = CreateDraftWo();
        _svc.ReleaseWorkOrder(wo);
        Assert.Equal("RELEASED", wo.Status);
    }

    [Fact]
    public void ReleaseWorkOrder_ReleasedWo_Throws()
    {
        var wo = CreateReleasedWo();
        var ex = Assert.Throws<InvalidOperationException>(() => _svc.ReleaseWorkOrder(wo));
        Assert.Contains("RELEASED", ex.Message);
    }

    [Fact]
    public void StartWorkOrder_ReleasedWo_Succeeds()
    {
        var wo = CreateReleasedWo();
        _svc.StartWorkOrder(wo);
        Assert.Equal("IN_PROGRESS", wo.Status);
        Assert.NotNull(wo.ActualStartDate);
    }

    [Fact]
    public void StartWorkOrder_DraftWo_Throws()
    {
        var wo = CreateDraftWo();
        var ex = Assert.Throws<InvalidOperationException>(() => _svc.StartWorkOrder(wo));
        Assert.Contains("DRAFT", ex.Message);
    }

    [Fact]
    public void CompleteWorkOrder_ValidQty_Completed()
    {
        var wo = CreateInProgressWo();
        _svc.CompleteWorkOrder(wo, completedQty: 100);
        Assert.Equal("COMPLETED", wo.Status);
        Assert.Equal(100, wo.CompletedQty);
        Assert.NotNull(wo.ActualEndDate);
    }

    private static OrdWorkOrder CreateDraftWo() => new() { Id = 1, Status = "DRAFT", WoNumber = "WO-TEST-001" };
    private static OrdWorkOrder CreateReleasedWo() => new() { Id = 2, Status = "RELEASED", WoNumber = "WO-TEST-002" };
    private static OrdWorkOrder CreateInProgressWo() => new() { Id = 3, Status = "IN_PROGRESS", WoNumber = "WO-TEST-003" };
}

public class SchedulingServiceTests
{
    private readonly SchedulingService _svc = new();

    [Fact]
    public void CreateScheduleResult_ValidFactory_ReturnsResult()
    {
        var result = _svc.CreateScheduleResult(factoryId: 1, algorithmType: "GA");

        Assert.NotNull(result);
        Assert.NotEmpty(result.ScheduleCode);
        Assert.StartsWith("SCH-", result.ScheduleCode);
        Assert.Equal(1, result.FactoryId);
        Assert.Equal("DRAFT", result.Status);
        Assert.Equal("GA", result.AlgorithmType);
        Assert.Equal(1, result.VersionNo);
    }

    [Fact]
    public void Publish_DraftResult_Publishes()
    {
        var result = _svc.CreateScheduleResult(factoryId: 1, algorithmType: "GA");
        _svc.Publish(result);

        Assert.Equal("PUBLISHED", result.Status);
        Assert.NotNull(result.PublishedAt);
        Assert.NotNull(result.PublishedBy);
    }

    [Fact]
    public void Publish_PublishedResult_Throws()
    {
        var result = _svc.CreateScheduleResult(factoryId: 1, algorithmType: "GA");
        _svc.Publish(result);
        var ex = Assert.Throws<InvalidOperationException>(() => _svc.Publish(result));
        Assert.Contains("草稿", ex.Message);
    }
}

public class KittingServiceTests
{
    private readonly KittingService _svc = new();

    [Fact]
    public void CreateKitting_ValidParams_ReturnsKitting()
    {
        var wo = new OrdWorkOrder { Id = 10 };
        var schedule = new SchScheduleResult { Id = 20 };

        var kitting = _svc.CreateKitting(wo, schedule);

        Assert.NotNull(kitting);
        Assert.NotEmpty(kitting.KittingNo);
        Assert.StartsWith("KIT-", kitting.KittingNo);
        Assert.Equal(10, kitting.WorkOrderId);
        Assert.Equal(20, kitting.ScheduleResultId);
        Assert.Equal("PENDING", kitting.Status);
    }

    [Fact]
    public void CheckKittingComplete_AllPicked_ReturnsTrue()
    {
        var kitting = new InvWoKitting
        {
            KittingItems = new List<InvKittingItem>
            {
                new() { Id = 1, Status = "PICKED" },
                new() { Id = 2, Status = "PICKED" }
            }
        };
        Assert.True(_svc.CheckKittingComplete(kitting));
    }

    [Fact]
    public void CheckKittingComplete_SomePending_ReturnsFalse()
    {
        var kitting = new InvWoKitting
        {
            KittingItems = new List<InvKittingItem>
            {
                new() { Id = 1, Status = "PICKED" },
                new() { Id = 2, Status = "PENDING" }
            }
        };
        Assert.False(_svc.CheckKittingComplete(kitting));
    }
}

public class ExceptionServiceTests
{
    private readonly ExceptionService _svc = new();

    [Fact]
    public void RaiseException_ValidParams_ReturnsException()
    {
        var wo = new OrdWorkOrder { Id = 5, WoNumber = "WO-TEST-005" };
        var exc = _svc.RaiseException(wo, "DELAY", "交期延误超过3天", "WARNING");

        Assert.NotNull(exc);
        Assert.NotEmpty(exc.ExceptionCode);
        Assert.StartsWith("EXC-", exc.ExceptionCode);
        Assert.Equal(5, exc.WorkOrderId);
        Assert.Equal("DELAY", exc.ExceptionType);
        Assert.Equal("WARNING", exc.Level);
        Assert.Equal("OPEN", exc.Status);
    }

    [Fact]
    public void ResolveException_ValidResolution_Resolved()
    {
        var exc = new ExcWorkOrderException
        {
            Id = 1,
            Status = "OPEN",
            ExceptionCode = "EXC-TEST-001"
        };

        _svc.ResolveException(exc, "已调整工单优先级");

        Assert.Equal("RESOLVED", exc.Status);
        Assert.NotNull(exc.ResolvedAt);
        Assert.Equal("已调整工单优先级", exc.Resolution);
    }
}