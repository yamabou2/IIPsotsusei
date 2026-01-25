package model;

import java.util.ArrayList;
import java.util.List;

public class Player {
    private List<String> hand;

    public Player() {
        hand = new ArrayList<>();
    }

    public void addCard(String card) {
        hand.add(card);
    }

    public List<String> getHand() {
        return hand;
    }
}
