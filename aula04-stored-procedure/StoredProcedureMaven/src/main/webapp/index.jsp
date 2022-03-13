<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="./css/styles.css">
<meta charset="ISO-8859-1">
<title>Gerenciamento de Clientes</title>
</head>
<body>
	<div align="center">
		<h1>Gerenciamento de Clientes</h1>
	</div>
	<br />
	<div align="center">
		<form action="cliente" method="post">
			<input type="text" id=cpf name=cpf placeholder="CPF" value= '<c:out value = "${cliente.cpf }"></c:out>'> 
			
			<input type="submit" id=botao name=botao value="Consultar"> 
			<input type="submit" id=botao name=botao value="Listar"> <br /><br /> 

			<input type="text" id=nome name=nome placeholder="Nome" value= '<c:out value = "${cliente.nome }"></c:out>'> 
			<input type="text" id=email name=email placeholder="E-mail" value= '<c:out value = "${cliente.email }"></c:out>'> <br /><br /> 
			<input type="number" min=0.0 step=0.1 id=limite name=limite placeholder="Limite Crédito" 
			value= '<c:out value = "${cliente.limiteCredito }"></c:out>'> 
			<input type="date" id=nascimento name=nascimento value= '<c:out value = "${cliente.dataNascimento }"></c:out>'>
			<br /><br /> 
			<input type="submit" id=botao name=botao value="Inserir">
			<input type="submit" id=botao name=botao value="Atualizar"> 
			<input type="submit" id=botao name=botao value="Deletar"> 
			<br /><br />
		</form>
	</div>

	<div align="center">
		<c:if test="${not empty saida}">
			<c:out value="${saida}"></c:out>
		</c:if>
	</div>
	<div align="center">
		<c:if test="${not empty erro}">
			<c:out value="${erro}"></c:out>
		</c:if>
	</div>
	<div align="center">
		<c:if test="${not empty clientes }">
			<table border="1">
				<thead>
					<tr>
						<td>CPF</td>
						<td>Nome</td>
						<td>E-mail</td>
						<td>Limite Crédito</td>
						<td>Data Nascimento</td>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${clientes }" var="cli">
					<tr>
						<td><c:out value="${cli.cpf }"></c:out></td>
						<td><c:out value="${cli.nome}"></c:out></td>
						<td><c:out value="${cli.email}"></c:out></td>
						<td><c:out value="${cli.limiteCredito}"></c:out></td>
						<td><c:out value="${cli.dataNascimento }"></c:out></td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
</body>
</html>