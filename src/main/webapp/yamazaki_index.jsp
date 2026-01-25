<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>EgameTOP</title>

<style>
/* ここはあなたの CSS そのまま */
body.bg {
  background-image: url("images/haisonback.png");
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  background-attachment: fixed;
  margin: 0;
  padding: 0;
  font-family: "Arial", sans-serif;
}

.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  text-align: center;
}

.logo {
  margin-bottom: 50px;
  animation: float 3s ease-in-out infinite;
}

.menu {
  display: flex;
  gap: 40px;
  flex-wrap: wrap;
  justify-content: center;
}

.menu a img {
  width: 200px;
  border: 3px solid #fff;
  border-radius: 12px;
  box-shadow: 0 0 15px rgba(255,255,255,0.5);
  transition: transform 0.3s, box-shadow 0.3s;
}

.menu a img:hover {
  transform: scale(1.1);
  box-shadow: 0 0 25px rgba(255,255,255,0.8);
  cursor: pointer;
}

@keyframes float {
  0%   { transform: translateY(0px); }
  50%  { transform: translateY(-10px); }
  100% { transform: translateY(0px); }
}

.game-btn {
  background: linear-gradient(135deg, #d17000, #003000);
  border: none;
  padding: 10px 15px;
  font-size: 18px;
  font-weight: bold;
  border-radius: 12px;
  cursor: pointer;
  color: #222;
  box-shadow: 0 4px 12px rgba(0,0,0,0.3);
  transition: 0.2s;
}

.game-btn:hover {
  transform: scale(1.05);
  box-shadow: 0 6px 18px rgba(0,0,0,0.4);
}

.hidden {
  display: none;
}

#explainBox {
  width: 550px; 
  height: 200px;
  margin-top: 20px;
  padding: 16px;
  background: #ffffff;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.2);
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

<button id="explainBtn" class="game-btn">?</button>

<div id="explainBox" class="hidden">
  <p> このゲームは「皇帝」「市民」「奴隷」のカードを使った心理戦ゲーム！<br><br>
   🔹 皇帝は市民に勝つ<br>
   🔹 市民は奴隷に勝つ<br>
   🔹 奴隷は皇帝に勝つ<br><br>
   読み合いと駆け引きで勝利を目指そう！
  </p>
</div>

<div class="container">
  <div class="logo">
    <img src="images/egame.png" alt="egame logo" width="400">
  </div>

  <div class="menu">

    <!-- ★ ゲーム開始ボタン：mode は不要 -->
    <a href="GamingServlet?action=startEmperor">
        <img src="images/koutei.png" alt="皇帝モード">
    </a>

    <a href="GamingServlet?action=startDorei">
        <img src="images/doreiplate.png" alt="奴隷モード">
    </a>

  </div>
</div>

<script>
document.getElementById("explainBtn").addEventListener("click", () => {
  const box = document.getElementById("explainBox");
  box.classList.toggle("hidden");
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

</body>
</html>