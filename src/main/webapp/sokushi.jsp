<%@ page language="java" contentType="text/html; charset=UTF-8" %>  <!-- JSP設定 -->

<%
    // セッションから勇者名を取得（未設定ならデフォルト名）
    String heroName = (String) session.getAttribute("username");
    if (heroName == null || heroName.isEmpty()) {
        heroName = "フィルレイン";
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> <!-- 文字コード -->
<title>即死攻撃シーン</title>
<link rel="stylesheet" type="text/css" href="sokushi.css"> <!-- 外部CSS -->
 <style>/* 波紋の基本スタイル */
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

<body id="killBody" class="bg-kill"> <!-- 背景はCSSで制御 -->

<!-- ボス画像（粒子コンテナ付き） -->
<div class="enemy-image show" id="enemy">
    <img src="images/t_lastboss.png" class="enemy-img" id="bossImg"> <!-- ボス本体 -->
    <div id="particles"></div> <!-- 粒子生成領域 -->
</div>

<!-- テキストボックス -->
<div class="textbox">
    <div id="story-text" class="story-text"></div> <!-- 文章表示領域 -->
</div>

<!-- 次へヒント -->
<div id="next-hint" class="next-hint">クリックで続ける</div>

<!-- ノイズレイヤー -->
<div id="noise"></div>

<!-- 画面割れ動画 -->
<video id="screenBreakVideo" class="screen-break-video" src="videos/noise_trim.mp4" muted></video>

<!-- 暗転レイヤー -->
<div id="fadeout" class="fadeout-screen"></div>

<script>
/* ============================
   セリフ処理（タイプライター）
============================ */
const lines = ["「その程度か……」"]; // 最初のセリフ
let lineIndex = 0;   // 現在の行
let charIndex = 0;   // タイピング位置
let typing = false;  // タイピング中フラグ
const speed = 35;    // タイプ速度

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

/* ============================
   クリックで進行
============================ */
document.addEventListener("click", () => {
    if (typing) return; // タイピング中は無視

    document.getElementById("next-hint").style.opacity = 0;

    // 次のセリフへ
    if (lineIndex < lines.length) {
        document.getElementById("story-text").innerHTML = "";
        charIndex = 0;
        typeWriter(lines[lineIndex]);
        lineIndex++;
        return;
    }

    // セリフ終了 → 即死攻撃演出へ
    triggerInstantKill();
});

/* ============================
   即死攻撃エフェクト一式
============================ */
let particleLoop, circleLoop;

function triggerInstantKill() {

    /* ★ ヒント非表示（アニメ停止） */
    const hint = document.getElementById("next-hint");
    hint.style.animation = "none";
    hint.style.opacity = 0;

    // 色反転フラッシュ
    document.body.classList.add("invert-flash");
    setTimeout(() => document.body.classList.remove("invert-flash"), 120);

    // 画面揺れ
    setTimeout(() => {
        document.body.classList.add("screen-shake");
        setTimeout(() => document.body.classList.remove("screen-shake"), 240);
    }, 120);

    // 血の赤み（赤黒い点滅）
    setTimeout(() => {
        document.body.classList.add("blood-tint");
        setTimeout(() => document.body.classList.remove("blood-tint"), 240);
    }, 240);

    // ボス心拍エフェクト
    setTimeout(() => document.getElementById("enemy").classList.add("heartbeat"), 480);

    // ノイズON
    setTimeout(() => document.getElementById("noise").classList.add("noise-on"), 540);

    // ★ テキストを強制的にグリッチ表示
    setTimeout(() => {
        const text = document.getElementById("story-text");
        text.classList.add("glitch-text");
        text.innerText = "理　解　不　能　な　力　が　侵　食　し　て　く　る　！！";
    }, 1500);

    // 粒子生成ループ開始
    setTimeout(() => { particleLoop = setInterval(spawnLoopParticles, 120); }, 1800);

    // ランダムshockwave生成
    setTimeout(() => { circleLoop = setInterval(spawnRandomCircle, 300); }, 2000);

    // テキストボックス破壊
    setTimeout(() => document.querySelector(".textbox").classList.add("textbox-break"), 2400);

    // テキスト溶解
    setTimeout(() => document.getElementById("story-text").classList.add("text-melt"), 2650);

    // 歪みエフェクト
    setTimeout(() => {
        document.body.classList.add("distort");
        setTimeout(() => document.body.classList.remove("distort"), 480);
    }, 2800);

    // 赤黒フラッシュ
    setTimeout(() => {
        document.body.classList.add("redblack-flash");
        setTimeout(() => document.body.classList.remove("redblack-flash"), 162);
    }, 3040);

    // ノイズOFF
    setTimeout(() => document.getElementById("noise").classList.remove("noise-on"), 3400);

    // ★ 画面割れ動画再生
    setTimeout(() => {
        const video = document.getElementById("screenBreakVideo");
        video.classList.add("active");
        video.currentTime = 0;
        video.play().catch(e => console.log("Video play error:", e));

        // 動画終了後 → 暗転 → continue.jsp へ
        video.onended = () => {
            clearInterval(particleLoop);
            clearInterval(circleLoop);

            const fade = document.getElementById("fadeout");
            fade.classList.add("active");

            setTimeout(() => {
                window.location.href = "continue.jsp";
            }, 1500);
        };
    }, 3300);
}

/* ============================
   粒子生成（破片）
============================ */
function spawnLoopParticles() {
    const container = document.getElementById("particles");
    const count = Math.floor(Math.random() * 5) + 6; // 6〜10個

    for (let i = 0; i < count; i++) {
        const p = document.createElement("div");
        p.classList.add("particle");

        // ランダム色
        const colors = ["#000000", "#4b0082", "#8000ff", "#550000", "#ffffff"];
        p.style.background = colors[Math.floor(Math.random() * colors.length)];

        // ランダムサイズ
        const size = Math.random() * 18 + 6;
        p.style.width = size + "px";
        p.style.height = size + "px";

        // ランダム方向（CSS変数）
        p.style.setProperty("--tx", (Math.random() * 1400 - 700) + "px");
        p.style.setProperty("--ty", (Math.random() * 1400 - 700) + "px");

        container.appendChild(p);
        p.style.animation = "particleFly 1.6s ease-out forwards";
        setTimeout(() => p.remove(), 1600);
    }
}

/* ============================
   shockwave（白 or 黒）
============================ */
function spawnRandomCircle() {
    const sw = document.createElement("div");
    sw.classList.add(Math.random() < 0.5 ? "white-shockwave" : "dark-shockwave");
    document.body.appendChild(sw);
    setTimeout(() => sw.remove(), 3000);
}

/* ============================
   初回セリフ
============================ */
window.onload = () => {
    document.getElementById("next-hint").style.opacity = 0;
    typeWriter(lines[0]); // 最初のセリフ
    lineIndex = 1;
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