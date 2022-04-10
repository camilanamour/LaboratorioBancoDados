CREATE DATABASE bd_ponto_pedido
GO
USE bd_ponto_pedido

CREATE TABLE Produtos(
codigo			INT				NOT NULL,
nome			VARCHAR(80)		NOT NULL,
valor_unitario	DECIMAL(7,2)	NOT NULL,
qtd_estoque		INT				NOT NULL
PRIMARY KEY(codigo)
)
GO
INSERT INTO Produtos VALUES
(1,'Caderno',12.50,3),
(2,'Lápis',3.50,10),
(3,'Borracha',2.0,5),
(4,'Apontador',2.5,15),
(5,'Estojo',10.0,5)

-- Scalar Function
-- a)Fazer uma Function que verifique, na tabela produtos (codigo, nome, valor unitário e qtd estoque)
-- Quantos produtos estão com estoque abaixo de um valor de entrada
CREATE FUNCTION fn_qtd_baixo_valor()
	RETURNS INT
	AS
	BEGIN
		DECLARE @soma INT
		SELECT	@soma = COUNT(qtd_estoque) FROM Produtos WHERE qtd_estoque < 10
		RETURN(@soma)
	END

	SELECT dbo.qtd_baixo_valor() AS Soma

-- b)Fazer uma function que liste o código, o nome e a quantidade dos produtos que estão com o estoque 
-- abaixo de um valor de entrada

-- Multi Statement Table
CREATE FUNCTION fn_listar()
RETURNS @tabela TABLE(
	codigo INT,
	nome VARCHAR(80),
	qtd_estoque INT
)
AS
BEGIN
	INSERT INTO @tabela (codigo, nome, qtd_estoque) 
	SELECT codigo, nome, qtd_estoque FROM Produtos 
	WHERE qtd_estoque < 10
	RETURN
END

SELECT * FROM fn_listar()