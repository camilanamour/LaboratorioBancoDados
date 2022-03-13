package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Cliente;
import persistence.ClienteDao;
import persistence.GenericDao;

@WebServlet("/cliente")
public class ServletCliente extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public ServletCliente() {
		super();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String cpf = request.getParameter("cpf");
		String nome = request.getParameter("nome");
		String email = request.getParameter("email");
		String limite = request.getParameter("limite");
		String nascimento = request.getParameter("nascimento");
		String botao = request.getParameter("botao");

		Cliente c = new Cliente();
		c.setCpf(cpf);

		GenericDao gDao = new GenericDao();
		ClienteDao cDao = new ClienteDao(gDao);

		String erro = "";
		String saida = "";

		List<Cliente> clientes = new ArrayList<Cliente>();

		String op = botao.substring(0, 1);
		if (op.equals("A")) {
			op = "U";
		}

		try {
			if (op.equals("I") || op.equals("U")) {
				if (cpf.equals("") || nome.equals("") || nascimento.equals("")) {
					throw new IOException("Preencha o cpf, nome e data de nascimento");
				} else {
					c.setCpf(cpf);
					c.setNome(nome);
					c.setEmail(email);
					c.setLimiteCredito(Float.parseFloat(limite));
					c.setDataNascimento(nascimento);
					saida = cDao.iudCliente(op, c);
				}
			}
			if (op.equals("D")) {
				if (cpf.equals("")) {
					throw new IOException("Preencha o cpf");
				} else {
					c.setCpf(cpf);
					saida = cDao.iudCliente(op, c);
				}
			}
			if (op.equals("C")) {
				if (cpf.equals("")) {
					throw new IOException("Preencha o cpf");
				} else {
					c.setCpf(cpf);
					c = cDao.consultaCliente(c);
				}
			}
			if (op.equals("L")) {
				clientes = cDao.consultaClientes();
			}

		} catch (ClassNotFoundException | SQLException | IOException e) {
			erro = e.getMessage();
		} finally {
			RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
			request.setAttribute("cliente", c);
			request.setAttribute("clientes", clientes);
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			rd.forward(request, response);
		}
	}
}
