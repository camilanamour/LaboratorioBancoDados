package persistence;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Cliente;

public class ClienteDao implements IClienteDao {

	GenericDao gDao;

	public ClienteDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public String iudCliente(String op, Cliente c) throws ClassNotFoundException, SQLException, IOException {
		Connection con = gDao.getConnection();

		String sql = "{CALL sp_cliente (?,?,?,?,?,?,?)}";
		CallableStatement cs = con.prepareCall(sql);
		cs.setString(1, op);
		cs.setString(2, c.getCpf());
		cs.setString(3, c.getNome());
		cs.setString(4, c.getEmail());
		cs.setFloat(5, c.getLimiteCredito());
		cs.setString(6, c.getDataNascimento());
		cs.registerOutParameter(7, Types.VARCHAR);
		cs.execute();

		String saida = cs.getString(7);

		cs.close();
		con.close();

		return saida;
	}

	@Override
	public Cliente consultaCliente(Cliente c) throws ClassNotFoundException, SQLException, IOException {
		Connection con = gDao.getConnection();
		
		String sql = "SELECT cpf, nome, email, limite_de_credito AS limite, dt_nascimento AS nascimento FROM cliente "
				+ "WHERE cpf = ?";
		
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setString(1, c.getCpf());
		
		ResultSet rs = ps.executeQuery();
		
		if(rs.next()) {
			c.setCpf(rs.getString("cpf"));
			c.setNome(rs.getString("nome"));
			c.setEmail(rs.getString("email"));
			c.setLimiteCredito(rs.getFloat("limite"));
			c.setDataNascimento(rs.getString("nascimento"));
		}
		
		rs.close();
		ps.close();
		con.close();
		return c;
	}

	@Override
	public List<Cliente> consultaClientes() throws ClassNotFoundException, SQLException, IOException {
		Connection con = gDao.getConnection();
		
		String sql = "SELECT cpf, nome, email, limite_de_credito AS limite, dt_nascimento AS nascimento FROM cliente ";
		
		PreparedStatement ps = con.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		
		List<Cliente> clientes = new ArrayList<Cliente>();
		
		while(rs.next()) {
			Cliente c = new Cliente();
			c.setCpf(rs.getString("cpf"));
			c.setNome(rs.getString("nome"));
			c.setEmail(rs.getString("email"));
			c.setLimiteCredito(rs.getFloat("limite"));
			c.setDataNascimento(rs.getString("nascimento"));
			clientes.add(c);
		}
		
		rs.close();
		ps.close();
		con.close();
		return clientes;
	}

}
