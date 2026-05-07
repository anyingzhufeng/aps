namespace APS.Domain.ValueObjects;

/// <summary>
/// 时间范围值对象
/// </summary>
public readonly struct TimeRange : IEquatable<TimeRange>
{
    public DateTime Start { get; }
    public DateTime End { get; }

    public TimeRange(DateTime start, DateTime end)
    {
        if (end < start)
            throw new ArgumentException("End must be after Start");
        Start = start;
        End = end;
    }

    public TimeSpan Duration => End - Start;
    public bool Overlaps(TimeRange other) => Start < other.End && End > other.Start;
    public bool Contains(DateTime dt) => dt >= Start && dt <= End;

    public bool Equals(TimeRange other) => Start == other.Start && End == other.End;
    public override bool Equals(object? obj) => obj is TimeRange r && Equals(r);
    public override int GetHashCode() => HashCode.Combine(Start, End);
    public static bool operator ==(TimeRange left, TimeRange right) => left.Equals(right);
    public static bool operator !=(TimeRange left, TimeRange right) => !left.Equals(right);
    public override string ToString() => $"{Start:yyyy-MM-dd HH:mm}~{End:yyyy-MM-dd HH:mm}";
}

/// <summary>
/// 数量值对象
/// </summary>
public readonly struct Quantity : IEquatable<Quantity>
{
    public decimal Value { get; }
    public string UnitCode { get; }

    public Quantity(decimal value, string unitCode = "PCS")
    {
        if (value < 0) throw new ArgumentException("Quantity cannot be negative");
        Value = value;
        UnitCode = unitCode;
    }

    public bool Equals(Quantity other) => Value == other.Value && UnitCode == other.UnitCode;
    public override bool Equals(object? obj) => obj is Quantity q && Equals(q);
    public override int GetHashCode() => HashCode.Combine(Value, UnitCode);
    public static bool operator ==(Quantity left, Quantity right) => left.Equals(right);
    public static bool operator !=(Quantity left, Quantity right) => !left.Equals(right);
    public override string ToString() => $"{Value} {UnitCode}";
}

/// <summary>
/// 货币值对象
/// </summary>
public readonly struct Money : IEquatable<Money>
{
    public decimal Amount { get; }
    public string CurrencyCode { get; }

    public Money(decimal amount, string currencyCode = "CNY")
    {
        Amount = amount;
        CurrencyCode = currencyCode;
    }

    public bool Equals(Money other) => Amount == other.Amount && CurrencyCode == other.CurrencyCode;
    public override bool Equals(object? obj) => obj is Money m && Equals(m);
    public override int GetHashCode() => HashCode.Combine(Amount, CurrencyCode);
    public static bool operator ==(Money left, Money right) => left.Equals(right);
    public static bool operator !=(Money left, Money right) => !left.Equals(right);
    public override string ToString() => $"{CurrencyCode} {Amount:N2}";
}
