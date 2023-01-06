SET NOCOUNT ON;

GO

TRUNCATE TABLE [dbo].[Dim_Date];

GO

DECLARE @CurrentDate DATETIME = '2011-03-21 00:00:00.000' -- Define Start of your desired calendar
DECLARE @EndDate DATETIME = '2032-03-20 23:59:00.000' -- Define end of your calendar


WHILE @CurrentDate < @EndDate
BEGIN
   INSERT INTO [dbo].[Dim_Date] (
      [DateKey],
	  [time_Stamp],
      [Date],
	  [ShDate],
      [Day],
      [Weekday],
	  [ShWeekday],
	  [WeekDayName],
	  [ShWeekDayName],
      [Month],
	  [ShMonth],
      [MonthName],
	  [ShMonthName],
      [Quarter],
      [QuarterName],
      [ShQuarter],
      [ShQuarterName],
      [Year],
	  [ShYYYY],
      [YYYYMM],
      [ShYYYYMM],
      [YYYYQQ],
      [ShYYYYQQ],
      [MonthYear],
      [IsWeekend],
      [IsHoliday]
      )
   SELECT DateKey = NEWID(),
      [time_Stamp] = @CurrentDate,
	  DATE = CONVERT(DATE, @CurrentDate),
	  [ShDate] = dbo.ShDate(@CurrentDate,'YYYY-MM-DD'),
      Day = DAY(@CurrentDate),
      WEEKDAY = DATEPART(dw, @CurrentDate),
	  [ShWeekday] = Cast(dbo.ShDate(@CurrentDate,'dw') as tinyint),
	  [WeekDayName] = DATENAME(dw, @CurrentDate),
	  [ShWeekDayName] = dbo.ShDate(@CurrentDate,'DWN'),
      [Month] = MONTH(@CurrentDate),
	  [ShMonth] = Cast(dbo.ShDate(@CurrentDate,'m') as tinyint),
      [MonthName] = DATENAME(mm, @CurrentDate),
	  [ShMonthName] = dbo.ShDate(@CurrentDate,'MMN'),
      [Quarter] = DATEPART(q, @CurrentDate),
      [QuarterName] = CASE 
         WHEN DATENAME(qq, @CurrentDate) = 1
            THEN 'First'
         WHEN DATENAME(qq, @CurrentDate) = 2
            THEN 'second'
         WHEN DATENAME(qq, @CurrentDate) = 3
            THEN 'third'
         WHEN DATENAME(qq, @CurrentDate) = 4
            THEN 'fourth'
         END,
      [ShQuarter] = Cast(dbo.ShDate(@CurrentDate,'q') as tinyint),
	  [ShQuarterName] = dbo.ShDate(@CurrentDate,'QQN'),
      [Year] = YEAR(@CurrentDate),
	  [ShYYYY] = CAST(dbo.ShDate(@CurrentDate,'YYYY') as int),
      [YYYYMM] = CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + RIGHT('0' + CAST(MONTH(@CurrentDate) AS VARCHAR(2)), 2),
	  [ShYYYYMM] = dbo.ShDate(@CurrentDate,'YYYY-MM'),
      [YYYYQQ] = CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + RIGHT('0' + CAST(DATEPART(q, @CurrentDate) AS VARCHAR(2)), 2),
      [ShYYYYQQ] = dbo.ShDate(@CurrentDate,'YYYY-QQ'),
	  [MonthYear] = CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)),
      [IsWeekend] = CASE 
         WHEN DATENAME(dw, @CurrentDate) = 'Thursday'
            OR DATENAME(dw, @CurrentDate) = 'Friday'
            THEN 1
         ELSE 0
         END,
      [IsHoliday] = 0

   SET @CurrentDate = DATEADD(MINUTE, 2, @CurrentDate)
END
