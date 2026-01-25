<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Loading...</title>

    <!-- ✅ index.jsp と同じCSSを読み込む -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Style.css">

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
<body>

<!-- ✅ index.jsp の Loading 部分をそのままコピー -->
<div id="loading">
    <div class="kitou">
        <img src="${pageContext.request.contextPath}/images/シルエット改.png" alt="祈祷中シルエット">
        <div class="loading-text">Now Loading...</div>
    </div>
    <div class="caution">
        【ヒント】<br><br>
        安全に冒険を楽しむために――<br>
        部屋を明るくし、画面から距離をとりましょう。<br>
        長い旅の途中では、時に休息も必要です。<br>
        目を閉じ、耳を澄ませば、<br>
        少女の祈りがあなたを導いてくれるでしょう。
    </div>
</div>

<script>
    setTimeout(() => {
        location.href = "chui.jsp";
    }, 2000);

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