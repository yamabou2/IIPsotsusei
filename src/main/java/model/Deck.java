

package model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Deck {
    private List<Card> cards = new ArrayList<>();
    private int index = 0;

    private static final String[] SUITS = {"♠","♥","♦","♣"};
    private static final String[] RANKS = {"2","3","4","5","6","7","8","9","10","J","Q","K","A"};

    public Deck() {
        for(String suit: SUITS) {
            for(String rank: RANKS) {
                cards.add(new Card(suit, rank));  // ✅ 修正済み
            }
        }
    }

    public void shuffle() {
        Collections.shuffle(cards);
        index = 0;
    }

    public Card draw() {
        if(index >= cards.size()) return null;
        return cards.get(index++);
    }
}
