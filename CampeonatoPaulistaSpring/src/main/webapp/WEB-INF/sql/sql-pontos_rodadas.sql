USE bd_campeonato_paulista

-- Criar uma Trigger que não permita INSERT, UPDATE ou DELETE nas tabelas TIMES e GRUPOS 
-- e uma Trigger semelhante, mas apenas para INSERT e DELETE na tabela jogos.
CREATE TRIGGER t_insupddlttimes ON times
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	RAISERROR('Não é permitido modificar os times', 16, 1)
END

CREATE TRIGGER t_insupddltgrupos ON grupos
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	RAISERROR('Não é permitido modificar os grupos', 16, 1)
END

CREATE TRIGGER t_insdltjogos ON jogos
INSTEAD OF INSERT, DELETE
AS
BEGIN
	RAISERROR('Não é permitido modificar os jogos - apenas os pontos', 16, 1)
END

-- Desabilita a Trigger
DISABLE TRIGGER t_insupddlttimes ON times
DISABLE TRIGGER t_insupddltgrupos ON grupos
DISABLE TRIGGER t_insdltjogos ON jogos
 
-- Habilita a Trigger
ENABLE TRIGGER t_insupddlttimes ON times
ENABLE TRIGGER t_insupddltgrupos ON grupos
ENABLE TRIGGER t_insdltjogos ON jogos

-- GRUPO (nome_time, num_jogos_disputados*, 
-- vitorias, empates, derrotas, gols_marcados, gols_sofridos, saldo_gols**,pontos***) 

CREATE TABLE situacao(
codTime	INT NOT NULL,
nome_time VARCHAR(80) NOT NULL,
grupo	CHAR(1)	NOT NULL		CHECK(grupo = 'A' OR grupo = 'B' OR grupo = 'C' OR grupo = 'D'),
num_jogos_disputados INT,
vitorias INT,
empates INT,
derrotas INT,
gols_marcados INT,
gols_sofridos INT,
saldo_gols INT ,
pontos INT 
PRIMARY KEY(codTime)
FOREIGN KEY(codTime) REFERENCES times(codTime)
)

CREATE PROCEDURE sp_situacao (@saida VARCHAR(40) OUTPUT)
AS
	DECLARE @codTime INT, @nomeTime VARCHAR(80), @grupo CHAR(1), @cont INT
	SET @cont = 1
	WHILE(@cont <= 16)
	BEGIN
		SELECT @codTime = g.codTime, @nomeTime = t.nomeTime, @grupo= g.grupo 
		FROM grupos g, times t
		WHERE g.codTime = t.codTime
			AND t.codTime = @cont
	
		INSERT INTO situacao VALUES
		(@codTime, @nomeTime, @grupo, 0,0,0,0,0,0,0,0)
		SET @cont = @cont + 1
	END
	SET @saida = 'ok'

DECLARE @saida VARCHAR(40)
EXEC sp_situacao @saida OUTPUT
PRINT @saida

SELECT * FROM situacao

-- * O num_jogos_disputados é o número de jogos feitos por 
-- aquele time, até o presente instante. Jogos sem resultados 
-- não devem ser considerados.
-- ** Saldo de gols é a diferença entre gols marcados e gols sofridos
-- *** O total de pontos se dá somando os resultados, 
-- onde:(Vitória = 3 pontos, Empate = 1 ponto , Derrota = 0 pontos)

CREATE TRIGGER t_update_situacao ON jogos
AFTER UPDATE
AS
BEGIN
	DECLARE @golsA INT, @golsB INT, @timeA INT, @timeB INT
	DECLARE @jogados INT, @vitoria INT, @empate INT, @derrota INT
	DECLARE @gols_marcados INT, @gols_sofridos INT, @diferenca INT, @pontos INT

	SELECT @timeA = codTimeA, @timeB = codTimeB, @golsA = golsTimeA, @golsB = golsTimeB FROM INSERTED
	
	IF(@golsA > @golsB)
	BEGIN
	--> Atualizar TIME A
		SELECT @jogados = num_jogos_disputados, @vitoria = vitorias,
		@gols_marcados = gols_marcados, @gols_sofridos = gols_sofridos,
		@pontos = pontos FROM situacao WHERE codTime = @timeA

		SET @jogados = @jogados + 1
		SET @vitoria = @vitoria + 1
		SET @gols_marcados = @gols_marcados + @golsA
		SET @gols_sofridos = @gols_sofridos + @golsB
		SET @diferenca = @gols_marcados - @gols_sofridos
		SET @pontos = @pontos + 3

		UPDATE situacao
		SET num_jogos_disputados = @jogados, vitorias = @vitoria,
		gols_marcados = @gols_marcados, gols_sofridos = @gols_sofridos,
		saldo_gols = @diferenca, pontos = @pontos
		WHERE codTIme = @timeA

		--> Atualizar TIME B
		SELECT @jogados = num_jogos_disputados, @derrota = derrotas,
		@gols_marcados = gols_marcados, @gols_sofridos = gols_sofridos
		FROM situacao WHERE codTime = @timeB

		SET @jogados = @jogados + 1
		SET @derrota = @derrota + 1
		SET @gols_marcados = @gols_marcados + @golsB
		SET @gols_sofridos = @gols_sofridos + @golsA
		SET @diferenca = @gols_marcados - @gols_sofridos

		UPDATE situacao
		SET num_jogos_disputados = @jogados, derrotas = @derrota,
		gols_marcados = @gols_marcados, gols_sofridos = @gols_sofridos,
		saldo_gols = @diferenca WHERE codTime = @timeB
		PRINT 'A ganhou B'
	END
	IF(@golsA < @golsB)
	BEGIN
		--> Atualizar TIME B
		SELECT @jogados = num_jogos_disputados, @vitoria = vitorias,
		@gols_marcados = gols_marcados, @gols_sofridos = gols_sofridos,
		@pontos = pontos FROM situacao WHERE codTime = @timeB

		SET @jogados = @jogados + 1
		SET @vitoria = @vitoria + 1
		SET @gols_marcados = @gols_marcados + @golsB
		SET @gols_sofridos = @gols_sofridos + @golsA
		SET @diferenca = @gols_marcados - @gols_sofridos
		SET @pontos = @pontos + 3

		UPDATE situacao
		SET num_jogos_disputados = @jogados, vitorias = @vitoria,
		gols_marcados = @gols_marcados, gols_sofridos = @gols_sofridos,
		saldo_gols = @diferenca, pontos = @pontos
		WHERE codTIme = @timeB

		--> Atualizar TIME A
		SELECT @jogados = num_jogos_disputados, @derrota = derrotas,
		@gols_marcados = gols_marcados, @gols_sofridos = gols_sofridos
		FROM situacao WHERE codTime = @timeA

		SET @jogados = @jogados + 1
		SET @derrota = @derrota + 1
		SET @gols_marcados = @gols_marcados + @golsA
		SET @gols_sofridos = @gols_sofridos + @golsB
		SET @diferenca = @gols_marcados - @gols_sofridos

		UPDATE situacao
		SET num_jogos_disputados = @jogados, derrotas = @derrota,
		gols_marcados = @gols_marcados, gols_sofridos = @gols_sofridos,
		saldo_gols = @diferenca WHERE codTime = @timeA
		PRINT 'B ganhou A'
	END
	IF(@golsA = @golsB)
	BEGIN
		--> Atualizar TIME A
		SELECT @jogados = num_jogos_disputados, @empate = empates,
		@gols_marcados = gols_marcados, @gols_sofridos = gols_sofridos,
		@pontos = pontos FROM situacao WHERE codTime = @timeA

		SET @jogados = @jogados + 1
		SET @empate = @empate + 1
		SET @gols_marcados = @gols_marcados + @golsA
		SET @gols_sofridos = @gols_sofridos + @golsB
		SET @diferenca = @gols_marcados - @gols_sofridos
		SET @pontos = @pontos + 1

		UPDATE situacao
		SET num_jogos_disputados = @jogados, empates = @empate,
		gols_marcados = @gols_marcados, gols_sofridos = @gols_sofridos,
		saldo_gols = @diferenca, pontos = @pontos
		WHERE codTime = @timeA

		--> Atualizar TIME B
		SELECT @jogados = num_jogos_disputados, @empate = empates,
		@gols_marcados = gols_marcados, @gols_sofridos = gols_sofridos,
		@pontos = pontos FROM situacao WHERE codTime = @timeB

		SET @jogados = @jogados + 1
		SET @empate = @empate + 1
		SET @gols_marcados = @gols_marcados + @golsB
		SET @gols_sofridos = @gols_sofridos + @golsA
		SET @diferenca = @gols_marcados - @gols_sofridos
		SET @pontos = @pontos + 1

		UPDATE situacao
		SET num_jogos_disputados = @jogados, empates = @empate,
		gols_marcados = @gols_marcados, gols_sofridos = @gols_sofridos,
		saldo_gols = @diferenca, pontos = @pontos WHERE codTime = @timeB
		PRINT 'A empatou B'
	END
END

UPDATE jogos
SET golsTimeA = 2, golsTimeB = 1
WHERE codTimeA = 2 AND codTimeB = 8

-- Listar or grupos e mostrar as quartas de finais
SELECT codTime, nome_time AS nome, grupo, num_jogos_disputados AS disputados,
vitorias, empates, derrotas, gols_marcados, gols_sofridos, saldo_gols, pontos
FROM situacao WHERE grupo = 'A'
ORDER BY  pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC

-- Listar todos
SELECT codTime, nome_time AS nome, grupo, num_jogos_disputados AS disputados,
vitorias, empates, derrotas, gols_marcados, gols_sofridos, saldo_gols, pontos
FROM situacao 
ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC