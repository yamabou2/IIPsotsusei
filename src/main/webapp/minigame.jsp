<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ミニゲーム一覧</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/Style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/minigame.css?v=1">

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
</head>
<body id="minigameBody">

    <!-- ✅ タイトル -->
    <h1 class="minigame-title">ミニゲーム 一覧</h1>

    <!-- ✅ ゲーム選択ボックス -->
    <div class="minigame-selection">

        <!-- ✅ オセロ（ミニゲームとして遊ぶ） -->
        <div class="game-box" onclick="location.href='higashi_index.jsp?mode=minigame'">
            <span class="game-text">オセロゲーム</span>
            <img src="images/Othellobossup.png" class="hover-image">
        </div>
        
        <!-- ✅ Eゲーム（必要なら同じように mode=minigame を付ける） -->
        <div class="game-box" onclick="location.href='yamazaki_index.jsp?mode=minigame'">
            <span class="game-text">Eゲーム</span>
            <img src="images/boss.png" class="hover-image">
        </div>
        
        <!-- ✅ ポーカー（必要なら同じように mode=minigame を付ける） -->
        <div class="game-box" onclick="location.href='kazuya_index.jsp?mode=minigame'">
            <span class="game-text">ポーカー</span>
            <img src="images/pokerbossup.png" class="hover-image">
        </div>

    </div>

    <!-- ✅ 戻るボタン -->
    <div class="minigame-buttons">
        <button class="back-button" onclick="goBack()">戻る</button>
    </div>

    <script>
    function goBack() {
        location.href = "index.jsp?skipLoading=true&showButtons=true";
    }

 // クリックした場所に波紋を出す
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