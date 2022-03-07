CREATE DATABASE db_loja_web
GO
USE db_loja_web

CREATE TABLE marca(
id	INT	NOT NULL,
nome	VARCHAR(50)	NOT NULL
PRIMARY KEY(id)
)
GO
CREATE TABLE produto(
id	INT	NOT NULL,
nome	VARCHAR(50)	NOT NULL,
preco	DECIMAL(7,2)	NOT NULL,
id_marca	INT	NOT NULL
PRIMARY KEY(id),
FOREIGN KEY(id_marca) REFERENCES marca(id)
)

SELECT * FROM marca
SELECT * FROM produto