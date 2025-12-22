# 🚛 SQL Server - Exploração de Banco de Dados Motoristas

Script completo para descoberta de esquema, tabelas e dados de exemplo em SQL Server, idealizado para criação de **modelagem dimensional** em bancos de dados de gestão de motoristas de caminhão.

## 📋 Conteúdo

### 1. **01_exploracao_banco_completa.sql**
Script único que executa 8 análises diferentes:

- ✅ **Schemas** - Lista todos os schemas do banco
- ✅ **Tabelas** - Exibe todas as tabelas base
- ✅ **Estrutura** - Detalhes de colunas, tipos de dados e constraints
- ✅ **Primary Keys** - Chaves primárias de todas as tabelas
- ✅ **Foreign Keys** - Relacionamentos entre tabelas
- ✅ **Volumetria** - Contagem de registros por tabela
- ✅ **Índices** - Índices existentes
- ✅ **Dados de Exemplo** - 10 linhas de amostra de cada tabela

## 🚀 Como Usar

### Pré-requisitos
- SQL Server Management Studio (SSMS) instalado
- Acesso ao banco de dados SQL Server

### Passos

1. **Abra o SQL Server Management Studio**
2. **Conecte-se ao seu banco de dados**
3. **Abra o arquivo**: `01_exploracao_banco_completa.sql`
4. **Execute** (F5 ou Ctrl+E)
5. **Analise os resultados** nas abas "Mensagens" e "Resultados"

### Exemplo de Uso

```sql
-- Simplesmente copiar todo conteúdo e executar
-- Não é necessário modificar nada!
PRINT '1. SCHEMAS DO BANCO';
SELECT SCHEMA_NAME, SCHEMA_OWNER FROM INFORMATION_SCHEMA.SCHEMATA ...
```

## 📊 Estrutura Esperada de Dados

O script é genérico e funciona com qualquer banco SQL Server, mas é otimizado para bancos com estrutura similar a:

### Tabelas Operacionais (OLTP)
- `Motoristas` / `Drivers` - Dados dos motoristas
- `Caminhoes` / `Trucks` - Dados dos veículos
- `Viagens` / `Trips` - Registros de viagens
- `HorasExtras` / `Overtime` - Horas extras trabalhadas
- `Comissoes` / `Commissions` - Comissões por viagem
- `FolhaPagamento` / `Payroll` - Folha de pagamento

## 💡 Saídas do Script

### 1. Schemas
```
SCHEMA_NAME     SCHEMA_OWNER
dbo             sa
```

### 2. Volumetria
```
Tabela          Total
dbo.Motoristas  150
dbo.Viagens     5000
dbo.Comissoes   5000
```

### 3. Estrutura de Tabelas
```
TABLE_SCHEMA  TABLE_NAME    COLUMN_NAME        DATA_TYPE
dbo           Motoristas    motorista_id       int
dbo           Motoristas    nome               varchar(100)
dbo           Motoristas    cpf                varchar(11)
```

## 🎯 Próximos Passos

Após executar este script, você pode:

1. **Criar Dimensões** (dim_motoristas, dim_viagens, dim_datas)
2. **Criar Fact Tables** (fact_desempenho, fact_folha_pagamento)
3. **Desenvolver ETL** para sincronizar dados OLTP → OLAP
4. **Criar Views Analíticas** para dashboards e relatórios

## 📝 Notas Importantes

- ⚠️ O script é **read-only** - não modifica nenhum dado
- ⚠️ Se você tiver **muitas tabelas**, a execução pode demorar um pouco
- ⚠️ Para bancos muito grandes, considere comentar a seção 8 (amostra de dados)

## 🔍 Customização

Se quiser explorar apenas algumas tabelas, você pode comentar as seções não desejadas:

```sql
-- Comentar a seção 8 se houver muitas tabelas
/*
PRINT '8. AMOSTRA DE DADOS';
DECLARE @table NVARCHAR(255);
...
*/
```

## 📚 Referências

- [INFORMATION_SCHEMA - Microsoft Docs](https://learn.microsoft.com/pt-br/sql/relational-databases/information-schema-views/information-schema-views-transact-sql)
- [Modelagem Dimensional](https://pt.wikipedia.org/wiki/Esquema_em_estrela)
- [Boas Práticas SQL Server](https://learn.microsoft.com/pt-br/sql/t-sql/queries/select-transact-sql)

## 📞 Suporte

Se encontrar problemas:
1. Verifique se está conectado ao banco correto
2. Verifique permissões de visualização de schema
3. Considere executar como administrador

## 📄 Licença

Livre para uso, modificação e distribuição.

---

**Criado em:** Dezembro 2025  
**Versão:** 1.0  
**Linguagem:** T-SQL (SQL Server)
