<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<!-- Elementos de programacao na camada de visão -->
<html>
<head>
<meta charset="ISO-8859-1">
<title>Exemplo Servlets e JSTL</title>
</head>
<body>
	<div>
		<form action="pessoa" method="post">
		<!-- Clicando no botão acessa o post -->
			<table>
				<tr>
					<td><input type="number" id="id" name="id" placeholder="#ID" required="required"></td>
				</tr>
				<tr>
					<td><input type="text" id="nome" name="nome" placeholder="Nome" required="required"
					value='<c:out value="${pessoa.nome}"></c:out>'></td>
				</tr>
				<tr>
				<td><input type="submit" id="enviar" name="enviar" value="Enviar"></td>
			</tr>
			</table>
		</form>
	</div>
	<br />
	<!--  JSTL = JAVA SERVLETS TAGLIB = JAVA + HTML
	Bibliotecas de tags com programações já pré-embarcadas em tags -->
	<div>
		<c:if test="${empty pessoa}">
			<p>Sem pessoa</p>
		</c:if>
		
		<c:if test="${not empty pessoa}">
			<c:out value="${pessoa.id}"></c:out> -
			<c:out value="${pessoa.nome}"></c:out>
		</c:if>
		<!-- eq=igual; ne=diferente; lt=menor; gt=maior; le=menor ou igual; ge=maior ou igual -->
		<!-- <c:if test="${x eq 1}"></c:if> -->
	</div>
	<br />
	<div>
		<c:if test="${not empty pessoas }">
			<table border="1">
				<thead>
					<tr>
						<th>#ID</th>
						<th>Nome</th>
					</tr>
				</thead>
				<tbody>	
				<c:forEach items="${pessoas}" var="p">
<!-- 					<c:out value="${p }"></c:out> -->
					<tr>
						<td><c:out value="${p.id }"></c:out></td>
						<td><c:out value="${p.nome }"></c:out></td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</c:if>
		<!-- eq=igual; ne=diferente; lt=menor; gt=maior; le=menor ou igual; ge=maior ou igual -->
		<!-- <c:if test="${x eq 1}"></c:if> -->
	</div>
</body>
</html>