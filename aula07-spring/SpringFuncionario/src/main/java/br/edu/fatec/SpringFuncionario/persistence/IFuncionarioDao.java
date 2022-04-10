package br.edu.fatec.SpringFuncionario.persistence;

import java.sql.SQLException;
import java.util.List;

import br.edu.fatec.SpringFuncionario.model.Funcionario;

public interface IFuncionarioDao {
	
	public List<Funcionario> listarFuncionarios() throws ClassNotFoundException, SQLException;
	public List<Float> listarSomas(int qtdFuncionarios) throws ClassNotFoundException, SQLException;

}
