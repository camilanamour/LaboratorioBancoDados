package br.edu.fatec.SpringFuncionario.model;

public class Dependente {
	private int codigo;
	private String nome;
	private float salario;
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
	public float getSalario() {
		return salario;
	}
	public void setSalario(float salario) {
		this.salario = salario;
	}
	@Override
	public String toString() {
		return "Dependente [codigo=" + codigo + ", nome=" + nome + ", salario=" + salario + "]";
	}
}
