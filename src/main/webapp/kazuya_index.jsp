<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ポーカーゲーム</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/kazuya_style.css">
</head>
<body class="haikei">

<div class="container panel">
    <h1>ポーカーゲームへようこそ！</h1>
    <h3>ルールを確認してからゲームを始めましょう。</h3>

    <div class="start-buttons">
        <form action="PokerServlet" method="get">
            <input type="hidden" name="action" value="start">
            <button type="submit">ゲーム開始</button>
        </form>

        <form action="PokerServlet" method="get">
            <input type="hidden" name="action" value="rule">
            <button type="submit">ゲームルール</button>
        </form>
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
