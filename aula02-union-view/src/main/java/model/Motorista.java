package model;

public class Motorista {
	private int codigo;
	private String nome;
	private String naturalidade;
	
	public int getCodigo() {
		return codigo;
	}
	public void setCodigo(int codigo) {
		this.codigo = codigo;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public String getNaturalidade() {
		return naturalidade;
	}
	public void setNaturalidade(String naturalidade) {
		this.naturalidade = naturalidade;
	}
	
	@Override
	public String toString() {
		return "Motorista [codigo=" + codigo + ", nome=" + nome + ", naturalidade=" + naturalidade + "]";
	}
}
