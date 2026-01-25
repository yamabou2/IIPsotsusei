//package model;
//
//import java.util.ArrayList;
//import java.util.Arrays;
//import java.util.Collection;
//import java.util.Collections;
//import java.util.HashMap;
//import java.util.HashSet;
//import java.util.List;
//import java.util.Map;
//import java.util.Set;
//
//public class PokerHandEvaluator {
//
//    public static int evaluate(List<Card> cards) {
//        // カウントマップ
//        Map<String, Integer> rankCount = new HashMap<>();
//        Map<String, Integer> suitCount = new HashMap<>();
//        List<Integer> rankValues = new ArrayList<>();
//
//        Map<String, Integer> rankMap = new HashMap<>();
//        String[] ranks = {"2","3","4","5","6","7","8","9","10","J","Q","K","A"};
//        for(int i=0;i<ranks.length;i++) rankMap.put(ranks[i], i+2); // 2=2, A=14
//
//        for(Card c : cards) {
//            rankCount.put(c.getRank(), rankCount.getOrDefault(c.getRank(),0)+1);
//            suitCount.put(c.getSuit(), suitCount.getOrDefault(c.getSuit(),0)+1);
//            rankValues.add(rankMap.get(c.getRank()));
//        }
//
//        Collections.sort(rankValues, Collections.reverseOrder());
//
//        boolean flush = suitCount.values().stream().anyMatch(v -> v>=5);
//
//        // ストレート判定
//        Set<Integer> uniqueRanks = new HashSet<>(rankValues);
//        List<Integer> sortedRanks = new ArrayList<>(uniqueRanks);
//        Collections.sort(sortedRanks);
//        boolean straight = false;
//        for(int i=0; i<=sortedRanks.size()-5; i++){
//            if(sortedRanks.get(i)+4 == sortedRanks.get(i+4) &&
//               sortedRanks.get(i+1) == sortedRanks.get(i)+1 &&
//               sortedRanks.get(i+2) == sortedRanks.get(i)+2 &&
//               sortedRanks.get(i+3) == sortedRanks.get(i)+3) {
//                straight = true;
//                break;
//            }
//        }
//        // A-5ストレート対応
//        if(!straight && uniqueRanks.contains(14) && uniqueRanks.contains(2) && uniqueRanks.contains(3) &&
//           uniqueRanks.contains(4) && uniqueRanks.contains(5)) straight = true;
//
//        // フォーカード、フルハウス、スリーカード、ツーペア、ワンペア
//        Collection<Integer> counts = rankCount.values();
//        boolean four = counts.contains(4);
//        boolean three = counts.contains(3);
//        int pairs = (int) counts.stream().filter(c -> c==2).count();
//
//        // 役判定
//        if(straight && flush) {
//            // ロイヤルストレートフラッシュ判定
//            if(sortedRanks.containsAll(Arrays.asList(10,11,12,13,14))) return 10;
//            return 9; // ストレートフラッシュ
//        } else if(four) return 8;
//        else if(three && pairs>=1) return 7; // フルハウス
//        else if(flush) return 6;
//        else if(straight) return 5;
//        else if(three) return 4;
//        else if(pairs>=2) return 3; // ツーペア
//        else if(pairs==1) return 2; // ワンペア
//        else return 1; // ハイカード
//    }
//
//    public static String getRankName(int rank) {
//        switch(rank){
//            case 1: return "ハイカード";
//            case 2: return "ワンペア";
//            case 3: return "ツーペア";
//            case 4: return "スリーカード";
//            case 5: return "ストレート";
//            case 6: return "フラッシュ";
//            case 7: return "フルハウス";
//            case 8: return "フォーカード";
//            case 9: return "ストレートフラッシュ";
//            case 10:return "ロイヤルストレートフラッシュ";
//            default:return "不明";
//        }
//    }
//
//    public static int compareHands(List<Card> hand1, List<Card> hand2, List<Card> community) {
//        int rank1 = evaluate(hand1WithCommunity(hand1, community));
//        int rank2 = evaluate(hand1WithCommunity(hand2, community));
//        return Integer.compare(rank1, rank2);
//    }
//
//    private static List<Card> hand1WithCommunity(List<Card> hand, List<Card> community) {
//        List<Card> all = new ArrayList<>(hand);
//        all.addAll(community);
//        return all;
//    }
//}



package model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class PokerHandEvaluator {

    private static final Map<String, Integer> rankMap = new HashMap<>();
    static {
        String[] ranks = {"2","3","4","5","6","7","8","9","10","J","Q","K","A"};
        for (int i = 0; i < ranks.length; i++) {
            rankMap.put(ranks[i], i + 2); // 2=2, A=14
        }
    }

    // ===== HandResult を返す完全版 evaluate =====
    public static HandResult evaluate(List<Card> cards) {

        // ランクとスートのカウント
        Map<Integer, Integer> rankCount = new HashMap<>();
        Map<String, Integer> suitCount = new HashMap<>();
        List<Integer> ranks = new ArrayList<>();

        for (Card c : cards) {
            int r = rankMap.get(c.getRank());
            ranks.add(r);
            rankCount.put(r, rankCount.getOrDefault(r, 0) + 1);
            suitCount.put(c.getSuit(), suitCount.getOrDefault(c.getSuit(), 0) + 1);
        }

        Collections.sort(ranks, Collections.reverseOrder());

        // ===== フラッシュ判定 =====
        String flushSuit = null;
        for (String s : suitCount.keySet()) {
            if (suitCount.get(s) >= 5) {
                flushSuit = s;
                break;
            }
        }

        // ===== ストレート判定 =====
        Set<Integer> unique = new HashSet<>(ranks);
        List<Integer> sorted = new ArrayList<>(unique);
        Collections.sort(sorted);

        int straightHigh = 0;
        for (int i = 0; i <= sorted.size() - 5; i++) {
            if (sorted.get(i) + 4 == sorted.get(i + 4)) {
                straightHigh = sorted.get(i + 4);
            }
        }
        // A-5 ストレート
        if (unique.contains(14) && unique.contains(2) && unique.contains(3)
                && unique.contains(4) && unique.contains(5)) {
            straightHigh = 5;
        }

        // ===== ストレートフラッシュ判定 =====
        int straightFlushHigh = 0;
        if (flushSuit != null) {
            List<Integer> flushRanks = new ArrayList<>();
            for (Card c : cards) {
                if (c.getSuit().equals(flushSuit)) {
                    flushRanks.add(rankMap.get(c.getRank()));
                }
            }
            Set<Integer> u2 = new HashSet<>(flushRanks);
            List<Integer> s2 = new ArrayList<>(u2);
            Collections.sort(s2);

            for (int i = 0; i <= s2.size() - 5; i++) {
                if (s2.get(i) + 4 == s2.get(i + 4)) {
                    straightFlushHigh = s2.get(i + 4);
                }
            }
            if (u2.contains(14) && u2.contains(2) && u2.contains(3)
                    && u2.contains(4) && u2.contains(5)) {
                straightFlushHigh = 5;
            }
        }

        // ===== 役判定 =====
        int strength = 1;
        String handName = "ハイカード";
        int mainRank = 0;
        List<Integer> kickers = new ArrayList<>();

        // フォーカード
        if (rankCount.containsValue(4)) {
            strength = 8;
            handName = "フォーカード";
            for (int r : rankCount.keySet()) {
                if (rankCount.get(r) == 4) mainRank = r;
            }
            for (int r : ranks) if (r != mainRank) kickers.add(r);
        }
        // フルハウス
        else if (rankCount.containsValue(3) && rankCount.containsValue(2)) {
            strength = 7;
            handName = "フルハウス";
            int three = 0, pair = 0;
            for (int r : rankCount.keySet()) {
                if (rankCount.get(r) == 3) three = Math.max(three, r);
                if (rankCount.get(r) == 2) pair = Math.max(pair, r);
            }
            mainRank = three;
            kickers.add(pair);
        }
        // フラッシュ
        else if (flushSuit != null) {
            strength = 6;
            handName = "フラッシュ";
            List<Integer> fr = new ArrayList<>();
            for (Card c : cards) {
                if (c.getSuit().equals(flushSuit)) fr.add(rankMap.get(c.getRank()));
            }
            Collections.sort(fr, Collections.reverseOrder());
            mainRank = fr.get(0);
            kickers = fr.subList(1, Math.min(5, fr.size()));
        }
        // ストレート
        else if (straightHigh > 0) {
            strength = 5;
            handName = "ストレート";
            mainRank = straightHigh;
        }
        // スリーカード
        else if (rankCount.containsValue(3)) {
            strength = 4;
            handName = "スリーカード";
            for (int r : rankCount.keySet()) {
                if (rankCount.get(r) == 3) mainRank = Math.max(mainRank, r);
            }
            for (int r : ranks) if (r != mainRank) kickers.add(r);
        }
        // ツーペア
        else if (Collections.frequency(rankCount.values(), 2) >= 2) {
            strength = 3;
            handName = "ツーペア";
            List<Integer> pairs = new ArrayList<>();
            for (int r : rankCount.keySet()) {
                if (rankCount.get(r) == 2) pairs.add(r);
            }
            Collections.sort(pairs, Collections.reverseOrder());
            mainRank = pairs.get(0);
            kickers.add(pairs.get(1));
            for (int r : ranks) if (!pairs.contains(r)) kickers.add(r);
        }
        // ワンペア
        else if (rankCount.containsValue(2)) {
            strength = 2;
            handName = "ワンペア";
            for (int r : rankCount.keySet()) {
                if (rankCount.get(r) == 2) mainRank = Math.max(mainRank, r);
            }
            for (int r : ranks) if (r != mainRank) kickers.add(r);
        }
        // ハイカード
        else {
            strength = 1;
            handName = "ハイカード";
            mainRank = ranks.get(0);
            kickers = ranks.subList(1, ranks.size());
        }

        return new HandResult(handName, strength, mainRank, kickers);
    }

    // ===== キッカー比較まで含めた勝敗判定 =====
    public static int compareHands(HandResult h1, HandResult h2) {

        if (h1.getStrength() != h2.getStrength()) {
            return Integer.compare(h1.getStrength(), h2.getStrength());
        }

        if (h1.getMainRank() != h2.getMainRank()) {
            return Integer.compare(h1.getMainRank(), h2.getMainRank());
        }

        List<Integer> k1 = h1.getKickers();
        List<Integer> k2 = h2.getKickers();

        for (int i = 0; i < Math.min(k1.size(), k2.size()); i++) {
            if (!k1.get(i).equals(k2.get(i))) {
                return Integer.compare(k1.get(i), k2.get(i));
            }
        }

        return 0;
    }
}
