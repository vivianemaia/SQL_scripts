# Guia de Modelagem Dimensional para SQL Server

## 📊 Estrutura da Modelagem Dimensional

Este guia complementa o script de exploração e fornece um roteiro para criar o modelo dimensional (Data Warehouse) baseado nos dados descobertos.

## 1️⃣ Fase 1: Análise das Tabelas de Origem

Após executar `01_exploracao_banco_completa.sql`, você terá:
- Mapeamento de todas as tabelas OLTP (operacionais)
- Relacionamentos entre tabelas
- Tipos de dados e constraints
- Amostra de dados reais

## 2️⃣ Fase 2: Design das Dimensões

### Dimensões Principais para Sistema de Motoristas

#### `dim_motoristas` (Motorista)
```sql
motorista_key        INT (PK substituta)
motorista_id         INT (FK da tabela operacional)
nome                 VARCHAR(100)
cpf                  VARCHAR(11)
data_admissao        DATE
categoria_cnh        CHAR(2)
salario_base         DECIMAL(10,2)
percentual_comissao  DECIMAL(5,2)
status               VARCHAR(20)
data_inicio          DATE (SCD Type 2)
data_fim             DATE (SCD Type 2)
is_current           BOOLEAN
```

#### `dim_caminhoes` (Veículo)
```sql
caminhao_key         INT (PK substituta)
caminhao_id          INT (FK operacional)
placa                VARCHAR(10)
fabricante           VARCHAR(50)
modelo               VARCHAR(50)
ano                  INT
capacidade_kg        DECIMAL(10,2)
tipo_veiculo         VARCHAR(30)
status               VARCHAR(20)
data_inicio          DATE
data_fim             DATE
is_current           BOOLEAN
```

#### `dim_datas`
```sql
data_key             INT (YYYYMMDD)
data_calendario      DATE
ano                  INT
trimestre            INT
mes                  INT
semana               INT
dia                  INT
dia_semana           INT
nome_dia             VARCHAR(10)
nome_mes             VARCHAR(10)
eh_fim_de_semana     BOOLEAN
eh_feriado           BOOLEAN
```

#### `dim_rotas`
```sql
rota_key             INT (PK substituta)
cidade_origem        VARCHAR(50)
estado_origem        CHAR(2)
cidade_destino       VARCHAR(50)
estado_destino       CHAR(2)
distancia_estimada   DECIMAL(10,2)
dificuldade_rota     VARCHAR(20)
```

## 3️⃣ Fase 3: Design das Fact Tables

### Fact Table: `fact_desempenho_motorista`
Granularidade: Uma linha por viagem

```sql
desempenho_key       BIGINT (PK)
motorista_key        INT (FK dim_motoristas)
caminhao_key         INT (FK dim_caminhoes)
rota_key             INT (FK dim_rotas)
data_key             INT (FK dim_datas)

-- Medidas
distancia_km         DECIMAL(10,2)
valor_frete          DECIMAL(12,2)
peso_carga_kg        DECIMAL(10,2)
horas_trabalho       DECIMAL(5,2)
horas_extra          DECIMAL(5,2)
custo_combustivel    DECIMAL(10,2)
custo_pedagio        DECIMAL(10,2)
valor_comissao       DECIMAL(12,2)

-- Flags
viagem_no_prazo      BOOLEAN
incidente_seguranca  BOOLEAN
dano_carga           BOOLEAN
```

### Fact Table: `fact_folha_pagamento`
Granularidade: Uma linha por motorista por mês

```sql
folha_key            BIGINT (PK)
motorista_key        INT (FK dim_motoristas)
mes_key              INT (FK dim_datas)

-- Medidas
salario_base         DECIMAL(12,2)
total_horas_extra    DECIMAL(12,2)
total_comissao       DECIMAL(12,2)
bonificacoes         DECIMAL(12,2)
descontos            DECIMAL(12,2)
inss                 DECIMAL(12,2)
irpf                 DECIMAL(12,2)
salario_bruto        DECIMAL(12,2)
salario_liquido      DECIMAL(12,2)

-- Contadores
numero_viagens       INT
dias_trabalhados     INT
ocorrencias_extra    INT
status_folha         VARCHAR(20)
```

## 4️⃣ Fase 4: Implementação em SQL Server

### Criar Dimensões

```sql
-- Criar dimensão de motoristas com SCD Type 2
CREATE TABLE dim_motoristas (
    motorista_key INT IDENTITY(1,1) PRIMARY KEY,
    motorista_id INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11),
    data_admissao DATE,
    categoria_cnh CHAR(2),
    salario_base DECIMAL(10,2),
    percentual_comissao DECIMAL(5,2),
    status VARCHAR(20),
    data_inicio DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    data_fim DATE,
    is_current BIT DEFAULT 1,
    INDEX idx_motorista_id (motorista_id),
    INDEX idx_is_current (is_current)
);
```

### Criar Fact Table

```sql
CREATE TABLE fact_desempenho_motorista (
    desempenho_key BIGINT IDENTITY(1,1) PRIMARY KEY,
    motorista_key INT NOT NULL,
    caminhao_key INT NOT NULL,
    rota_key INT NOT NULL,
    data_key INT NOT NULL,
    distancia_km DECIMAL(10,2),
    valor_frete DECIMAL(12,2),
    peso_carga_kg DECIMAL(10,2),
    horas_trabalho DECIMAL(5,2),
    horas_extra DECIMAL(5,2),
    custo_combustivel DECIMAL(10,2),
    custo_pedagio DECIMAL(10,2),
    valor_comissao DECIMAL(12,2),
    viagem_no_prazo BIT,
    incidente_seguranca BIT,
    dano_carga BIT,
    
    FOREIGN KEY (motorista_key) REFERENCES dim_motoristas(motorista_key),
    FOREIGN KEY (caminhao_key) REFERENCES dim_caminhoes(caminhao_key),
    FOREIGN KEY (rota_key) REFERENCES dim_rotas(rota_key),
    FOREIGN KEY (data_key) REFERENCES dim_datas(data_key),
    
    INDEX idx_motorista_key (motorista_key),
    INDEX idx_data_key (data_key),
    INDEX idx_caminhao_key (caminhao_key)
);
```

## 5️⃣ Fase 5: Queries Analíticas Comuns

### Query 1: Total de Comissões por Motorista (Mês)

```sql
SELECT 
    dm.nome AS [Motorista],
    YEAR(dd.data_calendario) AS [Ano],
    MONTH(dd.data_calendario) AS [Mês],
    SUM(fd.valor_comissao) AS [Total Comissão],
    COUNT(DISTINCT fd.desempenho_key) AS [Número de Viagens]
FROM fact_desempenho_motorista fd
JOIN dim_motoristas dm ON fd.motorista_key = dm.motorista_key
JOIN dim_datas dd ON fd.data_key = dd.data_key
WHERE dm.is_current = 1
GROUP BY dm.motorista_key, dm.nome, YEAR(dd.data_calendario), MONTH(dd.data_calendario)
ORDER BY YEAR(dd.data_calendario) DESC, MONTH(dd.data_calendario) DESC;
```

### Query 2: Horas Extras por Motorista

```sql
SELECT 
    dm.nome AS [Motorista],
    SUM(fd.horas_extra) AS [Total Horas Extra],
    SUM(fd.horas_extra * 50) AS [Valor Aproximado 50%],
    COUNT(*) AS [Ocorrências]
FROM fact_desempenho_motorista fd
JOIN dim_motoristas dm ON fd.motorista_key = dm.motorista_key
WHERE YEAR(DATEFROMPARTS(dd.ano, dd.mes, 1)) = YEAR(GETDATE())
GROUP BY dm.motorista_key, dm.nome
HAVING SUM(fd.horas_extra) > 0
ORDER BY SUM(fd.horas_extra) DESC;
```

### Query 3: Desempenho Operacional

```sql
SELECT 
    dm.nome AS [Motorista],
    COUNT(*) AS [Total Viagens],
    SUM(fd.distancia_km) AS [KM Total],
    SUM(fd.valor_frete) AS [Valor Fretes],
    ROUND(SUM(fd.valor_frete) / COUNT(*), 2) AS [Valor Médio/Viagem],
    ROUND(SUM(fd.horas_trabalho) / COUNT(*), 2) AS [Horas Médias],
    ROUND(SUM(fd.valor_comissao), 2) AS [Total Comissão]
FROM fact_desempenho_motorista fd
JOIN dim_motoristas dm ON fd.motorista_key = dm.motorista_key
WHERE dm.is_current = 1
GROUP BY dm.motorista_key, dm.nome
ORDER BY SUM(fd.valor_frete) DESC;
```

## 6️⃣ Checklist de Implementação

- [ ] Executar script de exploração (`01_exploracao_banco_completa.sql`)
- [ ] Analisar estrutura de dados descoberta
- [ ] Criar banco de dados para Data Warehouse
- [ ] Criar tabelas de dimensão
- [ ] Criar tabelas de fato
- [ ] Implementar ETL (extração de OLTP para OLAP)
- [ ] Testar queries analíticas
- [ ] Criar índices estratégicos
- [ ] Documentar estrutura final
- [ ] Preparar para visualizações (Power BI, Tableau, etc.)

## 📚 Referências

- [Dimensional Modeling - Ralph Kimball](https://en.wikipedia.org/wiki/Dimensional_modeling)
- [Data Warehouse Architecture](https://learn.microsoft.com/pt-br/sql/relational-databases/views/views)
- [Slowly Changing Dimensions - Microsoft](https://learn.microsoft.com/pt-br/sql/integration-services/data-flow/slowly-changing-dimension)

---

**Versão:** 1.0  
**Última Atualização:** Dezembro 2025
