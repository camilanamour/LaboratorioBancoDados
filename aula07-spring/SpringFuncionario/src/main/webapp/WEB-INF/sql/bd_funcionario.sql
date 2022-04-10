CREATE DATABASE bd_funcionario
GO
USE bd_funcionario

CREATE TABLE funcionario(
codigo			INT				NOT NULL,
nome			VARCHAR(80)		NOT NULL,
salario			DECIMAL(7,2)	NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE dependente(
codigo			INT				NOT NULL,
nome			VARCHAR(80)		NOT NULL,
salario			DECIMAL(7,2)	NOT NULL,
codigo_funcionario	INT			NOT NULL
PRIMARY KEY(codigo),
FOREIGN KEY(codigo_funcionario) REFERENCES funcionario(codigo)
)
GO
SELECT * FROM funcionario
SELECT * FROM dependente

INSERT INTO funcionario VALUES
(1,'Fulano',2000.00),
(2,'Ciclano',4000.00)
GO
INSERT INTO dependente VALUES
(001,'Fulano 1',1000.00, 1),
(002,'Fulano 2',1000.00, 1),
(003,'Ciclano 1',2000.00, 2),
(004,'Ciclano 2',2000.00, 2)

-- a) Uma Function que Retorne uma tabela: (Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)
CREATE FUNCTION fn_listar()
RETURNS @tabela TABLE(
	codigo INT,
	nome VARCHAR(80),
	nome_dependente VARCHAR(80),
	salario DECIMAL(7,2),
	salario_dependente DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @tabela (codigo, nome, nome_dependente, salario, salario_dependente) 
	SELECT d.codigo, f.nome, d.nome AS dependente, f.salario, d.salario AS sal_dependente
	FROM funcionario f, dependente d
	WHERE f.codigo = d.codigo_funcionario
	ORDER BY d.codigo_funcionario
	RETURN
END

SELECT codigo, nome, nome_dependente, salario, salario_dependente FROM fn_listar()

-- b) Uma Scalar Function que Retorne a soma dos salários dos dependentes, mais a do funcionário.
CREATE FUNCTION fn_soma_salarios(@funcionario INT)
	RETURNS DECIMAL (7,2)
	AS
	BEGIN
		DECLARE @soma DECIMAL(7,2), @salarios DECIMAL(7,2)
		SELECT @soma = salario FROM funcionario WHERE codigo = @funcionario
		SELECT @salarios = SUM(salario) FROM Dependente WHERE codigo_funcionario = @funcionario
		SET @soma = @soma + @salarios
		RETURN (@soma)
	END

	SELECT dbo.fn_soma_salarios(1) AS Soma
	SELECT dbo.fn_soma_salarios(2) AS Soma

