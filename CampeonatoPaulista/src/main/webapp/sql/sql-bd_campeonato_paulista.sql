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
rodada		INT		NULL
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
		DELETE jogos
		-- 2 dia => 1 Rodada
		DECLARE @semanas INT, @dt_inicio_dom DATE, @dt_inicio_qua DATE, @dt_time_dom DATETIME, @dt_time_quarta DATETIME
		DECLARE @datas TABLE (codData INT IDENTITY(1,1), dt_rodada_dom DATE, dt_rodada_quarta DATE)

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

		DECLARE @data_rodada DATE, @jogos INT, @reparticao INT, @cod INT, @timeA INT, @timeB INT, @vez INT

		-- 1) Jogadas diretas				(A1 --> B1; A2 --> B2; A3 --> B3; A4 --> B4)
		-- 2) Jogadas diretas (+ 1)			(A1 --> B2; A2 --> B3; A3 --> B4; A4 --> B1)
		-- 3) Jogadas diretas (+ 2) E (- 2)	(A1 --> B3; A2 --> B4; A3 --> B1; A4 --> B2)
		-- 4) Jogadas diretas (- 1)			(A1 --> B4; A2 --> B1; A3 --> B2; A4 --> B3)

		SET @cod = 1
		SET @vez = 1

		WHILE(@vez <= 4)
		BEGIN
			SET @jogos = 1
			WHILE(@jogos<=4)
			BEGIN
				-- GRUPO A 
				SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos
				SET @reparticao = 0
				WHILE (@reparticao < 3) -- 3 Repartições (A contra B = 0); (A contra C = 1); (A contra D = 2) 
				BEGIN
					IF(@reparticao = 0)
					BEGIN
						IF(@vez = 1) -- Jogadas diretas
						BEGIN
							SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeB = codTime FROM grupos WHERE codGrupo = @jogos + 4 -- contra GRUPO B
						END
						IF(@vez = 2) -- Jogadas diretas + 1 
						BEGIN
							SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							IF(@jogos = 4)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = 5 -- contra GRUPO B (B1)
							END
							ELSE
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = @jogos + 5 -- contra GRUPO B (B2, B3, B4)
							END
						END
						IF(@vez = 3) -- Jogadas diretas (+ 2) E (- 2)
						BEGIN
							SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							IF(@jogos = 1 OR @jogos = 2)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 4) + 2 -- contra GRUPO B (B3, B4)
							END
							IF(@jogos = 3 OR @jogos = 4)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 4) - 2 -- contra GRUPO B (B1, B2)
							END
						END
						IF(@vez = 4) -- Jogadas diretas (- 1)
						BEGIN
							SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							IF(@jogos = 1)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 8) - 1 -- contra GRUPO B (B4)
							END
							ELSE
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 4) - 1 -- contra GRUPO B (B1, B2, B3)
							END
						END
					END
					IF(@reparticao = 1)
					BEGIN
						IF(@vez = 1) -- Jogadas diretas
						BEGIN
							SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeB = codTime FROM grupos WHERE codGrupo = @jogos + 8 -- contra GRUPO C
						END
						IF(@vez = 2) -- Jogadas diretas + 1 
						BEGIN
							SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							IF(@jogos = 4)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = 9 -- contra GRUPO C (C1)
							END
							ELSE
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = @jogos + 9 -- contra GRUPO C (C2, C3, C4)
							END
						END
						IF(@vez = 3) -- Jogadas diretas (+ 2) E (- 2)
						BEGIN
							SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							IF(@jogos = 1 OR @jogos = 2)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 8) + 2 -- contra GRUPO C (C3, C4)
							END
							IF(@jogos = 3 OR @jogos = 4)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 8) - 2 -- contra GRUPO C (C1, C2)
							END
						END
						IF(@vez = 4) -- Jogadas diretas (- 1)
						BEGIN
							SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							IF(@jogos = 1)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 12) - 1 -- contra GRUPO C (C4)
							END
							ELSE
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 8) - 1 -- contra GRUPO C (C1, C2, C3)
							END
						END
					END
					IF(@reparticao = 2)
					BEGIN
						IF(@vez = 1) -- Jogadas diretas
						BEGIN
							SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeB = codTime FROM grupos WHERE codGrupo = @jogos + 12 -- contra GRUPO D
						END
						IF(@vez = 2) -- Jogadas diretas + 1 
						BEGIN
							SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							IF(@jogos = 4)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = 13 -- contra GRUPO D (D1)
							END
							ELSE
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = @jogos + 13 -- contra GRUPO D (D2, D3, D4)
							END
						END
						IF(@vez = 3) -- Jogadas diretas (+ 2) E (- 2)
						BEGIN
							SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							IF(@jogos = 1 OR @jogos = 2)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 12) + 2 -- contra GRUPO D (D3, D4)
							END
							IF(@jogos = 3 OR @jogos = 4)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 12) - 2 -- contra GRUPO D (D1, D2)
							END
						END
						IF(@vez = 4) -- Jogadas diretas (- 1)
						BEGIN
							SELECT @data_rodada = dt_rodada_dom FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							IF(@jogos = 1)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 16) - 1 -- contra GRUPO D (D4)
							END
							ELSE
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 12) - 1 -- contra GRUPO D (D1, D2, D3)
							END
						END
					END
					INSERT INTO jogos (codJogo, codTimeA, codTimeB, golsTimeA, golsTimeB, data_jogo, rodada)
					VALUES (@cod, @timeA, @timeB, 0, 0, @data_rodada,(@reparticao * 4) + @vez)
					SET @cod = @cod + 1
					SET @reparticao = @reparticao + 1
				END
		
				-- GRUPO D
				SET @reparticao = 0
				WHILE (@reparticao < 3) -- 3 Repartições (D contra C = 0); (D contra B = 1); (C contra B = 2) 
				BEGIN
					SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + 1 -- RODADA
					IF(@reparticao = 0)
					BEGIN
						IF(@vez = 1) -- Jogadas diretas
						BEGIN
							SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos + 12 -- GRUPO D
							SELECT @timeB = codTime FROM grupos WHERE codGrupo = @jogos + 8 -- contra GRUPO C
						END
						IF(@vez = 2) -- Jogadas diretas + 1 
						BEGIN
							SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos + 12 -- GRUPO D
							IF(@jogos = 4)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = 9 -- contra GRUPO C (C1)
							END
							ELSE
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = @jogos + 9 -- contra GRUPO C (C2, C3, C4)
							END
						END
						IF(@vez = 3) -- Jogadas diretas (+ 2) E (- 2)
						BEGIN
							SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos + 12 -- GRUPO D
							IF(@jogos = 1 OR @jogos = 2)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 8) + 2 -- contra GRUPO C (C3, C4)
							END
							IF(@jogos = 3 OR @jogos = 4)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 8) - 2 -- contra GRUPO C (C1, C2)
							END
						END
						IF(@vez = 4) -- Jogadas diretas (- 1)
						BEGIN
							SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos + 12 -- GRUPO D
							IF(@jogos = 1)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 12) - 1 -- contra GRUPO C (C4)
							END
							ELSE
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 8) - 1 -- contra GRUPO C (C1, C2, C3)
							END
						END
					END
					IF(@reparticao = 1)
					BEGIN
						IF(@vez = 1) -- Jogadas diretas
						BEGIN
							SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos + 12 -- GRUPO D
							SELECT @timeB = codTime FROM grupos WHERE codGrupo = @jogos + 4 -- contra GRUPO B
						END
						IF(@vez = 2) -- Jogadas diretas + 1 
						BEGIN
							SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos + 12 -- GRUPO D
							IF(@jogos = 4)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = 5 -- contra GRUPO B (B1)
							END
							ELSE
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = @jogos + 5 -- contra GRUPO B (B2, B3, B4)
							END
						END
						IF(@vez = 3) -- Jogadas diretas (+ 2) E (- 2)
						BEGIN
							SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos + 12 -- GRUPO D
							IF(@jogos = 1 OR @jogos = 2)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 4) + 2 -- contra GRUPO B (B3, B4)
							END
							IF(@jogos = 3 OR @jogos = 4)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 4) - 2 -- contra GRUPO B (B1, B2)
							END
						END
						IF(@vez = 4) -- Jogadas diretas (- 1)
						BEGIN
							SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos + 12 -- GRUPO D
							IF(@jogos = 1)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 8) - 1 -- contra GRUPO B (B4)
							END
							ELSE
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 4) - 1 -- contra GRUPO B (B1, B2, B3)
							END
						END
					END
					IF(@reparticao = 2)
					BEGIN
						IF(@vez = 1) -- Jogadas diretas
						BEGIN
							SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos + 8 -- GRUPO C
							SELECT @timeB = codTime FROM grupos WHERE codGrupo = @jogos + 4 -- contra GRUPO B
						END
						IF(@vez = 2) -- Jogadas diretas + 1 
						BEGIN
							SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos + 8 -- GRUPO C
							IF(@jogos = 4)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = 5 -- contra GRUPO B (B1)
							END
							ELSE
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = @jogos + 5 -- contra GRUPO B (B2, B3, B4)
							END
						END
						IF(@vez = 3) -- Jogadas diretas (+ 2) E (- 2)
						BEGIN
							SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos + 8 -- GRUPO C
							IF(@jogos = 1 OR @jogos = 2)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 4) + 2 -- contra GRUPO B (B3, B4)
							END
							IF(@jogos = 3 OR @jogos = 4)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 4) - 2 -- contra GRUPO B (B1, B2)
							END
						END
						IF(@vez = 4) -- Jogadas diretas (- 1)
						BEGIN
							SELECT @data_rodada = dt_rodada_quarta FROM @datas WHERE codData = (@reparticao * 4) + @vez -- RODADA
							SELECT @timeA = codTime FROM grupos WHERE codGrupo = @jogos + 8 -- GRUPO C
							IF(@jogos = 1)
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 8) - 1 -- contra GRUPO B (B4)
							END
							ELSE
							BEGIN
								SELECT @timeB = codTime FROM grupos WHERE codGrupo = (@jogos + 4) - 1 -- contra GRUPO B (B1, B2, B3)
							END
						END
					END
					INSERT INTO jogos (codJogo, codTimeA, codTimeB, golsTimeA, golsTimeB, data_jogo, rodada)
					VALUES (@cod, @timeA, @timeB, 0, 0, @data_rodada, (@reparticao * 4) + @vez)
					SET @cod = @cod + 1
					SET @reparticao = @reparticao + 1
				END
				SET @jogos = @jogos + 1
			END
			SET @vez = @vez + 1
		END 
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


		