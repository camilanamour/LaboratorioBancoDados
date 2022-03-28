<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="./css/styles.css">
<meta charset="ISO-8859-1">
<title>Gerar Rodadas</title>
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
		<h3 class=tarefa>Gerar as rodadas segundos os times participantes</h3>
	</div>
	<div align="center">
		<form action="rodada" method="post">
			<input type="submit" id=gerar_rodada name=gerar_rodada value="Gerar Rodadas">
		</form>
	</div>
	<div align="center">
		<c:if test="${not empty erro}">
			<h4><c:out value="${erro}"></c:out></h4>
		</c:if>
	</div>
	<br />
	<div align="center">
		<c:if test="${not empty saida}">
			<h4><c:out value="${saida}"></c:out></h4>
		</c:if>
	</div>

</body>
</html>