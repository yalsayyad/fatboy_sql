SET STATISTICS TIME ON
GO

DECLARE @DataName VARCHAR(50)
DECLARE @CompleteDataName VARCHAR(50)
DECLARE @SQL VARCHAR(MAX)

DECLARE TableCursor CURSOR READ_ONLY
FOR
SELECT intMonth
FROM dbo.ssm_year_master
WHERE yr = 4
  AND leap_sec IS NULL

OPEN TableCursor

FETCH NEXT
FROM TableCursor
INTO @DataName

WHILE @@FETCH_STATUS = 0
BEGIN
  SET @CompleteDataName = '[LSSTSSM].dbo.C14_S1_' + str(@DataName, 5, 0)
  SET @SQL = 'UPDATE ' + @CompleteDataName + ' WITH(TABLOCKX)
              SET [htmID]=[LSSTCATSIM].dbo.fHtmEq(ra_c1, dec_c1)'

  PRINT @SQL;
  EXEC(@SQL);

  SET @SQL = 'ALTER TABLE ' + @CompleteDataName + '
              ADD PRIMARY KEY(htmid, mjd_start, mjd_end, ssmid)'

  PRINT @SQL;
  EXEC(@SQL);

  FETCH NEXT
  FROM TableCursor
  INTO @DataName
END

CLOSE TableCursor

DEALLOCATE TableCursor