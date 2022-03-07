package persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Marca;

public class MarcaDao implements IMarcaDao{
	
	private GenericDao gDao;
	
	public MarcaDao(GenericDao gDao) {
		this.gDao = gDao;
	}
	
	@Override
	public String insereMarca(Marca m) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "INSERT INTO marca VALUES(?,?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, m.getId());
		ps.setString(2, m.getNome());
		ps.close();
		c.close();
		
		return "Marca inserida com sucesso";
	}

	@Override
	public String atualizaMarca(Marca m) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "UPDATE marca SET nome = ? WHERE id = ?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, m.getNome());
		ps.setInt(2, m.getId());
		ps.close();
		c.close();
		
		return "Marca atualizada com sucesso";
	}

	@Override
	public String excluiMarca(Marca m) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "DELETE marca WHERE id = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, m.getId());
		ps.close();
		c.close();
		
		return "Marca excluída com sucesso";
	}

	@Override
	public Marca consultaMarca(Marca m) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT id, nome FROM marca WHERE id = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, m.getId());
		
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			m.setId(rs.getInt("id"));
			m.setNome(rs.getString("nome"));
		}
		rs.close();
		ps.close();
		c.close();
		
		return m;
	}

	@Override
	public List<Marca> consultaMarcas() throws SQLException, ClassNotFoundException {
		List<Marca> marcas = new ArrayList<Marca>();
		
		Connection c = gDao.getConnection();
		String sql = "SELECT id, nome FROM marca";
		PreparedStatement ps = c.prepareStatement(sql);
		
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			Marca m = new Marca();
			m.setId(rs.getInt("id"));
			m.setNome(rs.getString("nome"));
			marcas.add(m);
		}
		rs.close();
		ps.close();
		c.close();
		
		return marcas;
	}

}
