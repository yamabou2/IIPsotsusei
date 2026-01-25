package model;

public class EgameLogic {

	//カード枚数減らす
	public String simin(Egame egame) {
		int cnt = egame.getSimin();
		egame.setSimin(cnt - 1);
		
		return "simin";
	}
	
	public void killer(Egame egame) {
		int cnt = egame.getKiller();
		egame.setKiller(cnt - 1);
	}
	

}
