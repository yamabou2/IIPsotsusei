

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Card" %>
<html>
<head>
<meta charset="UTF-8">
<title>ポーカーゲーム</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/kazuya_style.css">
</head>
<body class="game">
<img src="images/mikata.PNG" class="character chara-left">
<img src="images/aite.PNG" class="character chara-right">

<div class="container panel">

    <h1>ポーカーゲーム</h1>
 
    <!-- プレイヤー手札 -->
    <div class="hand-section">
        <h2>あなたの手札</h2>
        <div class="cards">
        <%
            List<Card> playerHand = (List<Card>) session.getAttribute("playerHand");
            if(playerHand != null){
                for(Card c : playerHand){
                    String suit = c.getSuit();
                    String colorClass = (suit.contains("♥") || suit.contains("♦")) ? "red" : "black";
        %>
            <span class="card <%= colorClass %>"><%= c.getRank() + suit %></span>
        <%
                }
            }
        %>
        </div>
    </div>

    <!-- コミュニティカード -->
    <div class="hand-section">
        <h2>共通カード</h2>
        <div class="cards">
        <%
            List<Card> community = (List<Card>) session.getAttribute("communityCards");
            if(community != null){
                for(Card c : community){
                    String suit = c.getSuit();
                    String colorClass = (suit.contains("♥") || suit.contains("♦")) ? "red" : "black";
        %>
            <span class="card <%= colorClass %>"><%= c.getRank() + suit %></span>
        <%
                }
            }
        %>
        </div>
    </div>

    <!-- CPU手札 -->
    <div class="hand-section">
        <h2>CPUの手札</h2>
        <div class="cards">
        <%
            List<Card> cpuHand = (List<Card>) session.getAttribute("cpuHand");
            Boolean showCPU = (Boolean) session.getAttribute("showCPU");
            if(cpuHand != null){
                if(showCPU != null && showCPU){
                    for(Card c : cpuHand){
                        String suit = c.getSuit();
                        String colorClass = (suit.contains("♥") || suit.contains("♦")) ? "red" : "black";
        %>
            <span class="card <%= colorClass %>"><%= c.getRank() + suit %></span>
        <%
                    }
                } else {
                    for(int i = 0; i < cpuHand.size(); i++){
        %>
            <span class="card back">裏面</span>
        <%
                    }
                }
            }
        %>
        </div>
    </div>

    <!-- ✅ 役名表示（追加部分） -->
    <%
        String playerHandName = (String) session.getAttribute("playerHandName");
        String cpuHandName = (String) session.getAttribute("cpuHandName");
        String result = (String) session.getAttribute("result");

        if(playerHandName != null && cpuHandName != null){
    %>
        <div class="hand-rank">
            あなたの手：<%= playerHandName %><br>
            CPUの手：<%= cpuHandName %><br>
        </div>
    <% } %>

    <!-- ✅ 勝敗結果 -->
    <% if(result != null){ %>
        <div class="hand-rank"><%= result %></div>
    <% } %>

    <!-- ボタン -->
    <div class="button-section">
    <%
        String stage = (String) session.getAttribute("stage");

        if("preflop".equals(stage)){
    %>
        <form action="GameServlet" method="get">
            <button type="submit" name="action" value="flop">プリフロップ</button>
        </form>

    <%
        } else if("flop".equals(stage)){
    %>
        <form action="GameServlet" method="get">
            <button type="submit" name="action" value="turn">ターン</button>
        </form>

    <%
        } else if("turn".equals(stage)){
    %>
        <form action="GameServlet" method="get">
            <button type="submit" name="action" value="river">リバー</button>
        </form>

    <%
        } else if("river".equals(stage)){
    %>
        <form action="GameServlet" method="get">
            <button type="submit" name="action" value="allin">オールイン</button>
            <button type="submit" name="action" value="fold">フォールド</button>
        </form>

    <% } else if("reset".equals(stage)){ %>

    <form action="GameServlet" method="get">
        <button type="submit" name="action" value="new">リスタート</button>
    </form>

<form action="StoryServlet" method="post">
    <input type="hidden" name="current" value="kazuya">
    <button type="submit">次へ</button>
</form>


<% } %>

    </div>

</div>
<style>
 /* 波紋の基本スタイル */
    .ripple {
        position: absolute;
        width: 10px;
        height: 10px;
        background: rgba(255, 255, 255, 0.9);
        border-radius: 50%;
        transform: scale(0);
        pointer-events: none;
        animation: rippleEffect 0.6s ease-out forwards;
    }

    /* 波紋アニメーション */
    @keyframes rippleEffect {
        to {
            transform: scale(8);
            opacity: 0;
        }
    }

</style>
<script>
//クリックした場所に波紋を出す
document.addEventListener("click", function(e) {
    const ripple = document.createElement("div");
    ripple.classList.add("ripple");
    ripple.style.left = e.clientX + "px";
    ripple.style.top = e.clientY + "px";

    document.body.appendChild(ripple);

    ripple.addEventListener("animationend", () => ripple.remove());
});
</script>
</body>
</html>



