<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ログイン</title>

    <!-- ログイン画面専用CSS -->
    <link rel="stylesheet" href="login.css">

    <!-- 共通スタイル -->
    <link rel="stylesheet" type="text/css"
          href="/0119c_groupA/Style.css">
          
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
    <div class="login-wrapper">
        <h2>ログイン</h2>

        <!-- ▼ 通常ログインフォーム ▼ -->
        <form action="/0119c_groupA/LoginCheck"
              method="post"
              onsubmit="return particleOut(event)">

            <input type="text" name="username" placeholder="ユーザー名" required><br>
            <input type="password" name="password" placeholder="パスワード" required><br>

            <button type="submit">ログイン</button>
        </form>

        <!-- ▼ ゲストログインフォーム ▼ -->
        <form action="/0119c_groupA/LoginCheck"
              method="post"
              onsubmit="return particleOut(event)"
              class="guest-form">

            <input type="hidden" name="guest" value="true">
            <button type="submit" class="guest-btn">ゲストログイン</button>
        </form>

        <% 
            String error = (String) request.getAttribute("error");
            if (error != null) { 
        %>
            <p class="error"><%= error %></p>
        <% } %>
    </div>

    <!-- 粒子エフェクト + 遅延送信 -->
    <script>
        function particleOut(event) {
            const box = document.querySelector(".login-wrapper");
            box.classList.add("particle");

            // アニメーション終了後にフォーム送信
            setTimeout(() => {
                event.target.closest("form").submit();   // ← 修正ポイント
            }, 600); // login.css のアニメ時間と合わせる

            return false; // すぐ送信させない
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