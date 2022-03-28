package control;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import persistence.GenericDao;
import persistence.RodadasDao;

@WebServlet("/rodada")
public class ServletRodada extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ServletRodada() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		GenericDao gDao = new GenericDao();
		RodadasDao rDao = new RodadasDao(gDao);
		
		String saida = "";
		String erro = "";
		
		try {
			saida = rDao.gerarRodadas();
		}catch(SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		}finally {
			RequestDispatcher rd = request.getRequestDispatcher("rodadas.jsp");
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			rd.forward(request, response);
		}
	}

}
