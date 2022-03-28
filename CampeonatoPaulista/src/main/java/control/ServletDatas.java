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

import model.Jogo;
import persistence.GenericDao;
import persistence.RodadasDao;

@WebServlet("/datas")
public class ServletDatas extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ServletDatas() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		GenericDao gDao = new GenericDao();
		RodadasDao rDao = new RodadasDao(gDao);
		
		String data_rodada = request.getParameter("data_rodada");
		String saida = "";
		String erro = "";
		List<Jogo> rodada = new ArrayList<Jogo>();
		
		try {
			rodada = rDao.listarRodada(data_rodada);
			if(rodada == null){
				saida = "Data inexistente";
			}
		}catch(SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		}finally {
			RequestDispatcher rd = request.getRequestDispatcher("datas.jsp");
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("rodada", rodada);
			rd.forward(request, response);
		}
	}

}
