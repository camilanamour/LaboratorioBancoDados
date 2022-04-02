CREATE DATABASE bd_campeonato_paulista
GO
USE bd_campeonato_paulista

CREATE TABLE times(
codTime	INT	NOT NULL,
nomeTime	VARCHAR(25)	NOT NULL,
cidade	VARCHAR(25)	NOT NULL,
estadio VARCHAR(30)	NOT NULL,
flag_especial	BIT	NOT NULL,
flag_alocada	BIT	NOT NULL
PRIMARY KEY(codTime)
)
GO
CREATE TABLE grupos(
codGrupo INT NOT NULL,
codTime INT	NOT NULL,
grupo	CHAR(1)	NOT NULL	CHECK(grupo = 'A' OR grupo = 'B' OR grupo = 'C' OR grupo = 'D')
PRIMARY KEY(codGrupo)
FOREIGN KEY(codTime) REFERENCES times(codTime)
)
GO
CREATE TABLE jogos(
codJogo		INT		NOT NULL,
codTimeA	INT		NOT NULL,
codTimeB	INT		NOT NULL,
golsTimeA	INT		NULL,
golsTimeB	INT		NULL,
data_jogo	DATE	NULL,
rodada		INT		NULL,
flag_jogou	BIT		NULL
PRIMARY KEY(codJogo)
FOREIGN KEY(codTimeA) REFERENCES times(codTime),
FOREIGN KEY(codTimeB) REFERENCES times(codTime)
)
GO
INSERT INTO times VALUES
(1,'Botafogo-SP','Ribeirão Preto','Santa Cruz', 0, 0),
(2,'Corinthians','São Paulo','Neo Quimica Arena', 1, 0),
(3,'Ferroviária','Araraquara','Fonte Luminosa', 0, 0),
(4,'Guarani','Campinas','Brinco de ouro', 0, 0),
(5,'Inter de Limeira','Limeira','Limeirão', 0, 0),
(6,'Ituano','Itu','Novelli Júnior', 0, 0),
(7,'Mirassol','Mirassol','José Maria de Campos Maia', 0, 0),
(8,'Novorizontino','Novo Horizonte','Jorge Ismael de Biasi', 0, 0),
(9,'Palmeiras','São Paulo','Allianz Parque', 1, 0),
(10,'Ponte Preta','Capinas','Moisés Lucarelli', 0, 0),
(11,'Red Bull Bragantino','Bragança Paulista','Nabi Abi Chedid', 0, 0),
(12,'Santo André','Santo André','Bruno José Daniel', 0, 0),
(13,'Santos','Santos','Vila Belmiro', 1, 0),
(14,'São Bento','Sorocaba','Walter Ribeiro', 0, 0),
(15,'São Caetano','São Caetano do sul','Anacietto Campanella', 0, 0),
(16,'São Paulo','São Paulo','Morumbi', 1, 0)

GO
-- DIVIDIR TIMES POR GRUPOS
CREATE PROCEDURE sp_divide_times(@saida VARCHAR(50) OUTPUT)
	AS
		DELETE grupos 
		DECLARE @grp CHAR(1), @grupos CHAR(4), @cont_grupos INT, @time_especial BIT
		DECLARE @qtd_times INT, @cod_random INT, @valida BIT, @ok BIT, @especial BIT, @id_grupo INT

		SET @grupos = 'ABCD'
		SET @cont_grupos = 1
		SET @id_grupo = 1
		
		WHILE(@cont_grupos < 5)
		BEGIN
			SET @grp = SUBSTRING(@grupos,@cont_grupos,1)
			SET @time_especial = 0
			SET @qtd_times = 1
			WHILE (@qtd_times <= 4)
			BEGIN
				SET @ok = 0 
				WHILE(@ok = 0)
				BEGIN
					IF(@qtd_times = 4 AND @time_especial = 0)
					BEGIN
						WHILE(@time_especial = 0)
						BEGIN
							SET @cod_random = CAST(FLOOR(RAND()*(16-1+1)+1) AS INT)
							SELECT @valida = flag_alocada, @especial = flag_especial FROM times WHERE codTime = @cod_random
							IF(@valida = 0 AND @especial = 1 AND @time_especial = 0)
							BEGIN
								INSERT INTO grupos VALUES (@id_grupo, @cod_random,@grp)
								SET @id_grupo = @id_grupo + 1
								UPDATE times SET flag_alocada = 1 WHERE codTime = @cod_random
								SET @time_especial = 1
								SET @ok = 1
							END
						END
					END
					IF(@ok = 0)
					BEGIN
						SET @cod_random = CAST(FLOOR(RAND()*(16-1+1)+1) AS INT)
						SELECT @valida = flag_alocada, @especial = flag_especial FROM times WHERE codTime = @cod_random
						IF(@valida = 0 AND @especial = 0)
						BEGIN
							INSERT INTO grupos VALUES (@id_grupo, @cod_random, @grp)
							SET @id_grupo = @id_grupo + 1
							UPDATE times SET flag_alocada = 1 WHERE codTime = @cod_random
							SET @ok = 1
						END
						ELSE
						BEGIN
							IF(@valida = 0 AND @especial = 1 AND @time_especial = 0)
							BEGIN
								INSERT INTO grupos VALUES (@id_grupo, @cod_random, @grp)
								SET @id_grupo = @id_grupo + 1
								UPDATE times SET flag_alocada = 1 WHERE codTime = @cod_random
								SET @time_especial = 1
								SET @ok = 1
							END
						END
					END
				END
				SET @qtd_times = @qtd_times + 1
			END
			SET @cont_grupos = @cont_grupos + 1
		END
		UPDATE times SET flag_alocada = 0 -- Reseta alocação
		SET @saida = 'Times alocados com sucesso'
			
GO
-- PARTIDAS (Um jogo não pode ocorrer 2 vezes, mesmo em rodadas diferentes)
CREATE PROCEDURE sp_partidas (@saida VARCHAR(40) OUTPUT)
	AS
		DECLARE @contador INT, @qtd INT, @qtdTimes INT, @cont INT, @cont_grp INT, @cod_time_p INT, @cod_time_s INT, @pos INT
		
		-- GRUPO A --> começa 1; pula 4 = 5; até o final (16)
		-- GRUPO C --> começa 5; pula 4 = 9; até o final (16)
		-- GRUPO C --> começa 9; pula 4 = 13; até o final (16)

		DELETE jogos
		SET @pos = 1
		SET @contador = 1
		WHILE (@contador <= 3)
		BEGIN
			IF(@contador = 1) -- GRUPO A contra B, C, D
			BEGIN SET @cont_grp = 1
			END
			IF(@contador = 2) -- GRUPO B contra C, D
			BEGIN SET @cont_grp = 5
			END
			IF(@contador = 3) -- GRUPO C contra D
			BEGIN SET @cont_grp = 9
			END

			SET @qtdTimes = 1
			WHILE(@qtdTimes <= 4)
			BEGIN
				SET @qtd = 4 * @contador	
			
				WHILE (@cont_grp <= @qtd)
				BEGIN
					IF(@contador = 1)
					BEGIN SET @cont = 5
					END
					IF(@contador = 2)
					BEGIN SET @cont = 9
					END
					IF(@contador = 3)
					BEGIN SET @cont = 13
					END
					SELECT @cod_time_p=codTime FROM grupos WHERE codGrupo=@cont_grp
					
					-- Outros grupos
					WHILE(@cont <= 16)
					BEGIN
						SELECT @cod_time_s=codTime FROM grupos WHERE codGrupo=@cont
						INSERT INTO jogos (codJogo, codTimeA, codTimeB, flag_jogou) VALUES (@pos, @cod_time_p, @cod_time_s, 0)
						SET @pos = @pos + 1
						SET @cont = @cont + 1
					END
					SET @cont_grp = @cont_grp + 1
				END
				SET @qtdTimes = @qtdTimes + 1
			END
			SET @contador = @contador + 1
		END	
		EXEC sp_datas @saida OUTPUT

GO	
-- DATAS RODADAS (separar rodadas)
CREATE PROCEDURE sp_datas (@saida VARCHAR(40) OUTPUT)
AS
		DECLARE @semanas INT, @dt_inicio_dom DATE, @dt_inicio_qua DATE, @dt_time_dom DATETIME, @dt_time_quarta DATETIME
		DECLARE @datas TABLE (codData INT IDENTITY(1,1), dt_rodada_dom DATE, dt_rodada_quarta DATE)

		DECLARE @random_pos INT, @data_rodada DATE, @rodadas INT, @jogos INT, @ok BIT
		DECLARE @timeA INT, @timeB INT, @flag_jogou BIT, @flag_A BIT, @flag_B BIT

		SET @semanas = 1
		SET @dt_inicio_dom = '2021-02-21'
		SET @dt_inicio_qua = '2021-02-24'
		WHILE (@semanas <= 12)
		BEGIN
			    -- Domingo e Quarta
				SET @dt_time_dom = @dt_inicio_dom 
				SET @dt_time_quarta = @dt_inicio_qua
				INSERT INTO @datas (dt_rodada_dom, dt_rodada_quarta)
				SELECT CONVERT(DATE, DATEADD(WEEK, @semanas, @dt_time_dom)), CONVERT(DATE, DATEADD(WEEK, @semanas, @dt_time_quarta))
				SET @semanas = @semanas + 1
		END

		SET @rodadas = 1
		WHILE(@rodadas<=12) -- 12 semanas
		BEGIN		
			SET @jogos = 1
			WHILE(@jogos <= 8) -- 8 jogos por semana
			BEGIN
				-- dia da semana
				IF(@jogos % 2 = 0) 
				BEGIN
					SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = @rodadas
				END
				ELSE
				BEGIN 
					SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = @rodadas
				END
				SET @ok = 0
				-- Rodadas
				WHILE(@ok = 0)
				BEGIN
					SET @random_pos = CAST(FLOOR(RAND()*(96-1+1)+1) AS INT)
					SELECT @timeA = codTimeA, @timeB = codTimeB, @flag_jogou = flag_jogou FROM jogos WHERE codJogo = @random_pos
					IF(@flag_jogou = 0)
					BEGIN
						UPDATE jogos 
						SET data_jogo = @data_rodada, flag_jogou = 1, rodada = @rodadas, golsTimeA = CAST(FLOOR(RAND()*(5-1+1)+1) AS INT),	
						golsTimeB = CAST(FLOOR(RAND()*(5-1+1)+1) AS INT) WHERE codJogo = @random_pos
						SET @ok = 1
					END
				END
			SET @jogos = @jogos + 1
			END
			SET @rodadas = @rodadas + 1
		END
		UPDATE jogos SET flag_jogou = 0 
		SET @saida = 'Partidas Geradas com Sucesso' 

-- TESTES
DECLARE @saida_teste VARCHAR(40)
EXEC sp_divide_times @saida_teste OUTPUT
PRINT @saida_teste

SELECT g.codTime, t.nomeTime, g.grupo FROM grupos g, times t WHERE g.codTime = t.codTime ORDER BY grupo

DECLARE @saida VARCHAR(40)
EXEC sp_partidas @saida OUTPUT
PRINT @saida

SELECT t1.nomeTime As timeA, t2.nomeTime timeB, j.golsTimeA, j.golsTimeB, j.data_jogo 
FROM jogos j, times t1, times t2 
WHERE t1.codTime = j.codTimeA
	AND t2.codTime = j.codTimeB
	AND j.rodada = 1
ORDER BY j.data_jogo

SELECT rodada 
FROM jogos
WHERE data_jogo = '2021-02-28'

SELECT * FROM times
SELECT * FROM jogos ORDER BY data_jogo
SELECT * FROM jogos ORDER BY codJogo
SELECT * FROM grupos
