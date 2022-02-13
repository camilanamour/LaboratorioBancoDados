CREATE DATABASE escola_revisao
GO
use escola_revisao

-- Entidades
CREATE TABLE aluno(
ra	INT	NOT NULL,
nome	VARCHAR(100)	NOT NULL,
idade	INT	NOT NULL	CHECK(idade>0)
PRIMARY KEY(ra)
)
GO
CREATE TABLE disciplina(
codigo	INT	NOT NULL	IDENTITY(1,1),
nome	VARCHAR(80)	NOT NULL,
carga_horaria	INT	NOT NULL	CHECK(carga_horaria>=32)
PRIMARY KEY(codigo)
)
GO
CREATE TABLE curso(
codigo	INT NOT NULL	IDENTITY(1,1),
nome	VARCHAR(50)	 NOT NULL,
area	VARCHAR(50) NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE titulacao(
codigo	INT NOT NULL	IDENTITY(1,1),
titulo	VARCHAR(40)	NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE professor(
codigo	INT	 NOT NULL	IDENTITY(1111,1),
nome	VARCHAR(100) NOT NULL,
titulacao	INT	NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(titulacao) REFERENCES titulacao(codigo)
)
GO
CREATE TABLE disciplina_professor(
cod_disciplina	INT	NOT NULL,
cod_professor	INT	NOT NULL
PRIMARY KEY(cod_disciplina, cod_professor)
FOREIGN KEY(cod_disciplina) REFERENCES disciplina(codigo),
FOREIGN KEY(cod_professor) REFERENCES professor(codigo)
)
GO
CREATE TABLE curso_disciplina(
cod_disciplina	INT	NOT NULL,
cod_curso	INT	NOT NULL
PRIMARY KEY(cod_disciplina, cod_curso)
FOREIGN KEY(cod_curso) REFERENCES curso(codigo),
FOREIGN KEY(cod_disciplina) REFERENCES disciplina(codigo)
)
GO
CREATE TABLE aluno_disciplina(
cod_disciplina	INT	NOT NULL,
cod_aluno	INT	NOT NULL
PRIMARY KEY(cod_disciplina, cod_aluno)
FOREIGN KEY(cod_aluno) REFERENCES aluno(ra),
FOREIGN KEY(cod_disciplina) REFERENCES disciplina(codigo)
)

DROP TABLE aluno_disciplina
DROP TABLE curso_disciplina
DROP TABLE disciplina_professor
DROP TABLE professor
DROP TABLE titulacao
DROP TABLE curso
DROP TABLE aluno
DROP TABLE disciplina

INSERT INTO aluno VALUES
(3416,'DIEGO PIOVESAN DE RAMOS',18),
(3423,'LEONARDO MAGALHÃES DA ROSA',17),
(3434,'LUIZA CRISTINA DE LIMA MARTINELI',20),
(3440,'IVO ANDRÉ FIGUEIRA DA SILVA',25),
(3443,'BRUNA LUISA SIMIONI',37),
(3448,'THAÍS NICOLINI DE MELLO',17),
(3457,'LÚCIO DANIEL TÂMARA ALVES',29),
(3459,'LEONARDO RODRIGUES',25),
(3465,'ÉDERSON RAFAEL VIEIRA',19),
(3466,'DAIANA ZANROSSO DE OLIVEIRA',21),
(3467,'DANIELA MAURER',23),
(3470,'ALEX SALVADORI PALUDO',42),
(3471,'VINÍCIUS SCHVARTZ',19),
(3472,'MARIANA CHIES ZAMPIERI',18),
(3482,'EDUARDO CAINAN GAVSKI',19),
(3483,'REDNALDO ORTIZ DONEDA',20),
(3499,'MAYELEN ZAMPIERON',22)

INSERT INTO disciplina VALUES
('Laboratório de Banco de Dados',80),
('Laboratório de Engenharia de Software',80),
('Programação Linear e Aplicações',80),
('Redes de Computadores',80),
('Segurança da informação',40),
('Teste de Software',80),
('Custos e Tarifas Logísticas',80),
('Gestão de Estoques',40),
('Fundamentos de Marketing',40),
('Métodos Quantitativos de Gestão',80),
('Gestão do Tráfego Urbano',80),
('Sistemas de Movimentação e Transporte',40)

INSERT INTO titulacao VALUES
('Especialista'),
('Mestre'),
('Doutor')

INSERT INTO professor VALUES
('Leandro',2),
('Antonio',2),
('Alexandre',3),
('Wellington',2),
('Luciano',1),
('Edson',2),
('Ana',2),
('Alfredo',1),
('Celio',2),
('Dewar',3),
('Julio',1)

INSERT INTO curso VALUES
('ADS','Ciências da Computação'),
('Logística','Engenharia Civil')

INSERT INTO aluno_disciplina VALUES
(1,3416),
(4,3416),
(1,3423),
(2,3423),
(5,3423),
(6,3423),
(2,3434),
(5,3434),
(6,3434),
(1,3440),
(5,3443),
(6,3443),
(4,3448),
(5,3448),
(6,3448),
(2,3457),
(4,3457),
(5,3457),
(6,3457),
(1,3459),
(6,3459),
(7,3465),
(11,3465),
(8,3466),
(11,3466),
(8,3467),
(12,3467),
(8,3470),
(9,3470),
(11,3470),
(12,3470),
(7,3471),
(7,3472),
(12,3472),
(9,3482),
(11,3482),
(8,3483),
(11,3483),
(12,3483),
(8,3499)

INSERT INTO disciplina_professor VALUES
(1,1111),
(2,1112),
(3,1113),
(4,1114),
(5,1115),
(6,1116),
(7,1117),
(8,1118),
(9,1117),
(10,1119),
(11,1120),
(12,1121)

INSERT INTO curso_disciplina VALUES
(1,1),
(2,1),
(3,1),
(4,1),
(5,1),
(6,1),
(7,2),
(8,2),
(9,2),
(10,2),
(11,2),
(12,2)


SELECT * FROM aluno
SELECT * FROM disciplina
SELECT * FROM curso
SELECT * FROM professor
SELECT * FROM titulacao
SELECT * FROM aluno_disciplina
SELECT * FROM disciplina_professor
SELECT * FROM curso_disciplina

--Como fazer as listas de chamadas, com RA e nome por disciplina ?
SELECT al.ra, al.nome, d.nome
FROM aluno al, aluno_disciplina ad, disciplina d
WHERE al.ra = ad.cod_aluno
	  AND d.codigo = ad.cod_disciplina
	  AND d.codigo IN (
				SELECT codigo 
				FROM disciplina
	  )
ORDER BY d.nome ASC, al.nome ASC

--Fazer uma pesquisa que liste o nome das disciplinas e o nome dos professores que as ministram	
SELECT d.nome, p.nome
FROM professor p, disciplina_professor pd, disciplina d
WHERE p.codigo = pd.cod_professor
	  AND d.codigo = pd.cod_disciplina
	  AND d.codigo IN (
				SELECT codigo 
				FROM disciplina
	  )

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne o nome do curso
SELECT c.nome
FROM curso c, curso_disciplina cd, disciplina d
WHERE c.codigo = cd.cod_curso
	  AND d.codigo = cd.cod_disciplina
	  AND d.nome = 'Gestão de Estoques'

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne sua área		
SELECT c.area
FROM curso c, curso_disciplina cd, disciplina d
WHERE c.codigo = cd.cod_curso
	  AND d.codigo = cd.cod_disciplina
	  AND d.nome = 'Laboratório de Banco de Dados'

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne o título do professor que a ministra	
SELECT t.titulo
FROM titulacao t, professor p, disciplina_professor pd, disciplina d
WHERE p.codigo = pd.cod_professor
	  AND d.codigo = pd.cod_disciplina
	  AND p.titulacao = t.codigo
	  AND d.nome = 'Laboratório de Banco de Dados'

--Fazer uma pesquisa que retorne o nome da disciplina e quantos alunos estão matriculados em cada uma delas		
SELECT d.nome, COUNT(al.ra) AS qtd_alunos
FROM aluno al, aluno_disciplina ad, disciplina d
WHERE al.ra = ad.cod_aluno
	  AND d.codigo = ad.cod_disciplina
GROUP BY d.nome

--Fazer uma pesquisa que, dado o nome de uma disciplina, retorne o nome do professor.  Só deve retornar de disciplinas que tenham, no mínimo, 5 alunos matriculados													
SELECT p.nome
FROM professor p, disciplina_professor pd, disciplina d, aluno al, aluno_disciplina ad
WHERE p.codigo = pd.cod_professor
	AND d.codigo = pd.cod_disciplina
	AND d.codigo = ad.cod_disciplina
	AND al.ra = ad.cod_aluno
	AND d.nome LIKE 'Segurança%'
GROUP BY p.nome
HAVING COUNT(al.ra) >= 5

--Fazer uma pesquisa que retorne o nome do curso e a quatidade de professores cadastrados que ministram aula nele. A coluna de ve se chamar quantidade													
SELECT c.nome, COUNT(p.codigo) as quantidade
FROM professor p, disciplina_professor pd, disciplina d, curso c, curso_disciplina cd
WHERE p.codigo = pd.cod_professor
	AND d.codigo = pd.cod_disciplina
	AND d.codigo = cd.cod_disciplina
	AND c.codigo = cd.cod_curso
GROUP BY c.nome
