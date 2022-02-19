package controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Viagem;
import persistence.GenericDao;
import persistence.IViagemDao;
import persistence.ViagemDao;

@WebServlet("/viagem")
public class Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public Servlet() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String id = request.getParameter("id");
		String botao = request.getParameter("botao");
		
		Viagem v = new Viagem();
		v.setCodigo(Integer.parseInt(id));
		
		GenericDao gDao = new GenericDao();
		IViagemDao vDao = new ViagemDao(gDao);
		
		// Atributos que devolve no despachante
		String erro = "";
		int valida=0;
		try {
			if(botao.equals("Descrição da viagem")) {
				v = vDao.consultaViagemDescricao(v);
				valida=1;
			} else {
				v = vDao.consultaOnibusDescricao(v);
			}
		} catch (ClassNotFoundException | SQLException e) {
			erro = e.getMessage();
		} finally {
			RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
			request.setAttribute("viagem", v);
			request.setAttribute("erro", erro);
			request.setAttribute("valida", valida);
			rd.forward(request, response);
		}
	}

}
