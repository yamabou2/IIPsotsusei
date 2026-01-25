
package model;

import java.util.List;

public class HandResult {
    private String handName;     // 役名
    private int strength;        // 役の強さ（1〜10）
    private int mainRank;        // 役の中心ランク（ペアのランクなど）
    private List<Integer> kickers; // キッカー（降順）

    public HandResult(String handName, int strength, int mainRank, List<Integer> kickers) {
        this.handName = handName;
        this.strength = strength;
        this.mainRank = mainRank;
        this.kickers = kickers;
    }

    public String getHandName() { return handName; }
    public int getStrength() { return strength; }
    public int getMainRank() { return mainRank; }
    public List<Integer> getKickers() { return kickers; }
}

