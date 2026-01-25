<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Game Over</title>

<style>
body {
    margin: 0;
    padding: 0;
    background: black;
    color: white;
    font-family: "Yu Gothic", sans-serif;
    text-align: center;
    overflow: hidden;
    transition: opacity 2s ease; /* ← フェードアウト用 */
    opacity: 1;
}

/* メインメッセージ（優しい雰囲気） */
.gameover {
    position: absolute;
    top: 45%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size: 36px;
    opacity: 0;
    animation: fadeIn 2.5s forwards;
}

/* サブメッセージ */
.sub {
    position: absolute;
    top: 60%;
    left: 50%;
    transform: translateX(-50%);
    font-size: 20px;
    color: #dddddd;
    opacity: 0;
    animation: fadeIn 3s forwards 1.5s;
}

/* フェードイン */
@keyframes fadeIn {
    from { opacity: 0; }
    to   { opacity: 1; }
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

<div class="gameover">……勇者は力尽きてしまった。</div>
<div class="sub">しばらくして、タイトルへ戻ります。</div>

<script>
// 7秒後にフェードアウト開始
setTimeout(() => {
    document.body.style.opacity = 0; // ← フェードアウト

    // フェードアウト完了後に遷移（2秒後）
    setTimeout(() => {
        location.href = "index.jsp?skipLoading=true&showButtons=true";
    }, 2000);

}, 7000);

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