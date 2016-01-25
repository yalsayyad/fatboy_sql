WITH  i as (SELECT 
     ind.name as indName,
     col.name as colName
FROM sys.indexes ind 

INNER JOIN sys.index_columns ic 
    ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 

INNER JOIN sys.columns col 
    ON ic.object_id = col.object_id and ic.column_id = col.column_id 

INNER JOIN sys.tables t 
    ON ind.object_id = t.object_id 

WHERE (1=1) 
    --AND ind.is_primary_key = 0 
   -- AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
    and t.object_id = %d
  )
SELECT 
  [indName],
  STUFF((
    SELECT ', ' + [colName] 
    FROM i
    WHERE (indName = Results.indName) 
    FOR XML PATH (''))
  ,1,2,'') AS NameValues
FROM i Results
GROUP BY indName