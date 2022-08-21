SET NOCOUNT ON

TRUNCATE TABLE DIM_DateTest

DECLARE @CurrentDate DATETIME = '2011-03-21 00:00:00.000'
DECLARE @EndDate DATETIME = '2032-03-20 23:59:00.000'
--DECLARE @EndDate DATETIME = '2054-03-20 23:59:00.000'
--DECLARE @EndDate DATETIME = '2011-03-21 06:00:00.000'

WHILE @CurrentDate < @EndDate
BEGIN
   INSERT INTO [dbo].[Dim_DateTest] (
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
   SELECT DateKey = NEWID(),--YEAR(@CurrentDate) * 100000000 + MONTH(@CurrentDate) * 1000000 + DAY(@CurrentDate)  *10000  + (DatePart(HOUR,@CurrentDate)) *100 + (DatePart(MINUTE,@CurrentDate)),
      [time_Stamp] = @CurrentDate,
	  DATE = CONVERT(DATE, @CurrentDate),
	  [ShDate] = dbo.ShDateTest(@CurrentDate,'YYYY-MM-DD'),
      Day = DAY(@CurrentDate),
      WEEKDAY = DATEPART(dw, @CurrentDate),
	  [ShWeekday] = Cast(dbo.ShDateTest(@CurrentDate,'dw') as tinyint),
	  [WeekDayName] = DATENAME(dw, @CurrentDate),
	  [ShWeekDayName] = dbo.ShDateTest(@CurrentDate,'DWN'),
      [Month] = MONTH(@CurrentDate),
	  [ShMonth] = Cast(dbo.ShDateTest(@CurrentDate,'m') as tinyint),
      [MonthName] = DATENAME(mm, @CurrentDate),
	  [ShMonthName] = dbo.ShDateTest(@CurrentDate,'MMN'),
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
      [ShQuarter] = Cast(dbo.ShDateTest(@CurrentDate,'q') as tinyint),
	  [ShQuarterName] = dbo.ShDateTest(@CurrentDate,'QQN'),
      [Year] = YEAR(@CurrentDate),
	  [ShYYYY] = CAST(dbo.ShDateTest(@CurrentDate,'YYYY') as int),
      [YYYYMM] = CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + RIGHT('0' + CAST(MONTH(@CurrentDate) AS VARCHAR(2)), 2),
	  [ShYYYYMM] = dbo.ShDateTest(@CurrentDate,'YYYY-MM'),
      [YYYYQQ] = CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + RIGHT('0' + CAST(DATEPART(q, @CurrentDate) AS VARCHAR(2)), 2),
      [ShYYYYQQ] = dbo.ShDateTest(@CurrentDate,'YYYY-QQ'),
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