
package Servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Card;
import model.HandResult;
import model.PokerHandEvaluator;

@WebServlet("/GameServlet")
public class GameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // ✅ デッキ生成
    private List<Card> createDeck() {
        String[] suits = {"♠", "♥", "♦", "♣"};
        String[] ranks = {"2","3","4","5","6","7","8","9","10","J","Q","K","A"};
        List<Card> deck = new ArrayList<>();
        for(String suit : suits) {
            for(String rank : ranks) {
                deck.add(new Card(suit, rank));
            }
        }
        Collections.shuffle(deck);
        return deck;
    }

    // ✅ 手札＋コミュニティカードをまとめる
    private List<Card> merge(List<Card> hand, List<Card> community) {
        List<Card> all = new ArrayList<>(hand);
        all.addAll(community);
        return all;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String stage = (String) session.getAttribute("stage");
        String action = request.getParameter("action");

        // ✅ セッション切れ対策
        if (stage == null) {
            action = null;
        }

        // ✅ 新しいゲーム開始
        if (action == null || "new".equals(action)) {

            List<Card> deck = createDeck();
            List<Card> playerHand = new ArrayList<>();
            List<Card> cpuHand = new ArrayList<>();
            List<Card> communityCards = new ArrayList<>();

            playerHand.add(deck.remove(0));
            playerHand.add(deck.remove(0));
            cpuHand.add(deck.remove(0));
            cpuHand.add(deck.remove(0));

            session.setAttribute("deck", deck);
            session.setAttribute("playerHand", playerHand);
            session.setAttribute("cpuHand", cpuHand);
            session.setAttribute("communityCards", communityCards);
            session.setAttribute("stage", "preflop");
            session.setAttribute("showCPU", false);
            session.setAttribute("result", null);

            // ✅ 役名をリセット
            session.setAttribute("playerHandName", null);
            session.setAttribute("cpuHandName", null);

        } else {

            List<Card> deck = (List<Card>) session.getAttribute("deck");
            List<Card> communityCards = (List<Card>) session.getAttribute("communityCards");
            List<Card> playerHand = (List<Card>) session.getAttribute("playerHand");
            List<Card> cpuHand = (List<Card>) session.getAttribute("cpuHand");

            // ✅ フロップ
            if ("flop".equals(action) && "preflop".equals(stage)) {
                communityCards.add(deck.remove(0));
                communityCards.add(deck.remove(0));
                communityCards.add(deck.remove(0));
                stage = "flop";
            }

            // ✅ ターン
            else if ("turn".equals(action) && "flop".equals(stage)) {
                communityCards.add(deck.remove(0));
                stage = "turn";
            }

            // ✅ リバー
            else if ("river".equals(action) && "turn".equals(stage)) {
                communityCards.add(deck.remove(0));
                stage = "river";
            }

            // ✅ オールイン or フォールド → 勝敗判定
            else if ("allin".equals(action) || "fold".equals(action)) {

                HandResult p = PokerHandEvaluator.evaluate(merge(playerHand, communityCards));
                HandResult c = PokerHandEvaluator.evaluate(merge(cpuHand, communityCards));

                String result;

                if ("fold".equals(action)) {
                    result = "フォールドしたため CPU の勝ち";
                } else {
                    int cmp = PokerHandEvaluator.compareHands(p, c);

                    if (cmp > 0) result = "あなたの勝ち！ (" + p.getHandName() + ")";
                    else if (cmp < 0) result = "CPUの勝ち… (" + c.getHandName() + ")";
                    else result = "引き分け (" + p.getHandName() + ")";
                }

                // ✅ 役名をセッションに保存（JSP が表示できるように）
                session.setAttribute("playerHandName", p.getHandName());
                session.setAttribute("cpuHandName", c.getHandName());

                session.setAttribute("result", result);
                session.setAttribute("showCPU", true);
                stage = "reset";
            }

            session.setAttribute("stage", stage);
        }

        request.getRequestDispatcher("game-poker.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
