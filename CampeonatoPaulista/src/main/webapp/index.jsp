<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="./css/styles.css">
<meta charset="ISO-8859-1">
<title>Campeonato Paulista</title>
</head>
<body>
	<div align="center">
	<nav id=menu>
		<ul>
			<li><a href="index.jsp">Início</a></li>
			<li><a href="grupos.jsp">Grupos</a><li>
			<li><a href="rodadas.jsp">Rodadas</a></li>
			<li><a href="tabela.jsp">Tabelas</a></li>
			<li><a href="datas.jsp">Datas</a></li>
		</ul>
	</nav>
	</div>
	<br/><br/>
	<div align="center">
		<h1 class=texto>Campeonato Paulista</h1>
	</div>
	<br/>
	<div align="center">
		<h3 class=mapa>Mapa de Navegação:</h3>
		<table class=table_home>
		<tr></tr>
			<tr>
				<td><b>Grupos:</b> gerar a divisão dos grupos aleatoriamente.</td>
			</tr><tr>
				<td><b>Tabelas:</b> 4 Tabelas com os 4 grupos formados.</td>
			</tr><tr>
				<td><b>Rodadas:</b> gerar as rodadas dos jogos.</td>
			</tr><tr>
				<td><b>Datas:</b> mostre uma tabela com todos os jogos daquela rodada.</td>
			</tr>
		<tr></tr>
		</table>	
	</div>
</body>
</html>