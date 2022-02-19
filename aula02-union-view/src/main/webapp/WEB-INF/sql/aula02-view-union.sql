CREATE DATABASE viagens_bd
GO
USE viagens_bd

CREATE TABLE motorista(
codigo			INT			NOT NULL,
nome			VARCHAR(40)	NOT NULL,
naturalidade	VARCHAR(40) NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE onibus(
placa		CHAR(7)		NOT NULL,
marca		VARCHAR(15)	NOT NULL,
ano			INT			NOT NULL,
descricao	VARCHAR(20)	NOT NULL
PRIMARY KEY (placa)
)
GO
CREATE TABLE viagem(
codigo			INT			NOT NULL,
onibus			CHAR(7)		NOT NULL,
motorista		INT			NOT NULL,
hora_saida		INT			NOT NULL	CHECK(hora_saida>=0),
hora_chegada	INT			NOT NULL	CHECK(hora_chegada>=0),
partida			VARCHAR(40)	NOT NULL,
destino			VARCHAR(40)	NOT NULL,
PRIMARY KEY (codigo),
FOREIGN KEY (onibus) REFERENCES onibus(placa),
FOREIGN KEY (motorista) REFERENCES motorista(codigo),
)

SELECT * FROM motorista
SELECT * FROM onibus
SELECT * FROM viagem

INSERT INTO motorista VALUES
(12341,'Julio Cesar','São Paulo'),
(12342,'Mario Carmo','Americana'),
(12343,'Lucio Castro','Campinas'),
(12344,'André Figueiredo','São Paulo'),
(12345,'Luiz Carlos','São Paulo'),
(12346,'Carlos Roberto','Campinas'),
(12347,'João Paulo','São Paulo')

INSERT INTO onibus VALUES
('adf0965','Mercedes',2009,'Leito'),
('bhg7654','Mercedes',2012,'Sem Banheiro'),
('dtr2093','Mercedes',2017,'Ar Condicionado'),
('gui7625','Volvo',2014,'Ar Condicionado'),
('jhy9425','Volvo',2018,'Leito'),
('lmk7485','Mercedes',2015,'Ar Condicionado'),
('aqw2374','Volvo',2014,'Leito')

INSERT INTO viagem VALUES
(101,'adf0965',12343,10,12,'São Paulo','Campinas'),
(102,'gui7625',12341,7,12,'São Paulo','Araraquara'),
(103,'bhg7654',12345,14,22,'São Paulo','Rio de Janeiro'),
(104,'dtr2093',12344,18,21,'São Paulo','Sorocaba'),
(105,'aqw2374',12342,11,17,'São Paulo','Ribeirão Preto'),
(106,'jhy9425',12347,10,19,'São Paulo','São José do Rio Preto'),
(107,'lmk7485',12346,13,20,'São Paulo','Curitiba'),
(108,'adf0965',12343,14,16,'Campinas','São Paulo'),
(109,'gui7625',12341,14,19,'Araraquara','São Paulo'),
(110,'bhg7654',12345,0,8,'Rio de Janeiro','São Paulo'),
(111,'dtr2093',12344,22,1,'Sorocaba','São Paulo'),
(112,'aqw2374',12342,19,5,'Ribeirão Preto','São Paulo'),
(113,'jhy9425',12347,22,7,'São José do Rio Preto','São Paulo'),
(114,'lmk7485',12346,0,7,'Curitiba','São Paulo')

-- 1) Criar um Union das tabelas Motorista e ônibus, com as colunas ID (Código e Placa) e Nome (Nome e Marca)
SELECT CAST(codigo AS VARCHAR) AS codigo, nome AS nome
FROM motorista
UNION
SELECT placa AS codigo, marca AS nome
FROM onibus

-- 2) Criar uma View (Chamada v_motorista_onibus) do Union acima
CREATE VIEW v_motorista_onibus
	AS
		SELECT CAST(codigo AS VARCHAR) AS codigo, nome AS nome FROM motorista
		UNION
		SELECT placa AS codigo, marca AS nome FROM onibus

SELECT * FROM v_motorista_onibus

-- 3) Criar uma View (Chamada v_descricao_onibus) que mostre o Código da Viagem, o Nome do motorista, a placa do ônibus (Formato XXX-0000), a Marca do ônibus, o Ano do ônibus e a descrição do onibus
CREATE VIEW v_descricao_onibus
	AS
		SELECT v.codigo, m.nome, SUBSTRING(o.placa,1,3) + '-' + SUBSTRING(o.placa,4,4) AS placa, o.marca, o.ano, o.descricao
		FROM viagem v, onibus o, motorista m
		WHERE v.motorista = m.codigo
			AND v.onibus = o.placa

SELECT * FROM v_descricao_onibus
-- SELECT codigo, nome, placa, marca, ano, descricao FROM v_descricao_onibus WHERE codigo = ? -> Desenvolvimento
DROP VIEW v_descricao_onibus

-- 4) Criar uma View (Chamada v_descricao_viagem) que mostre o Código da viagem, a placa do ônibus(Formato XXX-0000), a Hora da Saída da viagem (Formato HH:00), a Hora da Chegada da viagem (Formato HH:00), partida e destino
CREATE VIEW v_descricao_viagem
	AS
		SELECT v.codigo, SUBSTRING(o.placa,1,3) + '-' + SUBSTRING(o.placa,4,4) AS placa, CAST(v.hora_saida AS VARCHAR)+':00' AS saida, CAST(v.hora_chegada AS VARCHAR)+':00' AS chegada, partida, destino
		FROM viagem v, onibus o
		WHERE v.onibus = o.placa
		--  AND v.codigo=?

SELECT * FROM v_descricao_viagem
-- SELECT codigo, placa, saida, chegada, partida, destino FROM v_descricao_viagem WHERE codigo = 101 -> Desenvolvimento
DROP VIEW v_descricao_viagem