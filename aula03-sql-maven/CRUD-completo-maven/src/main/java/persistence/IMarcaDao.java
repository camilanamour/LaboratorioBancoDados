package persistence;

import java.sql.SQLException;
import java.util.List;

import model.Marca;

public interface IMarcaDao {
	public String insereMarca(Marca m) throws SQLException, ClassNotFoundException;
	public String atualizaMarca(Marca m) throws SQLException, ClassNotFoundException;
	public String excluiMarca(Marca m) throws SQLException, ClassNotFoundException;
	public Marca consultaMarca(Marca m) throws SQLException, ClassNotFoundException;
	public List<Marca> consultaMarcas() throws SQLException, ClassNotFoundException;
}
