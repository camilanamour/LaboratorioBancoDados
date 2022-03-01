<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="./css/styles.css">
<meta charset="ISO-8859-1">
<title>Informações da Viagem</title>
</head>
<body>
	<div align="center">
		<h1>Rodoviária</h1>
		<p>Digite o código e selecione o que deseja pesquisar.</p>
	</div>
	<div align="center">
		<form action="viagem" method="post">
			<input type="number" min=0 step=1 id=id name=id placeholder="#ID" required="required">
			<input type="submit" id=botao name=botao value="Descrição da viagem">
			<input type="submit" id=botao name=botao value="Descrição do ônibus">
			<br />
		</form>
	</div>
	<br />
	<br />
	<div align="center">
		<c:if test="${not empty erro}">
			<c:out value="${erro}"></c:out>
		</c:if>
	</div>
	<div align="center">
		<c:if test="${not empty viagem }">
			<c:if test="${valida eq 1}">
				<table>
					<thead>
						<tr>
							<td>Codigo</td>
							<td>Placa</td>
							<td>Saída</td>
							<td>Chegada</td>
							<td>Partida</td>
							<td>Destino</td>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><c:out value="${viagem.codigo }"></c:out></td>
							<td><c:out value="${viagem.onibus.placa }"></c:out></td>
							<td><c:out value="${viagem.hora_saida }"></c:out></td>
							<td><c:out value="${viagem.hora_chegada }"></c:out></td>
							<td><c:out value="${viagem.partida }"></c:out></td>
							<td><c:out value="${viagem.destino }"></c:out></td>
						</tr>
					</tbody>
				</table>
			</c:if>
			<c:if test="${valida eq 0}">
				<table>
					<thead>
						<tr>
							<td>Codigo</td>
							<td>Nome</td>
							<td>Placa</td>
							<td>Marca</td>
							<td>Ano</td>
							<td>Descrição</td>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><c:out value="${viagem.codigo }"></c:out></td>
							<td><c:out value="${viagem.motorista.nome }"></c:out></td>
							<td><c:out value="${viagem.onibus.placa }"></c:out></td>
							<td><c:out value="${viagem.onibus.marca }"></c:out></td>
							<td><c:out value="${viagem.onibus.ano }"></c:out></td>
							<td><c:out value="${viagem.onibus.descricao }"></c:out></td>
						</tr>
					</tbody>
				</table>
			</c:if>
		</c:if>
	</div>
</body>
</html>