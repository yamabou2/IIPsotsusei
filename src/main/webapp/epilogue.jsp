<%@ page language="java" contentType="text/html; charset=UTF-8" %>  <!-- JSP設定 -->

<%
    // セッションから勇者名を取得（未設定ならゲスト）
    String heroName = (String) session.getAttribute("username");
    if (heroName == null || heroName.isEmpty()) {
        heroName = "ゲスト";
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> <!-- 文字コード -->
<title>エピローグ</title>

<!-- 共通スタイル -->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Style.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/story.css">

<style>
/* ▼ エンドロール（短めスクロール） ▼ */
.endroll-container {
    position: fixed;
    top: 100%;                     /* 画面外から開始 */
    left: 50%;
    transform: translateX(-50%);
    width: 80%;
    color: white;
    font-size: 28px;
    line-height: 2.2;
    text-align: center;
    opacity: 0;
    z-index: 9999;
}

.endroll-active {
    animation: endrollScroll 30s linear forwards; /* 上へ流れる */
}

@keyframes endrollScroll {
    0%   { top: 100%; opacity: 1; }
    100% { top: -420%; opacity: 1; } /* 長いスクロール */
}

/* ▼ THE END（画像＋文字） ▼ */
.the-end {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -60%); /* 少し上に配置 */
    text-align: center;
    opacity: 0;                       /* 初期非表示 */
    z-index: 10000;
    transition: opacity 1.6s ease;    /* フェードイン */
}

.the-end.show {
    opacity: 1;                       /* 表示 */
}

.the-end-img {
    width: 800px;
    margin-bottom: 20px;
}

.the-end-text {
    font-size: 48px;
    color: white;
}

/* ▼ 暗転 ▼ */
.fade-black {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: black;
    opacity: 0;                       /* 初期透明 */
    pointer-events: none;
    transition: opacity 1.2s ease;
    z-index: 9000;
}
.fade-black.active {
    opacity: 1;                       /* フェードアウト */
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
<body id="storyBody">

<!-- 文章表示領域 -->
<div class="story-container">
    <div id="story-text" class="story-text"></div>
</div>

<!-- 次へヒント -->
<div id="next-hint" class="next-hint">クリックで次へ</div>

<!-- エンドロール本体 -->
<div id="endroll" class="endroll-container">
    【スタッフ】<br><br><br>

    -ストーリー考案-<br>
         れいちゃんCATALINA_BASE<br><br>

         <img src="images/HeroandBoss.png" style="width:300px;"><br><br>

    -プログラム-<br>
         スケさんTOMCAT<br>
         かずぴーutil=ALL-UNNAMED<br>
         れいちゃんCATALINA_BASE<br>
         ユーマプロトコルハンドラー<br><br>

         <img src="images/endrollpoker.png" style="width:300px;"><br><br>

    -デザイン-<br>
         スケさんTOMCAT<br>
         かずぴーutil=ALL-UNNAMED<br>
         れいちゃんCATALINA_BASE<br>
         ユーマプロトコルハンドラー<br><br>

         <img src="images/makeup_ojisan.png" style="width:300px;"><br><br>

    -テストプレイ-<br>
         スケさんTOMCAT<br>
         かずぴーutil=ALL-UNNAMED<br>
         れいちゃんCATALINA_BASE<br>
         ユーマプロトコルハンドラー<br><br>

         <img src="images/shugoushashin.png" style="width:460px;"><br><br>

    -Special Thanks-<br><%= heroName %><br>
    <br><br><br>
</div>

<!-- THE END 表示 -->
<div id="theEnd" class="the-end">
    <img src="images/endrollHero.png" class="the-end-img">
    <div class="the-end-text">THE END</div>
</div>

<!-- 暗転レイヤー -->
<div id="fadeBlack" class="fade-black"></div>

<!-- セッション破棄フォーム -->
<form id="resetSessionForm" action="resetSession" method="post" style="display:none;"></form>

<script>
// ▼ エピローグ文章（1ページのみ） ▼
const pages = [
`城を出ると、風が吹いた。

空はまだ曇っている。
だが、重さはない。

勇者は剣を下ろす。
遠くで、人の声がした気がした。

彼女は歩き出す。
選んできた道の、その先へ。`
];

// ▼ タイプライター制御 ▼
let pageIndex = 0;   // 現在のページ
let charIndex = 0;   // 文字位置
const speed = 60;    // タイプ速度
let typing = false;  // タイピング中フラグ

function typeWriter() {
    const hint = document.getElementById("next-hint");
    hint.style.opacity = 0;           // ヒント非表示
    hint.style.animation = "none";    // 点滅停止

    typing = true;
    const text = pages[pageIndex];
    const target = document.getElementById("story-text");

    if (charIndex < text.length) {
        // 1文字ずつ表示
        target.innerHTML += (text[charIndex] === "\n") ? "<br>" : text[charIndex];
        charIndex++;
        setTimeout(typeWriter, speed);
    } else {
        typing = false;
        hint.style.opacity = 1;       // ヒント表示
        hint.style.animation = "blink 1.4s ease-in-out infinite";
    }
}

// ▼ クリックで進行 ▼
document.addEventListener("click", () => {
    if (typing) return;

    pageIndex++;

    // ▼ 最後のページ → エンドロール開始
    if (pageIndex >= pages.length) {

        // 暗転開始
        document.getElementById("fadeBlack").classList.add("active");

        // 1.2秒後にエンドロール開始
        setTimeout(() => {
            document.getElementById("endroll").classList.add("endroll-active");
        }, 1200);

        // エンドロール終了後 → THE END 表示
        document.getElementById("endroll").addEventListener("animationend", () => {
            document.getElementById("theEnd").classList.add("show");

            // 6.5秒後 → セッション破棄 → タイトルへ戻る
            setTimeout(() => {
                document.getElementById("resetSessionForm").submit();
            }, 6500);
        });

        return;
    }

    // 次ページ準備
    document.getElementById("next-hint").style.opacity = 0;
    document.getElementById("next-hint").style.animation = "none";

    document.getElementById("story-text").innerHTML = "";
    charIndex = 0;
    typeWriter();
});

// ▼ 初回表示 ▼
window.onload = () => {
    document.getElementById("next-hint").style.opacity = 0;
    document.getElementById("next-hint").style.animation = "none";
    typeWriter();
};

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