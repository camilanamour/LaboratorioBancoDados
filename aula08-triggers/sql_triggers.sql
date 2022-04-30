/*
Tabela Cliente (Codigo | Nome)
Tabela Venda (Codigo_Venda | Codigo_Cliente | Valor_Total)
Tabela Pontos (Codigo_Cliente | Total_Pontos)
*/

CREATE DATABASE bd_triggers
GO
USE bd_triggers

CREATE TABLE cliente(
codigo INT,
nome VARCHAR(80)
PRIMARY KEY(codigo)
)
GO
CREATE TABLE venda(
codigo_venda INT,
codigo_cliente INT,
valor_total DECIMAL(7,2)
PRIMARY KEY(codigo_venda),
FOREIGN KEY(codigo_cliente) REFERENCES cliente(codigo)
)
GO
CREATE TABLE pontos(
codigo_cliente INT,
total_pontos DECIMAL(7,2)
PRIMARY KEY(codigo_cliente),
FOREIGN KEY(codigo_cliente) REFERENCES cliente(codigo)
)

INSERT INTO cliente VALUES
(1,'Fulano')

INSERT INTO venda VALUES (01,1,25.00)

SELECT * FROM venda
SELECT * FROM pontos

/*
- Uma empresa vende produtos aliment�cios
- A empresa d� pontos, para seus clientes, que podem ser revertidos em pr�mios
*/

-- Para n�o prejudicar a tabela venda, nenhum produto pode ser deletado, mesmo que n�o venha mais a ser vendido
CREATE TRIGGER t_delete ON venda
AFTER DELETE
AS
BEGIN
	-- ROLLBACK TRANSACTION --Desfaz o �ltimo comando DML
	RAISERROR('N�o � permitido deletar vendas', 16, 1)
END

-- Para n�o prejudicar os relat�rios e a contabilidade, a tabela venda n�o pode ser alterada.
-- Ao inv�s de alterar a tabela venda deve-se exibir uma tabela com o nome do �ltimo cliente que comprou e o valor da �ltima compra
CREATE TRIGGER t_alterar ON venda
INSTEAD OF UPDATE
	AS
	BEGIN
		DECLARE @id INT

		SELECT @id= max(codigo_venda) FROM venda

		SELECT c.nome, v.valor_total
		FROM cliente c, venda v
		WHERE c.codigo = v.codigo_cliente
			AND v.codigo_venda = @id
END

UPDATE venda
SET valor_total = 12
WHERE codigo_venda = 1

-- Ap�s a inser��o de cada linha na tabela venda, 10% do total dever� ser transformado em pontos.
-- Se o cliente ainda n�o estiver na tabela de pontos, deve ser inserido automaticamente ap�s sua primeira compra
-- Se o cliente atingir 1 ponto, deve receber uma mensagem dizendo que ganhou
CREATE TRIGGER t_inserir_pontos ON venda
AFTER INSERT
	AS
	BEGIN
		DECLARE @id INT, @valor DECIMAL(7,2), @pontos DECIMAL(7,2)

		SELECT @id = codigo_cliente, @valor = valor_total FROM venda

		SELECT @pontos = total_pontos FROM pontos WHERE codigo_cliente = @id

		IF(@pontos IS NULL)
		BEGIN
			SET @pontos = (@valor * 10) / 100
		END
		ELSE
		BEGIN
			SET @pontos = @pontos + ((@valor * 10) / 100)
		END
		INSERT INTO pontos VALUES (@id, @pontos)

		IF(@pontos >= 100)
		BEGIN
			PRINT 'Voc� ganhou'
		END
END