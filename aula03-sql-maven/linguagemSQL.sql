-- a) Fazer um algoritmo que leia 1 número e mostre se são múltiplos de 2,3,5 ou nenhum deles
DECLARE @num INT
SET @num = 17
IF (@num % 2 = 0)
	BEGIN
		PRINT 'É múltiplo de 2'
END
IF (@num % 3 = 0)
	BEGIN
		PRINT 'É múltiplo de 3'
END
IF (@num % 5 = 0)
	BEGIN
		PRINT 'É múltiplo de 5'
END
IF (@num % 2 > 0 AND  @num % 3 > 0 AND @num % 5 > 0)
	BEGIN
		PRINT 'Não é múltiplo de 2, 3 e 5'
END

-- b)  Fazer um algoritmo que leia 3 número e mostre o maior e o menor
DECLARE @num1 INT,
		@num2 INT,
		@num3 INT, 
		@auxmin INT, 
		@auxmax INT

SET @num1 = 5
SET @num2 = 10
SET @num3 = 4
SET @auxmin = @num1
SET @auxmax= @num1

IF(@auxmin > @num2)
	BEGIN
		SET @auxmin = @num2
END
IF(@auxmin > @num3)
	BEGIN
		SET @auxmin = @num3
END
IF(@auxmax < @num2)
	BEGIN
		SET @auxmax = @num2
END
IF(@auxmax < @num3)
	BEGIN
		SET @auxmax = @num3
END
PRINT 'Menor = ' + CAST(@auxmin AS VARCHAR)
PRINT 'Maior = ' + CAST(@auxmax AS VARCHAR)

-- c) Fazer um algoritmo que calcule os 15 primeiros termos da série 1,1,2,3,5,8,13,21,... E calcule a soma dos 15 termos
DECLARE @vtnum TABLE(nome VARCHAR(4), valor INT)
DECLARE @cont INT, @aux INT, @n INT, @soma INT, @resultado INT

SET @cont = 0
SET @aux = 0
SET @n = 0
SET @soma = 0

WHILE(@cont <= 15)
	BEGIN
		IF(@n = 0)
			BEGIN
			SET @n = @n + 1
			SET @resultado = @n
		END
		ELSE
			BEGIN
			IF(@n = 1 AND @aux = 0)
				BEGIN
				SET @aux = @n
				SET @resultado = @n
			END
			ELSE
				BEGIN
				IF(@n > 0)
					BEGIN
					SET @resultado = @n + @aux
					SET @aux = @n
					SET @n = @resultado
				END
			END
		END
		IF(@cont = 15)
			BEGIN
			INSERT INTO @vtnum VALUES('Soma', @soma)
		END
		ELSE
			BEGIN
			SET @soma = @soma + @resultado
			INSERT INTO @vtnum VALUES(CAST(@cont + 1 AS VARCHAR), @resultado)
		END
		SET @cont = @cont + 1
END

SELECT * FROM @vtnum
			

INSERT INTO @vtnum VALUES (1)

-- d) Fazer um algoritmo que separa uma frase, colocando todas as letras em maiúsculo e em minúsculo (Usar funções UPPER e LOWER)
DECLARE @frase VARCHAR(50), @palavra VARCHAR(50)
SET @frase = 'Olá mundo'

SELECT value AS palavra_upper FROM STRING_SPLIT(UPPER(@frase), ' ')
SELECT value AS palavra_lower FROM STRING_SPLIT(LOWER(@frase), ' ')
		
-- e) Fazer um algoritmo que inverta uma palavra (Usar a função SUBSTRING)
DECLARE @certo VARCHAR(50), @invertido VARCHAR(50), @contador INT
SET @certo = 'camila'
SET @invertido = ''
SET @contador = 50

WHILE (@contador > 0)
	BEGIN
	SET @invertido = @invertido + SUBSTRING(@certo, @contador, 1)
	SET @contador = @contador - 1
END
PRINT 'CERTO: ' + @certo
PRINT 'INVERTIDO: ' + @invertido
