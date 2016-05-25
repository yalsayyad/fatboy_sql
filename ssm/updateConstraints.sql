SET STATISTICS TIME ON
GO


DECLARE @DataName VARCHAR(50)
DECLARE @intMonth INT
DECLARE @CompeteStagingName VARCHAR(50)
DECLARE @CompleteDataName VARCHAR(50)
DECLARE @ConstraintName VARCHAR(50)
DECLARE @SQL VARCHAR(MAX)

DECLARE TableCursor CURSOR READ_ONLY
FOR
SELECT intMonth
FROM dbo.ssm_year_master
--  WHERE yr = 7
--  AND leap_sec IS NULL

OPEN TableCursor

FETCH NEXT
FROM TableCursor
INTO @intMonth

WHILE @@FETCH_STATUS = 0
BEGIN
  SET @CompleteDataName = '[LSSTSSM].dbo.C14_S1_' + str(@intMonth, 5, 0)
  SET @ConstraintName = 'date' + str(@intMonth, 5, 0)
  SET @SQL = '

ALTER TABLE ' + @CompleteDataName + '  WITH CHECK ADD CONSTRAINT ' + @ConstraintName + '
CHECK  (([mjd_start]>=(' + str(@intMonth, 8, 2) + ') AND [mjd_start]<=(' + str(@intMonth + 28.0, 8, 2) + ')
    AND [mjd_end]<=(' + str(@intMonth + 30.0, 8, 2) + ')AND  [mjd_end]>=(' + str(@intMonth + 2.0, 8, 2) + ')
    ))

ALTER TABLE ' + @CompleteDataName + ' CHECK CONSTRAINT ' + @ConstraintName + ''

  PRINT @SQL;

  EXEC (@SQL);

  FETCH NEXT
  FROM TableCursor
  INTO @intMonth
END

CLOSE TableCursor

DEALLOCATE TableCursor