package br.edu.fatec.SpringFuncionario.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import br.edu.fatec.SpringFuncionario.model.Dependente;
import br.edu.fatec.SpringFuncionario.model.Funcionario;

@Repository
public class FuncionarioDao implements IFuncionarioDao{
	
	@Autowired
	GenericDao gDao;
	
	@Override
	public List<Funcionario> listarFuncionarios() throws ClassNotFoundException, SQLException {
		List<Funcionario> funcionarios = new ArrayList<Funcionario>();
		Connection c = gDao.getConnection();
		String sql = "SELECT codigo, nome, nome_dependente, salario, salario_dependente FROM fn_listar()";
		
		PreparedStatement ps = c.prepareStatement(sql);
		
		ResultSet rs = ps.executeQuery();
		
		while(rs.next()) {
			Funcionario f = new Funcionario();
			f.setNome(rs.getString("nome"));
			f.setSalario(rs.getFloat("salario"));
					
			Dependente d = new Dependente();
			d.setCodigo(rs.getInt("codigo"));
			d.setNome(rs.getString("nome_dependente"));
			d.setSalario(rs.getFloat("salario_dependente"));

			f.setDependente(d);
			funcionarios.add(f);
		}
		
		rs.close();
		ps.close();
		c.close();
		return funcionarios;
	}

	@Override
	public List<Float> listarSomas(int qtdFuncionarios) throws ClassNotFoundException, SQLException {
		List<Float> somas = new ArrayList<Float>();
		Connection c = gDao.getConnection();
		String sql = "SELECT dbo.fn_soma_salarios(?) AS soma ";
		int cont = 1;
				
		PreparedStatement ps = c.prepareStatement(sql.toString());
		while (cont <= qtdFuncionarios) {
			ps.setInt(1, cont);
			
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				float soma = rs.getFloat("soma");
				somas.add(soma);
			}
			rs.close();
		}
		ps.close();
		c.close();
		return somas;
	}

}
