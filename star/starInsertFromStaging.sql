USE LSSTCATSIM
GO

INSERT INTO NewStar
SELECT TOP 10
dbo.fHtmEq(ra,decl) as htmid
,s.[simobjid]
,s.[ra]
,s.[decl]
,s.[gal_l]
,s.[gal_b]
,s.[versionid]
,s.[mura]
,s.[mudecl]
,s.[vrad]
,s.[parallax]
,s.[distance]
,s.[sedfilename]
,s.[sedid]
,s.[flux_scale]
,s.[umag]
,s.[gmag]
,s.[rmag]
,s.[imag]
,s.[zmag]
,s.[ymag]
,s.[sdssu]
,s.[sdssg]
,s.[sdssr]
,s.[sdssi]
,s.[sdssz]
,s.[absmr]
,s.[newSDSSu]
,s.[newSDSSg]
,s.[newSDSSr]
,s.[newSDSSi]
,s.[newSDSSz]
,s.[ebv]
,s.[especid]
,s.[pop]
,s.[type]
,s.[t]
,s.[feh]
,s.[logg]
,s.[vr]
,s.[vphi]
,s.[vz]
,s.[ismultiple]
,s.[isvar]
,s.[timescale]
,s.[varfluxpeak]
,s.[t0]
,s.[x]
,s.[y]
,s.[z]
,(Select x from dbo.fHtmEqToXyz(ra, decl)) as cx
,(Select y from dbo.fHtmEqToXyz(ra, decl)) as cy
,(Select z from dbo.fHtmEqToXyz(ra, decl)) as cz
,s.[run]
,s.[runobjid]
,s.varsimobjid
,s.[varParamStr]
,s.[randomVar]
,SUBSTRING([sedfilename],1,4) as sedfiletype
-- geography::STPointFromText('POINT(' + str([ra],20,16)+ ' ' + str([decl],20,16) + ')', 4326) as geopoint -- not used in new tables
FROM StagingStar s
CROSS APPLY dbo.fHtmEqToXyz(ra, decl) as xyz
GO

/* Note: More readable way to cross apply table valued htm functions

   But for large tables, this will try to create the "join" first
   and then do your select or insert which is less efficient than computing 
   x, y, z, on the output.
*/
SELECT
 xyz.x as cx
,xyz.y as cy
,xyz.z as cz
FROM StagingStar s
CROSS APPLY dbo.fHtmEqToXyz(ra, decl) as xyz


-- If htmid is not NOT NULL already:
ALTER TABLE NewStar ALTER COLUMN htmid bigint NOT NULL
GO

-- Sort by htmid, simobjid
ALTER TABLE NewStar ADD PRIMARY KEY (htmid, simobjid)
GO