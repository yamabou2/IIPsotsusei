<%@ page contentType="text/html; charset=UTF-8" %>
<%
    model.OthelloBoard board = (model.OthelloBoard) request.getAttribute("board");
    boolean[][] valid = (boolean[][]) request.getAttribute("valid");
    String msg = (String) request.getAttribute("msg");
    int black = (Integer) request.getAttribute("black");
    int white = (Integer) request.getAttribute("white");
    boolean first = Boolean.TRUE.equals(request.getAttribute("first"));
    String state = (String) request.getAttribute("state");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>オセロ</title>

<style>
html, body {
    margin: 0;
    height: 100%;
}

body {
    background-image: url('<%= request.getContextPath() %>/images/kaiga9.png');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    display: flex;
    justify-content: center;
    align-items: center;
}

/* ===== WIN / LOSE ===== */
.result {
    font-size: 72px;
    font-weight: bold;
    color: gold;
    text-shadow: 2px 2px 10px black;
    text-align: center;
}

/* ===== ゲームエリア ===== */
.game-area {
    background: rgba(255,255,255,0.75);
    padding: 20px 30px;
    border-radius: 16px;
    display: flex;
    gap: 30px;
    transition: opacity 1s ease, transform 1s ease;
}

.game-area.init {
    opacity: 0;
    transform: translateY(3cm);
}

.game-area.show {
    opacity: 1;
    transform: translateY(0);
}

.info {
    min-width: 200px;
}

table {
    border-collapse: collapse;
}

td {
    width: 60px;
    height: 60px;
    border: 2px solid #222;
    text-align: center;
}

.cell {
    width: 60px;
    height: 60px;
    background: green;
    border: none;
    cursor: pointer;
}

.black {
    width: 44px;
    height: 44px;
    background: black;
    border-radius: 50%;
    display: inline-block;
}

.white {
    width: 44px;
    height: 44px;
    background: #ddd;
    border-radius: 50%;
    display: inline-block;
}

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
window.addEventListener("load", () => {
    const area = document.querySelector(".game-area.init");
    if (area) {
        setTimeout(() => area.classList.add("show"), 200);
    }
});

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
</head>

<body>

<%-- ===== 勝敗画面 ===== --%>
<% if ("win".equals(state) || "lose".equals(state)) { %>

<div class="result">
    <%= msg %><br><br>

    <form method="post" action="game" style="display:inline;">
        <input type="hidden" name="action" value="continue">
        <button>続ける</button>
    </form>

    <% if ("win".equals(state)) { %>
    <form method="post" action="StoryServlet" style="display:inline;">
        <input type="hidden" name="current" value="higashi">
        <button>次へ</button>
    </form>
    <% } %>
</div>

<% } else { %>

<%-- ===== プレイ画面 ===== --%>
<div class="game-area <%= first ? "init" : "show" %>">

    <div class="info">
        <h3><%= msg %></h3>
        <p>黒: <%= black %>　白: <%= white %></p>

        <form method="post" action="game">
            <input type="hidden" name="action" value="restart">
            <button>リスタート</button>
        </form>

        <form method="post" action="StoryServlet">
            <input type="hidden" name="current" value="higashi">
            <button>ボコす</button>
        </form>
    </div>

    <table>
    <%
        for (int r = 0; r < model.OthelloBoard.SIZE; r++) {
    %>
        <tr>
        <%
            for (int c = 0; c < model.OthelloBoard.SIZE; c++) {
                int v = board.get(r, c);
        %>
            <td>
            <%
                if (v == model.OthelloBoard.BLACK) {
            %>
                <span class="black"></span>
            <%
                } else if (v == model.OthelloBoard.WHITE) {
            %>
                <span class="white"></span>
            <%
                } else if (valid[r][c]) {
            %>
                <form method="post" action="game" style="margin:0;">
                    <input type="hidden" name="r" value="<%= r %>">
                    <input type="hidden" name="c" value="<%= c %>">
                    <button class="cell"></button>
                </form>
            <%
                } else {
            %>
                <div class="cell"></div>
            <%
                }
            %>
            </td>
        <%
            }
        %>
        </tr>
    <%
        }
    %>
    </table>

</div>
<% } %>

</body>
</html>