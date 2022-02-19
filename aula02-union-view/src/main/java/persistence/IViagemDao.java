package persistence;

import java.sql.SQLException;

import model.Viagem;

public interface IViagemDao {

	public Viagem consultaOnibusDescricao(Viagem v) throws ClassNotFoundException, SQLException;
	public Viagem consultaViagemDescricao(Viagem v) throws ClassNotFoundException, SQLException;
}
