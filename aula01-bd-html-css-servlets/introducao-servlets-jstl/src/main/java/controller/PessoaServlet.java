package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Pessoa;

@WebServlet("/pessoa") 
public class PessoaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    /* Encontra-se em src>main>java>controller
     * Anotações usando java
     * Conectar o HTML com o Servlet (pessoa)
     */
	
    public PessoaServlet() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		System.out.println("Entrou no servlet PessoaServlet");
		
	// Receber os dados por parametro no Servlet (Gerar Objeto)
		String idParam = request.getParameter("id");
		String nomeParam = request.getParameter("nome");
		
		Pessoa pessoa = new Pessoa();
		pessoa.setId(Integer.parseInt(idParam));
		pessoa.setNome(nomeParam);
		
		System.out.println(pessoa.toString());
		
	// Retorna um mapa com name (chave) e o valor; dentro do formulario;
//		Map<String,String[]> parameterMap = request.getParameterMap();
//		
//		Set<String> keySet = parameterMap.keySet(); // lista só com as chaves
//		for(String key : keySet) {
//			String[] param = parameterMap.get(key); // pega parametros - valores
//			System.out.println(param[0]);
//			System.out.println(key); // pega parametros - chaves
//		}
		
	//	Lista de Pessoas
		List<Pessoa> pessoas = new ArrayList<Pessoa>();
		Pessoa pessoa1 = new Pessoa();
		pessoa1.setId(11);
		pessoa1.setNome("Beltrano");
		pessoas.add(pessoa1);
		
		Pessoa pessoa2 = new Pessoa();
		pessoa2.setId(12);
		pessoa2.setNome("Ciclano");
		pessoas.add(pessoa2);
		
//		for(Pessoa p: pessoas){
//			System.out.println(p);
//		}
		
	// Despachante = mandar as informações para outra tela
		RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
		request.setAttribute("pessoa", pessoa);
		request.setAttribute("pessoa", pessoas);
		rd.forward(request, response); // Remonta o index conhecendo os atributos
		// Conexão JSP <--> Servlet usando o tomcat como servidor
	}

}
