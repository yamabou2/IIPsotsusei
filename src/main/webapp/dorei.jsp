<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model.Egame" %>
<%@ page import="model.Te" %>
<%@ page import="model.EgameLogic" %>

<%
    Egame egame = (Egame)application.getAttribute("Egame");
    String playTe = (String)request.getAttribute("playTe");
    Te pcTe = (Te)session.getAttribute("pcTe");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>奴隷側</title>

<script>
  const messages = [
    "その選択、本当に“自分の意思”で選んだと思ってるのか",
    "オレは市民を出すよ。",
    "オレはもしここで勝ったら…きっちり足を洗う、だから…これが本当に最後のギャンブル",
    "神…救ってくれ…オレを助けてくれ…",
    "死地からの生還は、この世のものと思えぬほど甘美…！",
    "その『定石』という地点が…最も浅はかだ…",
    "震えてるぞ。興奮か？恐怖か？",
    "ああ…その顔だ。追い詰められた獲物の顔。最高だよ"
  ];

  function showRandomMessage() {
    const bubble = document.createElement("div");
    bubble.className = "speech-bubble";
    bubble.textContent = messages[Math.floor(Math.random() * messages.length)];
    document.body.appendChild(bubble);
    setTimeout(() => bubble.remove(), 3500);
  }

  setInterval(showRandomMessage, 8000);

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

<style>
/* あなたの CSS はそのまま */
.speech-bubble { 
position: absolute; 
top: 100px;
left: 380px;
background: #fff;
border: 2px solid #333;
border-radius: 10px;
padding: 12px 16px;
font-size: 16px;
font-weight: bold;
max-width: 220px;
box-shadow: 2px 2px 6px rgba(0,0,0,0.2);
z-index: 999;
animation: fadeInOut 4s ease-in-out;
}

.speech-bubble::before {
content: "";
position: absolute;
bottom: -15px;
left: 30px;
width: 0;
height: 0;
border: 10px solid transparent;
border-top-color: #fff;
border-bottom: 0;
margin-left: -10px;
filter: drop-shadow(0 -1px 1px rgba(0,0,0,0.2));
}

@keyframes fadeInOut {
  0% { opacity: 0; transform: translateX(-50%) translateY(-10px); }
  10% { opacity: 1; transform: translateX(-50%) translateY(0); }
  90% { opacity: 1; transform: translateX(-50%) translateY(0); }
  100% { opacity: 0; transform: translateX(-50%) translateY(-10px); }
}

body.bg {
  background-image: url("images/table2.jpg");
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  height: 100vh;
  margin: 0;
}

.item img, .item1 img { 
border: 1px solid rgba(255, 0, 0, 0.35);
border-radius: 12px;
background: linear-gradient(145deg, #1a1a1a, #0d0d0d);
box-shadow: 0 0 10px rgba(255, 0, 0, 0.25), inset 0 0 10px rgba(255, 0, 0, 0.15);
transition: transform .25s ease, box-shadow .25s ease, filter .25s ease;
}

.item img:hover {
transform: translateY(-6px) scale(1.08);
box-shadow: 0 0 25px rgba(255, 0, 0, 0.7), inset 0 0 15px rgba(255, 0, 0, 0.4);
filter: brightness(1.2);
}

.table {
display: flex;
justify-content: center;
align-items: center;
gap: 60px;
}

.table img {
max-width: 100%;
height: auto;
border-radius: 8px;
margin: 0px 20px 0px 20px;
}

.result{
display: flex;
justify-content: center;
align-items: center;
margin: 0px auto;
}

.result img {
  animation: pop 0.7s ease-out;
}

@keyframes pop {
  0% { transform: scale(0.5); opacity: 0; }
  100% { transform: scale(1); opacity: 1; }
}

main {
    margin: 0px auto 0px auto;
    max-width: 700px;
    padding-top: 200px;
}

.items {
    justify-items: center;
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 20px;
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
</head>

<body class="bg">
<main>

<!-- ★★★ 勝敗判定（3パターン） ★★★ -->
<% if(playTe != null && playTe.equals("simin") && pcTe.getTe() != null && pcTe.getTe().equals("killer")){ %>

<div class="table">
    <div class="item1"><img src="images/emperor.png"></div>
    <div class="item1"><img src="images/simin.png"></div>
</div>
<div class="result"><img src="images/lose.png"></div>

<!-- ★ StoryServlet に戻る -->
<div class="result">
    <form action="StoryServlet" method="post">
        <input type="hidden" name="current" value="yamazaki">
        <button type="submit" style="background:none;border:none;padding:0;">
            <img src="images/boko.png">
        </button>
    </form>
</div>

<% } else if(playTe != null && playTe.equals("killer") && pcTe.getTe() != null && pcTe.getTe().equals("killer")){ %>

<div class="table">
    <div class="item1"><img src="images/emperor.png"></div>
    <div class="item1"><img src="images/dorei.png"></div>
</div>
<div class="result"><img src="images/win.png"></div>

<div class="result">
    <form action="StoryServlet" method="post">
        <input type="hidden" name="current" value="yamazaki">
        <button type="submit" style="background:none;border:none;padding:0;">
            <img src="images/next.png">
        </button>
    </form>
</div>

<% } else if(playTe != null && playTe.equals("killer") && pcTe.getTe() != null && pcTe.getTe().equals("simin")){ %>

<div class="table">
    <div class="item1"><img src="images/simin.png"></div>
    <div class="item1"><img src="images/dorei.png"></div>
</div>
<div class="result"><img src="images/lose.png"></div>

<div class="result">
    <form action="StoryServlet" method="post">
        <input type="hidden" name="current" value="yamazaki">
        <button type="submit" style="background:none;border:none;padding:0;">
            <img src="images/boko.png">
        </button>
    </form>
</div>

<% } else { %>

<!-- ★★★ ゲーム継続中（手札表示） ★★★ -->

<!-- PC の手札 -->
<div class="items">
<% for(int i = 0; i < egame.getCard(); i++){ %>
    <div class="item1"><img src="images/card.png"></div>
<% } %>
</div>

<!-- 出したカード -->
<div class="table">
<% if(pcTe.getTe() != null && pcTe.getTe().equals("simin")){ %>
    <div class="item1"><img src="images/simin.png"></div>
<% } else if(pcTe.getTe() != null && pcTe.getTe().equals("killer")){ %>
    <div class="item1"><img src="images/emperor.png"></div>
<% } else { %>
    <div class="item1"><img src="images/card.png"></div>
<% } %>

<% if(playTe != null && playTe.equals("simin")){ %>
    <div class="item1"><img src="images/simin.png"></div>
<% } else if(playTe != null && playTe.equals("killer")){ %>
    <div class="item1"><img src="images/dorei.png"></div>
<% } else { %>
    <div class="item1"><img src="images/card.png"></div>
<% } %>
</div>

<!-- プレイヤーの手札 -->
<div class="items">

<% for(int i = 0; i < egame.getSimin(); i++){ %>
    <div class="item">
        <a href="GamingServlet?action=siminD">
            <img src="images/simin.png">
        </a>
    </div>
<% } %>

<% for(int i = 0; i < egame.getKiller(); i++){ %>
    <div class="item">
        <a href="GamingServlet?action=dorei">
            <img src="images/dorei.png">
        </a>
    </div>
<% } %>

</div>

<% } %>

</main>

</body>
</html>