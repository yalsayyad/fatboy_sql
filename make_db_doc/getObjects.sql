SELECT

	O.object_id		AS [id], 
	S.name			AS [schema], 
	O.name			AS [name], 
	CASE O.type_desc WHEN 'USER_TABLE' THEN 'TABLE' 
	WHEN 'SQL_TABLE_VALUED_FUNCTION' THEN 'TABLE_VALUED_FUNCTION' 
	WHEN 'SQL_INLINE_TABLE_VALUED_FUNCTION' THEN 'TABLE_VALUED_FUNCTION' 
	WHEN  'SQL_STORED_PROCEDURE' THEN 'STORED_PROCEDURE'
	ELSE O.type_desc END	AS [type], 
	docItems.docSection,
	CAST(O.create_date as varchar(100)) AS [dateCreated], 
	CAST(O.modify_date	AS varchar(100)) AS [dateModified], 
	Cast(P.value AS varchar(MAX))	AS [description],
	R.RowCounts

FROM 
	sys.objects AS O
	INNER JOIN docItems 
		ON docItems.itemName = O.name
	LEFT JOIN (SELECT object_id, max(rows) as rowCounts FROM sys.partitions  GROUP BY  object_id) R
		ON O.object_id = R.object_id
	LEFT JOIN sys.schemas AS S 
		on S.schema_id = o.schema_id
	LEFT JOIN sys.extended_properties AS P 
		ON P.major_id = O.object_id AND P.minor_id = 0 and P.name = 'MS_Description' 
	
WHERE 
	is_ms_shipped = 0 
	and O.name IN (select itemName from docItems)
ORDER BY docItems.docSectionSort, O.type_desc, O.name