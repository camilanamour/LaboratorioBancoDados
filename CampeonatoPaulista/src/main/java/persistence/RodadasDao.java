package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Jogo;

public class RodadasDao implements IRodadasDao {

	private GenericDao gDao;

	public RodadasDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public String gerarRodadas() throws SQLException, ClassNotFoundException {
		Connection con = gDao.getConnection();

		String sql = "CALL sp_partidas (?)";
		CallableStatement cs = con.prepareCall(sql);
		cs.registerOutParameter(1, Types.VARCHAR);
		cs.execute();

		String saida = cs.getString(1);

		cs.close();
		con.close();
		return saida;
	}

	@Override
	public List<Jogo> listarRodada(String data) throws SQLException, ClassNotFoundException {
		List<Jogo> jogos = new ArrayList<Jogo>();

		Connection c = gDao.getConnection();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT j.codJogo AS cod, t1.nomeTime AS timeA, t2.nomeTime AS timeB, j.golsTimeA, j.golsTimeB, CONVERT(CHAR(10),j.data_jogo,103) AS datas");
		sql.append(" FROM jogos j, times t1, times t2");
		sql.append(" WHERE t1.codTime = j.codTimeA");
		sql.append(" AND t2.codTime = j.codTimeB");
		sql.append(" AND j.data_jogo = ?");
		
		PreparedStatement ps = c.prepareStatement(sql.toString());
		ps.setString(1, data);

		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Jogo j = new Jogo();
			j.setCodJogo(rs.getInt("cod"));
			j.setTimeA(rs.getString("timeA"));
			j.setTimeB(rs.getString("timeB"));
			j.setGolsTimeA(rs.getInt("golsTimeA"));
			j.setGolsTimeB(rs.getInt("golsTimeB"));
			j.setDataJogo(rs.getString("datas"));

			jogos.add(j);
		}
		return jogos;
	}

}
