# SQL Server Database Exploration and Dimensional Modeling

Scripts and guides for exploring SQL Server databases and implementing dimensional modeling (Data Warehouse) for truck driver management systems.

## 📁 Project Structure

```
├── 01_exploracao_banco_completa.sql      # Complete database exploration script
├── README.md                              # Usage guide and quick reference
├── MODELAGEM_DIMENSIONAL.md               # Step-by-step dimensional modeling guide
├── .gitignore                             # Git ignore rules
└── LICENSE                                # Project license
```

## 🎯 Quick Start

1. Open SQL Server Management Studio (SSMS)
2. Open `01_exploracao_banco_completa.sql`
3. Execute (F5)
4. Review results in Messages and Results tabs

## 📊 What This Project Includes

### Script 01 - Complete Database Exploration
- Lists all schemas and tables
- Shows table structures (columns, data types)
- Displays primary keys and foreign keys
- Shows record counts per table
- Extracts sample data (10 rows) from each table
- Lists all indexes

### Documentation - Dimensional Modeling
- Step-by-step guide to create a Data Warehouse
- Dimension table designs
- Fact table designs
- SQL examples
- Common analytical queries

## 🚀 Use Cases

Perfect for:
- ✅ Discovering unknown database structures
- ✅ Planning data warehouse migrations
- ✅ Creating dimensional models
- ✅ Business intelligence projects
- ✅ Data analysis and reporting

## 📋 Typical Tables Explored

For truck driver management systems:
- Drivers / Motoristas
- Trucks / Caminhões
- Trips / Viagens
- Working Hours / Horas Trabalhadas
- Overtime / Horas Extras
- Commissions / Comissões
- Payroll / Folha de Pagamento

## 🔧 Requirements

- SQL Server 2012 or later
- SQL Server Management Studio (SSMS)
- Read access to target database
- Administrative privileges for schema viewing

## 📖 Documentation

- **README.md** - Usage guide and output examples
- **MODELAGEM_DIMENSIONAL.md** - Complete dimensional modeling guide with SQL examples

## ⚙️ Features

- ✅ **Generic** - Works with any SQL Server database
- ✅ **Read-only** - No data modifications
- ✅ **Comprehensive** - Covers metadata and sample data
- ✅ **Easy to use** - Single script execution
- ✅ **Customizable** - Can comment out sections as needed

## 💡 Next Steps

After exploration:
1. Analyze discovered schema
2. Create dimension tables
3. Create fact tables
4. Build ETL processes
5. Create analytical views
6. Connect to BI tools (Power BI, Tableau, Qlik)

## 📝 Notes

- Script execution may take time with large databases
- Consider commenting out section 8 (sample data) for databases with many tables
- Script is non-intrusive and doesn't modify any data
- All results are displayed in SSMS results window

## 🤝 Contributing

Feel free to fork, modify, and share improvements.

## 📄 License

This project is open for use, modification, and distribution.

## 📞 Support

- Check SSMS connection before running
- Verify database access permissions
- Run as administrator if needed
- Review T-SQL syntax for your SQL Server version

---

**Version:** 1.0  
**Created:** December 2025  
**Language:** T-SQL (SQL Server)  
**Purpose:** Database Exploration & Dimensional Modeling
