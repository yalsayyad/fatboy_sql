SET STATISTICS TIME OFF
GO

DECLARE @tableName VARCHAR(50)
DECLARE @CompleteDataName VARCHAR(50)
DECLARE @SQL VARCHAR(MAX)
DECLARE @MjdEnd VARCHAR(50)

DECLARE TableCursor CURSOR READ_ONLY
FOR
SELECT tableName
  ,mjd_end
FROM mbaTableMaster
WHERE indexed = 1


OPEN TableCursor

FETCH NEXT
FROM TableCursor
INTO @TableName
  ,@mjdEnd

WHILE @@FETCH_STATUS = 0
BEGIN
  SET @CompleteDataName = '[LSSTSSM].dbo.' + @tableName
  SET @SQL = '

ELSE IF @MJD < ' + @MjdEnd + '

INSERT INTO @MBA
SELECT ssmid
	,@mjd AS mjd
	,pv.ra
	,pv.decl
	,pv.dradt
	,pv.ddecldt
	,dbo.chebeval_5_single(@MJD, mjd_start, mjd_end, dist_c1, dist_c2, dist_c3, dist_c4, dist_c5) AS dist
	,vmag.magNorm
	,vmag.umag
	,vmag.gmag
	,vmag.rmag
	,vmag.imag
	,vmag.zmag
	,vmag.ymag
	,dbo.chebeval_6_single(@MJD, mjd_start, mjd_end, se_c1, se_c2, se_c3, se_c4, se_c5, se_c6) AS se
	,o.sed_filename
FROM ' + @CompleteDataName + ' s WITH (FORCESEEK)
INNER JOIN (
	SELECT htmidstart
		,htmidend
	FROM dbo.fHtmCoverBinaryAdvanced(sph.fGrow(sph.fSimplifyString(@RegionStr), 0.8))
	WHERE innerflag = 0
	) c ON s.htmid BETWEEN c.htmidstart
		AND c.htmidend
INNER JOIN LSSTSSM.dbo.sedLookup o ON o.objid = s.ssmid
CROSS APPLY dbo.chebeval_14_pv_full(@MJD, mjd_start, mjd_end, ra_c1, ra_c2, ra_c3, ra_c4, ra_c5, ra_c6, ra_c7, ra_c8, 
		ra_c9, ra_c10, ra_c11, ra_c12, ra_c13, ra_c14, dec_c1, dec_c2, dec_c3, dec_c4, dec_c5, dec_c6, dec_c7, dec_c8, 
		dec_c9, dec_c10, dec_c11, dec_c12, dec_c13, dec_c14) pv
CROSS APPLY dbo.chebeval9_vmag(@MJD, mjd_start, mjd_end, v_c1, v_c2, v_c3, v_c4, v_c5, v_c6, v_c7, v_c8, v_c9, 
		o.dnorm, o.du, o.dg, o.dr, o.di, o.dz, o.dy) vmag
WHERE @MJD >= mjd_start
	AND @MJD < mjd_end
	AND sph.fRegionContainsXYZ(sph.fSimplifyString(@RegionStr), x, y, z) = 1
'

  PRINT @SQL;

  FETCH NEXT
  FROM TableCursor
  INTO @TableName, @MjdEnd
END

CLOSE TableCursor

DEALLOCATE TableCursor