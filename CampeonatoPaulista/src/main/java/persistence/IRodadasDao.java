package persistence;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import model.Jogo;

public interface IRodadasDao {

	public String gerarRodadas() throws SQLException, ClassNotFoundException;
	public List<Jogo> listarRodada(String data) throws SQLException, ClassNotFoundException;
	public int getRodada(Connection c, int rodada, String data) throws SQLException, ClassNotFoundException;
}
