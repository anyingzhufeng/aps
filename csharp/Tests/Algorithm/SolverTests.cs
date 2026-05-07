using Xunit;
using APS.Algorithm;

namespace APS.Tests.Algorithm;

public class SolverTests
{
    private ScheduleInput SampleInput() => new(
        FactoryId: 1,
        Operations: new List<OperationInput>
        {
            new(1, 1, null, 10, 0.5m, 1m, 0m,
                DateTime.Today, DateTime.Today.AddDays(7), 1),
            new(2, 1, null, 20, 0.3m, 1m, 0m,
                DateTime.Today, DateTime.Today.AddDays(5), 2),
            new(3, 2, null, 15, 0.4m, 0.5m, 0m,
                DateTime.Today.AddDays(1), DateTime.Today.AddDays(10), 1),
        },
        WorkCenters: new List<ResourceInput>
        {
            new(1, "WORKCENTER", DateTime.Today, DateTime.Today.AddDays(14), 480)
        },
        Machines: new List<ResourceInput>(),
        PlanningHorizonStart: DateTime.Today,
        PlanningHorizonEnd: DateTime.Today.AddDays(14)
    );

    [Fact]
    public void GeneticAlgorithmSolver_Solve_ReturnsSuccess()
    {
        var solver = new GeneticAlgorithmSolver();
        var output = solver.Solve(SampleInput());

        Assert.True(output.Success);
        Assert.NotEmpty(output.Operations);
        Assert.Equal(3, output.Operations.Count);
        Assert.True(output.SolveTimeSeconds > 0);
        Assert.Contains("GA", output.Message);
    }

    [Fact]
    public void GeneticAlgorithmSolver_OperationsSortedByPriority()
    {
        var solver = new GeneticAlgorithmSolver();
        var input = SampleInput();
        var output = solver.Solve(input);

        // 优先级1的工序应在优先级2之前调度
        var op1 = output.Operations.First(o => o.WoOperationId == 1);
        var op2 = output.Operations.First(o => o.WoOperationId == 2);
        Assert.True(op1.ScheduledStartTime <= op2.ScheduledStartTime);
    }

    [Fact]
    public void HeuristicSolver_Solve_ReturnsSuccess()
    {
        var solver = new HeuristicSolver();
        var output = solver.Solve(SampleInput());

        Assert.True(output.Success);
        Assert.Equal(3, output.Operations.Count);
        Assert.Contains("启发式", output.Message);
    }

    [Fact]
    public void HeuristicSolver_OperationsAllScheduled()
    {
        var solver = new HeuristicSolver();
        var output = solver.Solve(SampleInput());
        Assert.Equal(output.Operations.Count, SampleInput().Operations.Count);
    }

    [Fact]
    public void CpSatSolver_Solve_ReturnsSuccess()
    {
        var solver = new CpSatSolver();
        var output = solver.Solve(SampleInput());

        Assert.True(output.Success);
        Assert.Equal(3, output.Operations.Count);
        Assert.Contains("CP-SAT", output.Message);
    }

    [Fact]
    public void MilpSolver_Solve_ReturnsSuccess()
    {
        var solver = new MilpSolver();
        var output = solver.Solve(SampleInput());

        Assert.True(output.Success);
        Assert.Equal(3, output.Operations.Count);
        Assert.Contains("MILP", output.Message);
    }

    [Fact]
    public void SolverFactory_CreateGA_ReturnsGeneticAlgorithmSolver()
    {
        var solver = SolverFactory.Create("GA");
        Assert.IsType<GeneticAlgorithmSolver>(solver);
        Assert.Equal("GA", solver.AlgorithmType);
    }

    [Fact]
    public void SolverFactory_CreateUnknown_DefaultsToGA()
    {
        var solver = SolverFactory.Create("UNKNOWN");
        Assert.IsType<GeneticAlgorithmSolver>(solver);
    }

    [Fact]
    public void SolverFactory_AvailableSolvers_ContainsAllFour()
    {
        var available = SolverFactory.AvailableSolvers;
        Assert.Contains("GA", available);
        Assert.Contains("CP_SAT", available);
        Assert.Contains("MILP", available);
        Assert.Contains("HEURISTIC", available);
    }
}