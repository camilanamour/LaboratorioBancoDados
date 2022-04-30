<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href='<c:url value="./resources/css/styles.css" />'>
<meta charset="ISO-8859-1">
<title>Campeonato Paulista</title>
</head>
<body>
	<div align="center">
		<jsp:include page="menu.jsp"></jsp:include>
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
				<td><b>Datas:</b> mostrar uma tabela com todos os jogos daquela rodada.</td>
			</tr><tr>
				<td><b>Classificação:</b> mostrar tabelas com todos os competidores ou divididos por grupos.</td>
			</tr><tr>
				<td><b>Quartas de Final:</b> mostrar uma tabela dos participantes das quartas de final.</td>
			</tr>
		<tr></tr>
		</table>	
	</div>
</body>
</html>