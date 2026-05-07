namespace APS.Algorithm;

/// <summary>
/// 排程引擎接口
/// </summary>
public interface ISchedulingSolver
{
    /// <summary>算法类型：GA / CP_SAT / MILP / HEURISTIC</summary>
    string AlgorithmType { get; }

    /// <summary>执行排程求解</summary>
    ScheduleOutput Solve(ScheduleInput input);
}

public record ScheduleInput(
    long FactoryId,
    IReadOnlyList<OperationInput> Operations,
    IReadOnlyList<ResourceInput> WorkCenters,
    IReadOnlyList<ResourceInput> Machines,
    DateTime PlanningHorizonStart,
    DateTime PlanningHorizonEnd,
    IReadOnlyDictionary<string, string>? Parameters = null
);

public record OperationInput(
    long WoOperationId,
    long WorkCenterId,
    long? PreferredMachineId,
    decimal PlanQty,
    decimal StdHoursPerUnit,
    decimal SetupHours,
    decimal WaitHours,
    DateTime? EarliestStartTime,
    DateTime? LatestEndTime,
    int Priority
);

public record ResourceInput(
    long ResourceId,
    string ResourceType,
    DateTime AvailableFrom,
    DateTime AvailableTo,
    decimal AvailableHours
);

public record ScheduleOutput(
    bool Success,
    string Message,
    double SolveTimeSeconds,
    IReadOnlyList<OperationOutput> Operations,
    IReadOnlyDictionary<string, object>? Metrics = null
);

public record OperationOutput(
    long WoOperationId,
    long WorkCenterId,
    long? MachineId,
    DateTime ScheduledStartTime,
    DateTime ScheduledEndTime,
    string Status
);

/// <summary>
/// 遗传算法（GA）求解器实现
/// </summary>
public class GeneticAlgorithmSolver : ISchedulingSolver
{
    public string AlgorithmType => "GA";

    public ScheduleOutput Solve(ScheduleInput input)
    {
        var startTime = DateTime.Now;
        var random = new Random();
        int populationSize = 100;
        int maxGenerations = 200;
        double crossoverRate = 0.8;
        double mutationRate = 0.1;
        int eliteCount = 10;

        // 初始化种群
        var population = InitializePopulation(input, populationSize, random);

        for (int gen = 0; gen < maxGenerations; gen++)
        {
            // 评估适应度
            var fitness = population.Select(c => EvaluateFitness(c, input)).ToArray();

            // 精英保留
            var elite = population
                .Select((chromosome, idx) => new { Chromosome = chromosome, Fitness = fitness[idx] })
                .OrderByDescending(x => x.Fitness)
                .Take(eliteCount)
                .Select(x => x.Chromosome)
                .ToList();

            // 选择、交叉、变异
            var newPopulation = new List<Chromosome>(elite);
            while (newPopulation.Count < populationSize)
            {
                var parent1 = SelectParent(population, fitness, random);
                var parent2 = SelectParent(population, fitness, random);

                Chromosome child1, child2;
                if (random.NextDouble() < crossoverRate)
                    (child1, child2) = Crossover(parent1, parent2, random);
                else
                {
                    child1 = parent1; child2 = parent2;
                }

                if (random.NextDouble() < mutationRate)
                    Mutate(child1, input, random);
                if (random.NextDouble() < mutationRate)
                    Mutate(child2, input, random);

                newPopulation.Add(child1);
                if (newPopulation.Count < populationSize)
                    newPopulation.Add(child2);
            }

            population = newPopulation;
        }

        // 返回最优解
        var best = population
            .Select((c, idx) => new { Chromosome = c, Fitness = EvaluateFitness(c, input) })
            .OrderByDescending(x => x.Fitness)
            .First();

        var operations = MapToOutput(best.Chromosome, input);
        var solveTime = (DateTime.Now - startTime).TotalSeconds;

        return new ScheduleOutput(true, $"GA求解完成，第{input.Operations.Count}个工序", solveTime, operations);
    }

    private List<Chromosome> InitializePopulation(ScheduleInput input, int size, Random random)
    {
        var pop = new List<Chromosome>();
        for (int i = 0; i < size; i++)
        {
            var genes = input.Operations
                .OrderBy(_ => random.Next())
                .Select(op => new Gene
                {
                    WoOperationId = op.WoOperationId,
                    AssignedMachineId = op.PreferredMachineId ?? 0,
                    StartTime = op.EarliestStartTime ?? input.PlanningHorizonStart
                })
                .ToList();
            pop.Add(new Chromosome { Genes = genes });
        }
        return pop;
    }

    private double EvaluateFitness(Chromosome chromosome, ScheduleInput input)
    {
        // 简化适应度：优先级越高（数字越小）+ 延迟越少 → 分数越高
        double score = 1000;
        foreach (var gene in chromosome.Genes)
        {
            var op = input.Operations.First(o => o.WoOperationId == gene.WoOperationId);
            score -= gene.StartTime > (op.LatestEndTime ?? gene.StartTime.AddHours(1))
                ? (gene.StartTime - (op.LatestEndTime ?? gene.StartTime)).TotalHours * 10 : 0;
            score -= op.Priority * 0.1;
        }
        return Math.Max(score, 0.01);
    }

    private Chromosome SelectParent(List<Chromosome> population, double[] fitness, Random random)
    {
        // 轮盘赌选择
        var total = fitness.Sum();
        var threshold = random.NextDouble() * total;
        double cumulative = 0;
        for (int i = 0; i < population.Count; i++)
        {
            cumulative += fitness[i];
            if (cumulative >= threshold) return population[i];
        }
        return population.Last();
    }

    private (Chromosome, Chromosome) Crossover(Chromosome p1, Chromosome p2, Random random)
    {
        var cut = random.Next(1, p1.Genes.Count);
        var c1 = new Chromosome { Genes = p1.Genes.Take(cut).Concat(p2.Genes.Skip(cut)).ToList() };
        var c2 = new Chromosome { Genes = p2.Genes.Take(cut).Concat(p1.Genes.Skip(cut)).ToList() };
        return (c1, c2);
    }

    private void Mutate(Chromosome chromosome, ScheduleInput input, Random random)
    {
        int idx = random.Next(chromosome.Genes.Count);
        var gene = chromosome.Genes[idx];
        gene.StartTime = gene.StartTime.AddHours(random.Next(-2, 3));
        gene.AssignedMachineId = input.Operations[idx].PreferredMachineId ?? random.Next(1, 100);
    }

    private List<OperationOutput> MapToOutput(Chromosome chromosome, ScheduleInput input)
    {
        return chromosome.Genes.Select(gene =>
        {
            var op = input.Operations.First(o => o.WoOperationId == gene.WoOperationId);
            var runHours = op.StdHoursPerUnit * op.PlanQty;
            return new OperationOutput(
                gene.WoOperationId,
                op.WorkCenterId,
                gene.AssignedMachineId > 0 ? gene.AssignedMachineId : null,
                gene.StartTime,
                gene.StartTime.AddHours((double)runHours + (double)op.SetupHours),
                "WAITING"
            );
        }).ToList();
    }
}

public class Chromosome
{
    public List<Gene> Genes { get; set; } = new();
}
public class Gene
{
    public long WoOperationId { get; set; }
    public long AssignedMachineId { get; set; }
    public DateTime StartTime { get; set; }
}

/// <summary>
/// 启发式（优先规则）求解器
/// </summary>
public class HeuristicSolver : ISchedulingSolver
{
    public string AlgorithmType => "HEURISTIC";

    public ScheduleOutput Solve(ScheduleInput input)
    {
        var startTime = DateTime.Now;

        // 按优先级 + 最晚交期（EDD）排序
        var sorted = input.Operations
            .OrderBy(o => o.Priority)
            .ThenBy(o => o.LatestEndTime ?? DateTime.MaxValue)
            .ToList();

        var currentTime = input.PlanningHorizonStart;
        var results = new List<OperationOutput>();

        foreach (var op in sorted)
        {
            var runHours = op.StdHoursPerUnit * op.PlanQty;
            var totalHours = runHours + op.SetupHours + op.WaitHours;
            var endTime = currentTime.AddHours((double)totalHours);

            results.Add(new OperationOutput(
                op.WoOperationId,
                op.WorkCenterId,
                op.PreferredMachineId > 0 ? op.PreferredMachineId : null,
                currentTime,
                endTime,
                "WAITING"
            ));

            currentTime = endTime;
        }

        var solveTime = (DateTime.Now - startTime).TotalSeconds;
        return new ScheduleOutput(true, $"启发式求解完成，共{results.Count}个工序", solveTime, results);
    }
}
