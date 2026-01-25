<%@ page language="java" contentType="text/html; charset=UTF-8" %>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ストーリー続き</title>

<link rel="stylesheet" type="text/css" href="story2.css">
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
<body id="story2Body">

    <!-- 勇者の立ち絵（最初は非表示） -->
    <img src="images/透過装備全有.png" class="hero-image" id="hero">
    <div class="bubble" id="heroBubble"></div>

    <!-- 敵の立ち絵（最初は非表示） -->
    <img src="images/T_Othelloboss.png" class="enemy-image" id="enemy">
    <div class="bubble" id="enemyBubble"></div>

    <!-- テキストボックス -->
    <div class="textbox">
        <div id="story-text" class="story-text"></div>
    </div>

    <!-- 右下の「クリックで次へ」 -->
    <div id="next-hint" class="next-hint">クリックで次へ</div>

    <!-- ▼▼ StoryServlet に送るフォーム（非表示） ▼▼ -->
    <form id="storyForm" action="StoryServlet" method="post" style="display:none;">
        <input type="hidden" name="current" value="story2">
    </form>
    <!-- ▲▲ ここまで ▲▲ -->

<script>
/* 最初の1文（黒背景で表示） */
const firstLine = "勇者は装備を整え、家を出た。";

/* 背景切替後の文章（段落ごとに分割） */
const nextLines = [
    "扉を開けると、草原が見えた。\n村を抜けた先に広がる、いつもと変わらない景色。",
    "草を踏み分け、少し進んだところで足を止める。",
    "草原に潜む敵が姿を現す。",
    "勇者は剣を抜き、草原の中央で戦闘が始まる。"
];

let phase = 0;          // 0 = 最初の一文, 1 = 草原会話
let lineIndex = 0;      // nextLines のどこまで進んだか
let charIndex = 0;
let typing = false;
const speed = 35;

/* タイプライター */
function typeWriter(text) {
    typing = true;
    const target = document.getElementById("story-text");

    if (charIndex < text.length) {
        if (text[charIndex] === "\n") {
            target.innerHTML += "<br>";
        } else {
            target.innerHTML += text[charIndex];
        }
        charIndex++;
        setTimeout(() => typeWriter(text), speed);
    } else {
        typing = false;
        document.getElementById("next-hint").style.opacity = 1;
    }
}

/* 吹き出し表示関数 */
function showBubble(id, text) {
    const bubble = document.getElementById(id);
    bubble.textContent = text;
    bubble.classList.add("show");
}

/* クリックで段落を進める */
document.addEventListener("click", () => {
    if (typing) return;

    document.getElementById("next-hint").style.opacity = 0;

    // フェーズ0 → 背景切替＋勇者登場＋nextLines[0]
    if (phase === 0) {
        phase = 1;

        document.getElementById("story2Body").classList.add("bg-grass");
        document.getElementById("hero").classList.add("show");

        document.getElementById("story-text").innerHTML = "";
        charIndex = 0;
        typeWriter(nextLines[0]);
        lineIndex = 1;
        return;
    }

    // フェーズ1 → nextLines を順番に表示
    if (phase === 1) {

        // 敵が出る段落（lineIndex === 2）
        if (lineIndex === 2) {
            document.getElementById("enemy").classList.add("show");
        }

        // 戦闘開始の行が終わったら吹き出し表示
        if (lineIndex === 3) {
            showBubble("heroBubble", "いざ、勝負！！");
            showBubble("enemyBubble", "さあ、おいで、、");
        }

        // まだ段落が残っている
        if (lineIndex < nextLines.length) {
            document.getElementById("story-text").innerHTML = "";
            charIndex = 0;
            typeWriter(nextLines[lineIndex]);
            lineIndex++;
            return;
        }

        // 全部の段落が終わった → 暗転してから StoryServlet に送る
        const fade = document.getElementById("fadeout");
        fade.classList.add("active");

        setTimeout(() => {
            document.getElementById("storyForm").submit();
        }, 1200);
    }
});

/* 最初の一文を表示 */
window.onload = () => {
    document.getElementById("next-hint").style.opacity = 0;
    typeWriter(firstLine);
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