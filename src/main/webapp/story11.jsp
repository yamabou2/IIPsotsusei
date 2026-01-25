<%@ page language="java" contentType="text/html; charset=UTF-8" %>  <!-- JSP設定 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> <!-- 文字コード -->
<title>ストーリー 11</title>
<link rel="stylesheet" type="text/css" href="story11.css"> <!-- 外部CSS -->
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

<body id="story11Body" class="bg-story11"> <!-- 背景はCSSで制御 -->

<!-- ボス画像＋粒子エフェクト領域 -->
<div class="enemy-image show" id="enemy">
    <img src="images/bosslose.png" class="enemy-img" id="bossImg"> <!-- ボス本体 -->
    <div id="particles"></div> <!-- 粒子生成用コンテナ -->
</div>

<!-- テキストボックス -->
<div class="textbox">
    <div id="story-text" class="story-text"></div> <!-- 文章表示領域 -->
</div>

<!-- 次へヒント -->
<div id="next-hint" class="next-hint">クリックで次へ</div>

<!-- StoryServlet 送信用フォーム -->
<form id="storyForm" action="StoryServlet" method="post" style="display:none;">
    <input type="hidden" name="current" value="story11">
</form>

<script>
// 最初の文章
const firstLine = "戦いが終わる。";

// 次の文章
const nextLines = ["男はその場に崩れ落ちる。", "「……」"];

let lineIndex = 0;   // 表示中の文章番号
let charIndex = 0;   // タイプライターの文字位置
let typing = false;  // タイピング中フラグ
const speed = 35;    // タイプ速度

/* タイプライター処理 */
function typeWriter(text) {
    typing = true;
    const target = document.getElementById("story-text");

    if (charIndex < text.length) {
        // 1文字ずつ表示（改行は <br>）
        target.innerHTML += (text[charIndex] === "\n") ? "<br>" : text[charIndex];
        charIndex++;
        setTimeout(() => typeWriter(text), speed);

    } else {
        typing = false;
        document.getElementById("next-hint").style.opacity = 1; // ヒント表示
    }
}

/* クリックで進行 */
document.addEventListener("click", () => {
    if (typing) return; // タイピング中は無視

    document.getElementById("next-hint").style.opacity = 0;

    // 次の文章へ
    if (lineIndex < nextLines.length) {
        document.getElementById("story-text").innerHTML = "";
        charIndex = 0;
        typeWriter(nextLines[lineIndex]);
        lineIndex++;
        return;
    }

    // ▼ 全文表示後：ボス死亡演出開始
    const boss = document.getElementById("bossImg");
    const particlesContainer = document.getElementById("particles");
    const enemy = document.getElementById("enemy");

    boss.classList.add("boss-die"); // ボス消滅アニメ開始

    // 衝撃波4連発（600ms間隔）
    for (let i = 0; i < 4; i++) {
        setTimeout(() => {
            const sw = document.createElement("div");
            sw.classList.add("shockwave"); // 衝撃波要素
            enemy.appendChild(sw);
            sw.style.animation = "shockwaveExpand 1.0s ease-out forwards"; // 拡大アニメ
            setTimeout(() => sw.remove(), 1000); // 1秒後削除
        }, i * 600);
    }

    // 粒子連続生成（2.4秒間）
    let particleInterval = setInterval(() => {
        for (let i = 0; i < 5; i++) {
            const p = document.createElement("div");
            p.classList.add("particle");

            // ランダム色
            const colors = ["#000000", "#8000ff", "#4b0082", "#ff0000"];
            p.style.background = colors[Math.floor(Math.random() * colors.length)];

            // ランダムサイズ
            const size = Math.random() * 15 + 3;
            p.style.width = size + "px";
            p.style.height = size + "px";

            // ランダム方向（CSS変数で飛ばす）
            p.style.setProperty("--tx", (Math.random() * 1000 - 500) + "px");
            p.style.setProperty("--ty", (Math.random() * 1000 - 500) + "px");

            particlesContainer.appendChild(p);
            p.style.animation = "particleFly 1.6s ease-out forwards"; // 飛散アニメ
            setTimeout(() => p.remove(), 1600); // 消滅
        }
    }, 15);

    // 2.4秒後：粒子生成停止 → 暗転 → 次のストーリーへ
    setTimeout(() => {
        clearInterval(particleInterval);

        const fade = document.getElementById("fadeout");
        fade.classList.add("active"); // 暗転開始

        setTimeout(() => {
            document.getElementById("storyForm").submit(); // StoryServletへ
        }, 1200);

    }, 2400);
});

/* ページ読み込み時 */
window.onload = () => {
    document.getElementById("next-hint").style.opacity = 0;
    typeWriter(firstLine); // 最初の文章
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

<!-- 暗転レイヤー -->
<div id="fadeout" class="fadeout-screen"></div>

</body>
</html>