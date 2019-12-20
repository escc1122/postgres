UPDATE C as ccc
SET column1 = update_data.column1
FROM (select * from up WHERE ~) as update_data
WHERE ccc.column1='aaaaaa' and ccc.column2=update_data.column2 
