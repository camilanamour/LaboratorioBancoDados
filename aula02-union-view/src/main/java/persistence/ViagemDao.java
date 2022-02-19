package persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.Motorista;
import model.Onibus;
import model.Viagem;

public class ViagemDao implements IViagemDao{
	
	GenericDao gDao;
	
	public ViagemDao(GenericDao gDao) {
		this.gDao=gDao;
	}

	/* 3) Criar uma View (Chamada v_descricao_onibus) 
	 * que mostre o Código da Viagem, o Nome do motorista, 
	 * a placa do ônibus (Formato XXX-0000), a Marca do ônibus, 
	 * o Ano do ônibus e a descrição do onibus
	 */

	@Override
	public Viagem consultaOnibusDescricao(Viagem v) throws ClassNotFoundException, SQLException {
		Connection c = gDao.getConnection();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT codigo, nome, placa, marca, ano, descricao ");
		sql.append("FROM v_descricao_onibus ");
		sql.append("WHERE codigo = ?");
		
		PreparedStatement ps = c.prepareStatement(sql.toString());
		ps.setInt(1, v.getCodigo());
		
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			Motorista m = new Motorista();
			m.setNome(rs.getString("nome"));
			
			Onibus o = new Onibus();
			o.setPlaca(rs.getString("placa"));
			o.setMarca(rs.getString("marca"));
			o.setAno(rs.getInt("ano"));
			o.setDescricao(rs.getString("descricao"));
			
			v.setCodigo(rs.getInt("codigo"));
			v.setMotorista(m);
			v.setOnibus(o);
			
		}
		
		rs.close();
		ps.close();
		c.close();
		return v;
	}
	
	/* 4) Criar uma View (Chamada v_descricao_viagem) que mostre o Código da viagem, 
	 * a placa do ônibus(Formato XXX-0000), a Hora da Saída da viagem (Formato HH:00), 
	 * a Hora da Chegada da viagem (Formato HH:00), partida e destino
	 */

	@Override
	public Viagem consultaViagemDescricao(Viagem v) throws ClassNotFoundException, SQLException{
		Connection c = gDao.getConnection();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT codigo, placa, saida, chegada, partida, destino ");
		sql.append("FROM v_descricao_viagem ");
		sql.append("WHERE codigo = ?");
		
		PreparedStatement ps = c.prepareStatement(sql.toString());
		ps.setInt(1, v.getCodigo());
		
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			
			Onibus o = new Onibus();
			o.setPlaca(rs.getString("placa"));
			
			v.setCodigo(rs.getInt("codigo"));
			v.setOnibus(o);
			v.setHora_saida(rs.getString("saida"));
			v.setHora_chegada(rs.getString("chegada"));
			v.setPartida(rs.getString("partida"));
			v.setDestino(rs.getString("destino"));
		}
		
		rs.close();
		ps.close();
		c.close();
		return v;
	}

}
