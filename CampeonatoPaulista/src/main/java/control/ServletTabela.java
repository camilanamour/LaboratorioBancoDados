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

@WebServlet("/tabela")
public class ServletTabela extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public ServletTabela() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		GenericDao gDao = new GenericDao();
		GrupoDao grpDao = new GrupoDao(gDao);
		
		List<Grupo> grupoA = new ArrayList<Grupo>();
		List<Grupo> grupoB = new ArrayList<Grupo>();
		List<Grupo> grupoC = new ArrayList<Grupo>();
		List<Grupo> grupoD = new ArrayList<Grupo>();
		
		String erro = "";
		
		try {
			grupoA = grpDao.listarGrupo("A");
			grupoB = grpDao.listarGrupo("B");
			grupoC = grpDao.listarGrupo("C");
			grupoD = grpDao.listarGrupo("D");
		}catch(SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		}finally{
			RequestDispatcher rd = request.getRequestDispatcher("tabela.jsp");
			request.setAttribute("erro", erro);
			request.setAttribute("grupoA", grupoA);
			request.setAttribute("grupoB", grupoB);
			request.setAttribute("grupoC", grupoC);
			request.setAttribute("grupoD", grupoD);
			rd.forward(request, response);
		}
	}

}
