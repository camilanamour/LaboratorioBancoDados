package persistence;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import model.Cliente;

public interface IClienteDao {

	public String iudCliente(String op, Cliente c) throws ClassNotFoundException, SQLException, IOException;
	public Cliente consultaCliente(Cliente c) throws ClassNotFoundException, SQLException, IOException;
	public List<Cliente> consultaClientes() throws ClassNotFoundException, SQLException, IOException;
}
