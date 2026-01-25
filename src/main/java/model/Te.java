package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Te implements Serializable{
	private String te;
	private int cards;
	List<String> card;
	
	
	public Te() {
		cards = 3;
		card = new ArrayList<>(){{
			add("simin");
			add("simin");
			add("killer");
			}};
	}
	
	public String getTe() {
		return te;
	}

	public void setTe(String te) {
		this.te = te;
	}

	public List<String> getCard() {
		return card;
	}

	public void setCard(List<String> card) {
		this.card = card;
	}
	
	public int getCards() {
		return cards;
	}

	public void setCards(int cards) {
		this.cards = cards;
	}

	//pcの手札から1枚return、ArrayListから1枚削除
	public String logic() {
		int pcCard = (int)(Math.random() * getCards());
		String pcTe = card.get(pcCard);
		
		if(card.get(pcCard).equals("killer")) {
			setTe(pcTe);
			card.remove("killer");
		}else if(card.get(pcCard).equals("simin")) {
			setTe(pcTe);
			card.remove("simin");
		}
		cards--;
		
		return getTe();
	}
}
