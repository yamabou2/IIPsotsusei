

<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>じゃんけんゲーム</title>
  <link rel="stylesheet" href="J_style.css">
</head>
<body>

<%
    // ★ じゃんけん用のセッション変数を取得
    String player = (String) session.getAttribute("player");
    String cpu = (String) session.getAttribute("cpu");
    String result = (String) session.getAttribute("reresult");
    Boolean isAiko = (Boolean) session.getAttribute("isisAiko");

    // ★ mode を取得（story / minigame）
    String mode = (String) session.getAttribute("mode");
%>

<h1 class="main-title">じゃんけんゲーム</h1>

<!-- ★ 最初の表示（勝敗が未決定のとき） -->
<% if (result == null) { %>
  <div class="intro-wrapper">
    <div class="intro-sequence">
      <p class="intro-line">さいしょは</p>
    </div>
  </div>
<% } %>

<!-- ★ 勝敗が決まったとき -->
<% if (player != null && cpu != null) { %>
  <div class="result-wrapper">
    <div class="result-box">
      <h1 class="result-title">じゃんけんゲーム</h1>
      <p>あなた：<%= player %></p>
      <p>CPU：<%= cpu %></p>
      <h2><%= result %></h2>
    </div>
  </div>
<% } %>

<!-- ★ ボタン群 -->
<div class="button-area">
  <form action="JankenServlet" method="get">
    <button type="submit" name="hand" value="グー">グー</button>
    <button type="submit" name="hand" value="チョキ">チョキ</button>
    <button type="submit" name="hand" value="パー">パー</button>
  </form>

  <% if (isAiko != null && isAiko) { %>
    <form action="JankenServlet" method="get">
      <button type="submit">あいこでしょ！（もう一回）</button>
    </form>
  <% } %>

  <% if (result != null && (isAiko == null || !isAiko)) { %>
    <form action="JankenServlet" method="get">
  <input type="hidden" name="reset" value="true">
  <button type="submit">もう一度遊びたい</button>
</form>

  <% } %>
</div>

<!-- ★★★ 終了（TOP）ボタン：StoryServlet に渡す ★★★ -->
<% if (result != null && (isAiko == null || !isAiko)) { %>
<div style="margin-top:30px; text-align:center;">
    <form action="StoryServlet" method="post">
        <input type="hidden" name="current" value="janken">
        <input type="hidden" name="mode" value="<%= mode %>">
        <button type="submit" class="top-button">先へ</button>
    </form>
</div>
<% } %>
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
