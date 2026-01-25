package model;

import java.io.Serializable;

public class Egame implements Serializable{
	private int card;
	private int simin;
	private int killer;
	
	public Egame() {
		//ゲームスタート時の初期化
		card = 3;
		simin = 2;
		killer = 1;
	}

	public int getSimin() {
		return simin;
	}

	public void setSimin(int simin) {
		card--;
		this.simin = simin;
	}

	public int getKiller() {
		return killer;
	}

	public void setKiller(int killer) {
		card--;
		this.killer = killer;
	}

	public int getCard() {
		return card;
	}

	public void setCard(int card) {
		this.card = card;
	}
	
	
}
