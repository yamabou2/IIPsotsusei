<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quiz</title>

<style>
html, body {
    margin: 0;
    height: 100%;
}

/* 背景 */
body {
    background-image: url("<%= request.getContextPath() %>/images/quiz.png");
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
}

/* ============================
   黒い衝撃波（画面中央から永遠に）
============================ */
.shockwave {
    position: fixed;
    top: 47%;
    left: 72%;
    width: 120px;
    height: 120px;
    border: 2px solid rgba(0, 0, 0, 0.3);
    border-radius: 50%;
    transform: translate(-50%, -50%);
    opacity: 0.25;
    pointer-events: none; /* ← ボタン操作の邪魔をしない */
    animation: shock 3s linear infinite;
}

@keyframes shock {
    0% {
        transform: translate(-50%, -50%) scale(0.4);
        opacity: 0.35;
    }
    100% {
        transform: translate(-50%, -50%) scale(20);
        opacity: 0;
    }
}

/* クイズ開始ボタン配置 */
.start-box {
    position: fixed;
    bottom: 20px;
    left: 50%;
    transform: translateX(-50%);
}

/* ボタン */
button {
    padding: 20px 60px;
    font-size: 18px;
    border-radius: 12px;
    border: none;
    background: rgba(0, 0, 0, 0.6);
    color: #fff;
    cursor: pointer;
    outline: none;
}

/* ホバー */
button:hover {
    background: rgba(0, 0, 0, 0.8);
}

/* フォーカス時の枠も完全に消す */
button:focus {
    outline: none;
    box-shadow: none;
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

<!-- ★ 衝撃波（等間隔で永遠に出続ける） -->
<div class="shockwave" style="animation-delay: 0s;"></div>
<div class="shockwave" style="animation-delay: 0.8s;"></div>
<div class="shockwave" style="animation-delay: 1.6s;"></div>

<div class="start-box">
    <form action="quiz" method="post">
        <input type="hidden" name="action" value="start">
        <button type="submit">クイズ開始</button>
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