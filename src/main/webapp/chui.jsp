<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>注意</title>

<style>
    body {
        margin: 0;
        padding: 0;
        height: 100vh;

        /* 背景画像（パスは適宜変更） */
        background-image: url("images/タイトル画面.png");
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;

        /* 中央配置 */
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;

        font-size: 30px;
        font-weight: bold;
        color: #fff;
        text-shadow: 0 0 5px #000;
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
このゲームは「クリック」しすぎると正常に動作しないことがあります。<br><br>
くれぐれもクリックのしすぎには、注意してください！！
<br>
(この画面は自動で進みます)

<script>
    setTimeout(() => {
    	location.href = "${pageContext.request.contextPath}/story.jsp";
    }, 6000);
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