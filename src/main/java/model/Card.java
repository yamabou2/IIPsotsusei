package model;

public class Card {
    private String suit;  // ♠, ♥, ♦, ♣
    private String rank;  // 2~10, J, Q, K, A

    public Card(String suit, String rank) {
        this.suit = suit;
        this.rank = rank;
    }

    public String getSuit() {
        return suit;
    }

    public String getRank() {
        return rank;
    }
}
