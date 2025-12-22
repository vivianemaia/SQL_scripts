-- ========================================
-- EXPLORAÇÃO COMPLETA DE BANCO DE DADOS SQL SERVER
-- ========================================
-- Script para descobrir schemas, tabelas, colunas, relacionamentos e dados de exemplo
-- Utilizado para modelagem dimensional de banco de dados de motoristas
-- ========================================

PRINT '========================================';
PRINT '1. SCHEMAS DO BANCO';
PRINT '========================================';
SELECT SCHEMA_NAME, SCHEMA_OWNER
FROM INFORMATION_SCHEMA.SCHEMATA
ORDER BY SCHEMA_NAME;

PRINT '========================================';
PRINT '2. TODAS AS TABELAS';
PRINT '========================================';
SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

PRINT '========================================';
PRINT '3. ESTRUTURA DAS TABELAS (COLUNAS)';
PRINT '========================================';
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, 
       CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME, ORDINAL_POSITION;

PRINT '========================================';
PRINT '4. PRIMARY KEYS';
PRINT '========================================';
SELECT TC.TABLE_SCHEMA, TC.TABLE_NAME, KCU.COLUMN_NAME, ORDINAL_POSITION
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU 
    ON TC.CONSTRAINT_NAME = KCU.CONSTRAINT_NAME
WHERE TC.CONSTRAINT_TYPE = 'PRIMARY KEY'
ORDER BY TC.TABLE_SCHEMA, TC.TABLE_NAME, ORDINAL_POSITION;

PRINT '========================================';
PRINT '5. FOREIGN KEYS (RELACIONAMENTOS)';
PRINT '========================================';
SELECT RC.CONSTRAINT_NAME, KCU1.TABLE_SCHEMA, KCU1.TABLE_NAME, KCU1.COLUMN_NAME,
       KCU2.TABLE_SCHEMA, KCU2.TABLE_NAME, KCU2.COLUMN_NAME
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS RC
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU1 
    ON RC.CONSTRAINT_NAME = KCU1.CONSTRAINT_NAME
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU2 
    ON RC.UNIQUE_CONSTRAINT_NAME = KCU2.CONSTRAINT_NAME
ORDER BY RC.CONSTRAINT_NAME;

PRINT '========================================';
PRINT '6. VOLUMETRIA - CONTAGEM DE REGISTROS';
PRINT '========================================';
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql += 'SELECT ''' + TABLE_SCHEMA + '.' + TABLE_NAME + ''' AS [Tabela], COUNT(*) AS [Total] UNION ALL ' 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';
SET @sql = LEFT(@sql, LEN(@sql) - 10);
EXEC sp_executesql @sql;

PRINT '========================================';
PRINT '7. ÍNDICES';
PRINT '========================================';
SELECT OBJECT_NAME(i.object_id) AS [Tabela], i.name AS [Índice], 
       i.type_desc AS [Tipo], c.name AS [Coluna]
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE OBJECT_NAME(i.object_id) NOT IN ('sysdiagrams')
ORDER BY OBJECT_NAME(i.object_id), i.name;

PRINT '========================================';
PRINT '8. AMOSTRA DE DADOS (10 LINHAS CADA TABELA)';
PRINT '========================================';

DECLARE @table NVARCHAR(255);
DECLARE @schema NVARCHAR(255);
DECLARE @fullQuery NVARCHAR(MAX);

DECLARE table_cursor CURSOR FOR
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @schema, @table;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT '--- ' + @schema + '.' + @table + ' ---';
    SET @fullQuery = 'SELECT TOP 10 * FROM [' + @schema + '].[' + @table + '];';
    EXEC sp_executesql @fullQuery;
    
    FETCH NEXT FROM table_cursor INTO @schema, @table;
END

CLOSE table_cursor;
DEALLOCATE table_cursor;

PRINT '========================================';
PRINT 'FIM DA EXPLORAÇÃO';
PRINT '========================================';
