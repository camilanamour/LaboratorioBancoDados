CREATE DATABASE db_cliente
GO
USE db_cliente
GO
CREATE TABLE Cliente(
cpf	CHAR(11)	NOT NULL,
nome	VARCHAR(100)	NOT NULL,
email	VARCHAR(200)	NOT NULL,
limite_de_credito	DECIMAL(7,2)	NOT NULL,
dt_nascimento	DATE	NOT NULL
PRIMARY KEY(cpf)
)

-- o CPF deve ser válido
CREATE PROCEDURE sp_valida_cpf_verificadores(@cpf CHAR(11), @valido_cpf BIT OUTPUT)
AS
	DECLARE @verifica VARCHAR(10),  @soma INT, @conta INT, @resto INT, @digito INT
	DECLARE @cont INT, @pos INT, @qtde_verifica INT, @vezes INT

	SET @verifica = SUBSTRING(@cpf, 1, 9) 
	SET @qtde_verifica= 10
	SET @vezes = 0

	WHILE(@vezes < 2)
	BEGIN
		SET @cont = @qtde_verifica
		SET @pos = 1
		SET @soma = 0

		WHILE(@cont > 1)
		BEGIN
			SET @conta = CAST(SUBSTRING(@verifica, @pos, 1) AS INT) * @cont
			SET @soma = @soma + @conta
			SET @pos = @pos + 1
			SET @cont = @cont - 1
		END

		SET @resto = @soma % 11

		IF(@resto < 2)
		BEGIN 
			SET @digito = 0
		END
		ELSE
		BEGIN
			SET @digito = 11 - @resto
		END

		IF(@digito = SUBSTRING(@cpf, @qtde_verifica, 1))
		BEGIN
			SET @qtde_verifica = @qtde_verifica + 1
			SET @valido_cpf = 1
			SET @verifica = @verifica + CAST(@digito AS VARCHAR)
			
		END
		ELSE
		BEGIN
			SET @valido_cpf = 0
			BREAK
		END
		SET @vezes = @vezes + 1
	END


-- o CPF não pode ser 11 números repetidos (11111111111, 22222222222, etc)
CREATE PROCEDURE sp_valida_cpf(@cpf CHAR(11), @valido_cpf BIT OUTPUT)
AS
	DECLARE @parte_um CHAR(5), @parte_dois CHAR(5)
	SET @parte_um = SUBSTRING(@cpf, 1, 5)
	SET @parte_dois = SUBSTRING(@cpf, 6, 5)
	IF(@parte_um != @parte_dois)
	BEGIN
		EXEC sp_valida_cpf_verificadores @cpf, @valido_cpf OUTPUT
	END
	ELSE
	BEGIN
		SET @valido_cpf = 0
	END


-- INSERT, UPDATE AND DELETE (@op ==> I, U OU D)
CREATE PROCEDURE sp_cliente (@op CHAR(1), @cpf CHAR(11), @nome VARCHAR(100), @email VARCHAR(200), 
							@limite_de_credito DECIMAL(7,2), @dt_nascimento DATE,
							@saida VARCHAR(40) OUTPUT)
AS
	DECLARE @valido_cpf BIT
	IF(@cpf IS NULL)
	BEGIN
			RAISERROR('CPF não pode ser nulo', 16, 1)
	END
	ELSE
	BEGIN
		IF(UPPER(@op) = 'D' AND @cpf IS NOT NULL)
		BEGIN
			DELETE cliente WHERE cpf = @cpf
			SET @saida = 'Cliente deletado com sucesso'
		END
		ELSE
		BEGIN
			IF (UPPER(@op) = 'U' AND @cpf IS NOT NULL)
			BEGIN
				UPDATE cliente SET nome = @nome, email = @email, 
				limite_de_credito = @limite_de_credito, dt_nascimento = @dt_nascimento
				WHERE cpf = @cpf
				SET @saida = 'Cliente alterado com sucesso'
			END
			ELSE
			BEGIN
				IF (UPPER(@op) = 'I' AND @cpf IS NOT NULL)
				BEGIN
					EXEC sp_valida_cpf @cpf, @valido_cpf OUTPUT
					IF(@valido_cpf = 1)
					BEGIN
						INSERT INTO cliente VALUES (@cpf, @nome, @email, @limite_de_credito, @dt_nascimento)
						SET @saida = 'Cliente inserido com sucesso'
					END
					ELSE
					BEGIN
						RAISERROR ('CPF inválido', 16,1)
					END
				END
				ELSE
				BEGIN
					RAISERROR ('Opção inválida', 16,1)
				END
			END
		END
	END

	SELECT * FROM cliente

	-- DECLARE @out VARCHAR(40)
	-- EXEC sp_cliente 'd', '22233366638', 'CAMILA', '@', 3.5, '2012-08-21', @out OUTPUT
	-- PRINT @out

