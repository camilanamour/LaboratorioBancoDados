-- Produto (Codigo | Nome | Valor)
-- Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos:
-- (Codigo_Transacao | Codigo_Produto | Quantidade | Valor_Total)

CREATE DATABASE produto_db
GO
USE produto_db

CREATE TABLE produto(
idProduto INT NOT NULL,
nome VARCHAR(100),
valor DECIMAL(7,2)
PRIMARY KEY(idProduto)
)
GO
CREATE TABLE entrada(
idTransacao INT NOT NULL,
idProduto INT NOT NULL,
quantidade INT,
valor_total DECIMAL(7,2)
PRIMARY KEY(idTransacao)
FOREIGN KEY (idProduto) REFERENCES produto(idProduto))
GO
CREATE TABLE saida(
idTransacao INT NOT NULL,
idProduto INT NOT NULL,
quantidade INT,
valor_total DECIMAL(7,2)
PRIMARY KEY(idTransacao)
FOREIGN KEY (idProduto) REFERENCES produto(idProduto))

SELECT * FROM produto
SELECT * FROM entrada
SELECT * FROM saida

-- Cada produto que a empresa compra, entra na tabela ENTRADA. Cada produto que a empresa vende, entra na tabela SAIDA.
-- Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA), criar uma exceção de erro para código inválido,
-- receba o codigo_transacao, codigo_produto e a quantidade e preencha a tabela correta, com o valor_total de cada transação de cada produto.

INSERT INTO produto VALUES
(1,'Caderno Rosa',12.50), 
(2,'Caderno Azul',11.00),
(3,'Caderno Amarelo',10.50),
(4,'Caderno Roxo',13.50)


CREATE PROCEDURE sp_inseri_produto (@tabela VARCHAR(1), @idTransacao INT, @idProduto INT, @quantidade INT, @saida VARCHAR(40) OUTPUT)
AS
DECLARE @query VARCHAR(MAX), @valor_total DECIMAL(7,2), @valor DECIMAL(7,2), @erro VARCHAR(MAX)
SELECT @valor = valor FROM produto WHERE idProduto = @idProduto
SET @valor_total = @quantidade * @valor

BEGIN TRY
IF(UPPER(@tabela) = 'E')
BEGIN
SET @query = 'INSERT INTO entrada VALUES ('+ CAST(@idTransacao AS VARCHAR(5))+','+ CAST(@idProduto AS VARCHAR(5))+','+
CAST(@quantidade AS VARCHAR(5))+','+CAST(@valor_total AS VARCHAR(9))+')'
EXEC(@query)
SET @saida = 'Compra realizada com sucesso'
END
ELSE
BEGIN
IF(UPPER(@tabela) = 'S')
BEGIN
SET @query = 'INSERT INTO saida VALUES ('+ CAST(@idTransacao AS VARCHAR(5))+','+ CAST(@idpRODUTO AS VARCHAR(5))+','+
CAST(@quantidade AS VARCHAR(5))+','+CAST(@valor_total AS VARCHAR(5))+')'
EXEC(@query)
SET @saida = 'Venda realizada com sucesso'
END
ELSE
BEGIN
RAISERROR('Código inválido.',16,1)
END
END
END TRY
BEGIN CATCH
SET @erro = ERROR_MESSAGE()
RAISERROR(@erro, 16,1)
END CATCH

DECLARE @saida1 VARCHAR(40)
EXEC sp_inseri_produto 'e',1001,1,30,@saida1 OUTPUT
PRINT @saida1

DECLARE @saida2 VARCHAR(40)
EXEC sp_inseri_produto 's',101,1,3,@saida2 OUTPUT
PRINT @saida2