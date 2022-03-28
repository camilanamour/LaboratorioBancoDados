package control;

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

import model.Grupo;
import persistence.GenericDao;
import persistence.GrupoDao;

@WebServlet("/grupo")
public class ServletGrupo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ServletGrupo() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		GenericDao gDao = new GenericDao();
		GrupoDao grpDao = new GrupoDao(gDao);
		
		String saida = "";
		String erro = "";
		List<Grupo> grupos = new ArrayList<Grupo>();
		
		try {
			saida = grpDao.divideTimes();
			grupos = grpDao.listarTimes();
		}catch(SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		}finally {
			RequestDispatcher rd = request.getRequestDispatcher("grupos.jsp");
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("grupos", grupos);
			rd.forward(request, response);
		}
	}

}
