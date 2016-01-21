USE [LSST]
GO

CREATE TABLE [dbo].[STARTEST](
	[htmid] [bigint] NOT NULL,
	[simobjid] [bigint] IDENTITY(400000,1) NOT NULL,
	[ra] [float] NULL,
	[decl] [float] NULL,
	[gal_l] [float] NULL,
	[gal_b] [float] NULL,
	[versionid] [varchar](10) NULL,
	[mura] [real] NULL,
	[mudecl] [real] NULL,
	[vrad] [real] NULL,
	[parallax] [float] NULL,
	[distance] [float] NULL,
	[sedfilename] [varchar](max) NULL,
	[sedid] [int] NULL,
	[flux_scale] [float] NULL,
	[umag] [float] NULL,
	[gmag] [float] NULL,
	[rmag] [float] NULL,
	[imag] [float] NULL,
	[zmag] [float] NULL,
	[ymag] [float] NULL,
	[sdssu] [real] NULL,
	[sdssg] [real] NULL,
	[sdssr] [real] NULL,
	[sdssi] [real] NULL,
	[sdssz] [real] NULL,
	[absmr] [real] NULL,
	[newSDSSu] [float] NULL,
	[newSDSSg] [float] NULL,
	[newSDSSr] [float] NULL,
	[newSDSSi] [float] NULL,
	[newSDSSz] [float] NULL,
	[ebv] [float] NULL,
	[especid] [tinyint] NULL,
	[pop] [tinyint] NULL,
	[type] [tinyint] NULL,
	[t] [float] NULL,
	[feh] [real] NULL,
	[logg] [real] NULL,
	[vr] [real] NULL,
	[vphi] [real] NULL,
	[vz] [real] NULL,
	[ismultiple] [tinyint] NULL,
	[isvar] [tinyint] NULL,
	[timescale] [float] NULL,
	[varfluxpeak] [float] NULL,
	[t0] [float] NULL,
	[x] [real] NULL,
	[y] [real] NULL,
	[z] [real] NULL,
	[cx] [float] NULL,
	[cy] [float] NULL,
	[cz] [float] NULL,
	[run] [int] NULL,
	[runobjid] [int] NULL,
	[varParamStr] [varchar](max) NULL,
	[varsimobjid] [bigint] NULL,
	[randomVar] [float] NULL,
	[sedfiletype] [char](4) NULL
) ON [PRIMARY]
GO


INSERT INTO LSST.dbo.STARTEST
SELECT TOP 10
dbo.fHtmEq(ra,decl) as htmid
-- NO simobjid
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
,(Select x from LSSTCATSIM.dbo.fHtmEqToXyz(ra, decl)) as cx
,(Select y from LSSTCATSIM.dbo.fHtmEqToXyz(ra, decl)) as cy
,(Select z from LSSTCATSIM.dbo.fHtmEqToXyz(ra, decl)) as cz
,s.[run]
,s.[runobjid]
,s.varsimobjid
,s.[varParamStr]
,s.[randomVar]
,SUBSTRING([sedfilename],1,4) as sedfiletype
FROM LSSTCATSIM.dbo.stars_obafgk_part_1100 as s
GO


