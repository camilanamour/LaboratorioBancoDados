package persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Marca;
import model.Produto;

public class ProdutoDao implements IProdutoDao {

	private GenericDao gDao;

	public ProdutoDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public String insereProduto(Produto p) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "INSERT INTO produto VALUES(?,?,?,?)";
		
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, p.getId());
		ps.setString(2, p.getNome());
		ps.setFloat(3, p.getPreco());
		ps.setInt(4, p.getMarca().getId());
		
		ps.close();
		c.close();

		return "Produto inserido com sucesso";
	}

	@Override
	public String atualizaProduto(Produto p) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "UPDATE produto SET nome = ?, preco = ?, id_marca = ? WHERE id = ?)";
		
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, p.getNome());
		ps.setFloat(2, p.getPreco());
		ps.setInt(3, p.getMarca().getId());
		ps.setInt(4, p.getId());
		
		ps.close();
		c.close();

		return "Produto atualizado com sucesso";
	}

	@Override
	public String excluiProduto(Produto p) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "DELETE produto WHERE id = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, p.getId());
		
		ps.close();
		c.close();

		return "Produto excluído com sucesso";
	}

	@Override
	public Produto consultaProduto(Produto p) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT m.id, m.nome, p.id AS prod_id, p.nome AS prod_nome, p.preco");
		sql.append(" FROM produto p, marca m");
		sql.append(" WHERE m.id = p.id_marca");
		sql.append(" AND p.id = ?");
		
		PreparedStatement ps = c.prepareStatement(sql.toString());
		ps.setInt(1, p.getId());

		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			Marca m = new Marca();
			m.setId(rs.getInt("id"));
			m.setNome(rs.getString("nome"));
			
			p.setId(rs.getInt("prod_id"));
			p.setNome(rs.getString("prod_nome"));
			p.setPreco(rs.getFloat("preco"));
			p.setMarca(m);
		}
		rs.close();
		ps.close();
		c.close();

		return p;
	}

	@Override
	public List<Produto> consultaProdutos() throws SQLException, ClassNotFoundException {
		List<Produto> produtos = new ArrayList<Produto>();

		Connection c = gDao.getConnection();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT m.id, m.nome, p.id AS prod_id, p.nome AS prod_nome, p.preco");
		sql.append(" FROM produto p, marca m");
		sql.append(" WHERE m.id = p.id_marca");
		
		PreparedStatement ps = c.prepareStatement(sql.toString());

		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			Marca m = new Marca();
			m.setId(rs.getInt("id"));
			m.setNome(rs.getString("nome"));
			
			Produto p = new Produto();
			p.setId(rs.getInt("prod_id"));
			p.setNome(rs.getString("prod_nome"));
			p.setPreco(rs.getFloat("preco"));
			p.setMarca(m);
			
			produtos.add(p);
		}
		
		rs.close();
		ps.close();
		c.close();

		return produtos;
	}

}
