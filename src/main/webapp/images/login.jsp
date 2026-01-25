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
          href="/卒業制作-コレガチ/Style.css">
</head>

<body>
    <div class="login-wrapper">
        <h2>ログイン</h2>

        <!-- ▼ 通常ログインフォーム ▼ -->
        <form action="/卒業制作-コレガチ/LoginCheck"
              method="post"
              onsubmit="return particleOut(event)">

            <input type="text" name="username" placeholder="ユーザー名" required><br>
            <input type="password" name="password" placeholder="パスワード" required><br>

            <button type="submit">ログイン</button>
        </form>

        <!-- ▼ ゲストログインフォーム ▼ -->
        <form action="/卒業制作-コレガチ/LoginCheck"
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
    </script>

</body>
</html>