<%@ page language="java" contentType="text/html; charset=UTF-8" %>  <!-- JSP設定 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> <!-- 文字コード -->
<title>ストーリー 9</title> <!-- タイトル -->

<link rel="stylesheet" type="text/css" href="story9.css"> <!-- 外部CSS -->

<style>
/* ★ fog-wrap の CSS は story9.css に任せる */

/* 回転アニメ（霧が回転） */
@keyframes fogRotate {
    from { transform: rotate(0deg); }
    to   { transform: rotate(360deg); }
}
.fog-rotate {
    animation: fogRotate 5s linear infinite; /* 無限回転 */
    transform-origin: 50% 50%; /* 中心回転 */
}

/* 左上へ飛ぶアニメ（霧が門へ流れる） */
@keyframes fogFlow {
    0% {
        transform: translate(0, 0) scale(1);
        opacity: 0.8; /* 最初は濃い */
    }
    100% {
        transform: translate(-500px, -300px) scale(0.6); /* 左上へ移動 */
        opacity: 0; /* 消える */
    }
}
.fog-flow {
    animation: fogFlow 2.5s ease-out forwards; /* 一度だけ流れる */
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

<body id="story9Body" class="bg-battle"> <!-- 戦闘背景 -->

    <!-- 勇者 -->
    <img src="images/透過装備全有.png" class="hero-image" id="hero">

    <!-- ドラゴン（暗め） -->
    <img src="images/doragon.png" class="enemy-image dark" id="enemy">

    <!-- ★ SVG霧（青白い霧の生成） -->
    <div class="fog-wrap">
        <svg class="fog" viewBox="0 0 350 350">
            <defs>
                <!-- 霧のマスク（中心が白→外側黒） -->
                <radialGradient id="fogMaskGradient">
                    <stop offset="55%" stop-color="white" />
                    <stop offset="100%" stop-color="black" />
                </radialGradient>

                <mask id="fogMask">
                    <rect width="350" height="350" fill="url(#fogMaskGradient)" />
                </mask>

                <!-- 霧のノイズ生成フィルタ -->
                <filter id="fogFilter">
                    <feTurbulence type="fractalNoise" baseFrequency="0.03" numOctaves="5" seed="5" result="noise" />
                    <feGaussianBlur in="noise" stdDeviation="12" result="blur" />
                    <feColorMatrix in="blur" type="matrix"
                        values="
                            0.2 0   0   0 0.6
                            0   0.3 0   0 0.7
                            0   0   1   0 1
                            0   0   0   1 0"
                        result="blueWhiteFog" />
                    <feBlend in="blueWhiteFog" in2="blueWhiteFog" mode="normal" />
                </filter>
            </defs>

            <!-- 霧本体（フィルタ＋マスク適用） -->
            <rect width="350" height="350"
                  filter="url(#fogFilter)"
                  fill="none"
                  mask="url(#fogMask)" />
        </svg>
    </div>

    <!-- テキストボックス -->
    <div class="textbox">
        <div id="story-text" class="story-text"></div>
    </div>

    <!-- 次へヒント -->
    <div id="next-hint" class="next-hint">クリックで次へ</div>

    <!-- サーブレット送信用フォーム -->
    <form id="storyForm" action="StoryServlet" method="post" style="display:none;">
        <input type="hidden" name="current" value="story9">
    </form>

<script>
/* 最初の文章 */
const firstLine = "ドラゴンは膝をつき、動きを止めた。";

/* 次の文章（順に表示） */
const nextLines = [
    "次の瞬間、その身体から青白い霧が溢れ出す。",
    "やがて一つの流れとなって、城の門へ向かっていく。\nドラゴンの身体は、力を失ったように崩れ落ちた。",
    "勇者は霧を見つめて、嫌な予感が確信へと変わる。",
    "彼女は城へと駆け出した。"
];

let lineIndex = 0;   /* 表示中の文章番号 */
let charIndex = 0;   /* タイプライターの文字位置 */
let typing = false;  /* タイピング中フラグ */
const speed = 35;    /* タイプ速度 */

/* タイプライター処理 */
function typeWriter(text) {
    typing = true;
    const target = document.getElementById("story-text");

    if (charIndex < text.length) {

        // ★ 霧発生（2行目の最後の文字で発動）
        if (lineIndex === 1 && charIndex === text.length - 1) {
            const fogWrap = document.querySelector(".fog-wrap");
            const fogSvg = fogWrap.querySelector("svg");

            fogWrap.style.opacity = "0.8";     /* 霧を濃く表示 */
            fogSvg.classList.add("fog-rotate"); /* 回転開始 */
        }

        // ★ 霧が城門へ流れる（3行目の最後の文字で発動）
        if (lineIndex === 2 && charIndex === text.length - 1) {
            const fogWrap = document.querySelector(".fog-wrap");
            const fogSvg = fogWrap.querySelector("svg");

            fogSvg.classList.remove("fog-rotate"); /* 回転停止 */
            fogWrap.classList.add("fog-flow");     /* 左上へ流れる */
        }

        /* 1文字ずつ表示（改行は <br>） */
        target.innerHTML += (text[charIndex] === "\n") ? "<br>" : text[charIndex];
        charIndex++;
        setTimeout(() => typeWriter(text), speed);

    } else {
        typing = false;
        document.getElementById("next-hint").style.opacity = 1; /* ヒント表示 */
    }
}

/* クリックで次の文章へ */
document.addEventListener("click", () => {
    if (typing) return; /* タイピング中は無視 */

    document.getElementById("next-hint").style.opacity = 0;

    if (lineIndex < nextLines.length) {
        document.getElementById("story-text").innerHTML = "";
        charIndex = 0;
        typeWriter(nextLines[lineIndex]); /* 次の文章 */
        lineIndex++;
        return;
    }

    /* 全文終了 → フェードアウト → 次のストーリーへ */
    const fade = document.getElementById("fadeout");
    fade.classList.add("active");

    setTimeout(() => {
        document.getElementById("storyForm").submit();
    }, 1200);
});

/* ページ読み込み時 */
window.onload = () => {
    document.getElementById("next-hint").style.opacity = 0;
    typeWriter(firstLine); /* 最初の文章 */

    /* 勇者・敵のフェードイン */
    setTimeout(() => {
        document.getElementById("hero").classList.add("show");
        document.getElementById("enemy").classList.add("show");
    }, 600);
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

<!-- フェードアウトレイヤー -->
<div id="fadeout" class="fadeout-screen"></div>

</body>
</html>