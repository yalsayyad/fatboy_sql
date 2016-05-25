SET STATISTICS TIME ON
GO

DECLARE @DataName VARCHAR(50)
DECLARE @CompleteDataName VARCHAR(50)
DECLARE @SQL VARCHAR(MAX)

DECLARE TableCursor CURSOR READ_ONLY
FOR
SELECT intMonth
FROM dbo.ssm_year_master
WHERE yr = 6

OPEN TableCursor

FETCH NEXT
FROM TableCursor
INTO @DataName

WHILE @@FETCH_STATUS = 0
BEGIN
  SET @CompleteDataName = '[LSSTSSM].dbo.C14_S1_' + str(@DataName, 5, 0)
  SET @SQL = '
If OBJECT_ID(''' + @CompleteDataName + ''') is not null
DROP TABLE ' + @CompleteDataName + '

CREATE TABLE ' + @CompleteDataName + '(
    [htmid] [bigint] NOT NULL,
    [ssmid] [int] NOT NULL,
    [mjd_start] decimal(5,0) NOT NULL,
    [mjd_end] decimal(5,0) NOT NULL,
    [ra_c1] [float] NULL,
    [ra_c2] [float] NULL,
    [ra_c3] [float] NULL,
    [ra_c4] [float] NULL,
    [ra_c5] [float] NULL,
    [ra_c6] [float] NULL,
    [ra_c7] [float] NULL,
    [ra_c8] [float] NULL,
    [ra_c9] [float] NULL,
    [ra_c10] [float] NULL,
    [ra_c11] [float] NULL,
    [ra_c12] [float] NULL,
    [ra_c13] [float] NULL,
    [ra_c14] [float] NULL,
    [dec_c1] [float] NULL,
    [dec_c2] [float] NULL,
    [dec_c3] [float] NULL,
    [dec_c4] [float] NULL,
    [dec_c5] [float] NULL,
    [dec_c6] [float] NULL,
    [dec_c7] [float] NULL,
    [dec_c8] [float] NULL,
    [dec_c9] [float] NULL,
    [dec_c10] [float] NULL,
    [dec_c11] [float] NULL,
    [dec_c12] [float] NULL,
    [dec_c13] [float] NULL,
    [dec_c14] [float] NULL,
    [dist_c1] [real] NULL,
    [dist_c2] [real] NULL,
    [dist_c3] [real] NULL,
    [dist_c4] [real] NULL,
    [dist_c5] [real] NULL,
    [v_c1] [real] NULL,
    [v_c2] [real] NULL,
    [v_c3] [real] NULL,
    [v_c4] [real] NULL,
    [v_c5] [real] NULL,
    [v_c6] [real] NULL,
    [v_c7] [real] NULL,
    [v_c8] [real] NULL,
    [v_c9] [real] NULL,
    [se_c1] [real] NULL,
    [se_c2] [real] NULL,
    [se_c3] [real] NULL,
    [se_c4] [real] NULL,
    [se_c5] [real] NULL,
    [se_c6] [real] NULL)
    '

  PRINT @SQL;

  EXEC (@SQL);

  FETCH NEXT
  FROM TableCursor
  INTO @DataName
END

CLOSE TableCursor

DEALLOCATE TableCursor