<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // ▼ 勇者名（今は未使用だが将来拡張用に残してOK）
    String heroName = (String) session.getAttribute("username");
    if (heroName == null || heroName.isEmpty()) {
        heroName = "フィルレイン";
    }
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
    background-image: url('<%= request.getContextPath() %>/images/haikei8.png');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;

    display: flex;
    justify-content: center;
    align-items: center;
}

.start-box {
    background: rgba(255, 255, 255, 0.65);
    padding: 30px 50px;
    border-radius: 12px;
    text-align: center;
}

.start-box h1 {
    margin-bottom: 20px;
}

.start-box button {
    font-size: 18px;
    padding: 10px 30px;
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

<body>

<div class="start-box">
    <h1>オセロゲーム</h1>

    <!-- ★ 常に完全新規スタート -->
    <form action="game" method="get">
        <input type="hidden" name="mode" value="start">
        <button type="submit">ゲーム開始</button>
    </form>
</div>
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