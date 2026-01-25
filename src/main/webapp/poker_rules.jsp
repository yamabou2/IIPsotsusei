<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ポーカーのルール</title>
    <link rel="stylesheet" type="text/css" href="kazuya_style.css">
    
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
<body class="rulu_haikei">

<div class="container">

    <div class="panel rule">
        <h1>ポーカーのルール</h1>

        <ul class="basic-rule">
            <li>プレイヤーとＣＰＵに2枚ずつカードが配られます。</li>
            <li>役の組み合わせで勝敗が決まります。</li>
            <li>Aが一番強く、2が一番弱いです。</li>
            <li>マークの強さ：♠ &gt; ♥ &gt; ♦ &gt; ♣</li>
        </ul>

        <h2>役の強さ一覧</h2>

        <ul class="yaku-colored-list">
  <li class="rank1">ロイヤルストレートフラッシュ</li>
  <li class="rank2">ストレートフラッシュ</li>
  <li class="rank3">フォーカード</li>
  <li class="rank4">フルハウス</li>
  <li class="rank5">フラッシュ</li>
  <li class="rank6">ストレート</li>
  <li class="rank7">スリーカード</li>
  <li class="rank8">ツーペア</li>
  <li class="rank9">ワンペア</li>
  <li class="rank10">ハイカード</li>
</ul>


        <!-- 戻る -->
        <form action="PokerServlet" method="get">
            <button type="submit">スタート画面に戻る</button>
        </form>
    </div>

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
