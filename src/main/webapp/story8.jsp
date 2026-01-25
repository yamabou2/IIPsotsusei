<%@ page language="java" contentType="text/html; charset=UTF-8" %>  <!-- JSPページ設定 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> <!-- 文字コード指定 -->
<title>ストーリー 8</title> <!-- ページタイトル -->

<link rel="stylesheet" type="text/css" href="story8.css"> <!-- 外部CSS読み込み -->

<style>
/* 雷光エフェクト（画面全体を白くフラッシュ） */
.lightning-flash {
    position: fixed; /* 画面固定 */
    top: 0;
    left: 0;
    width: 100%; /* 全画面 */
    height: 100%;
    background: white; /* 白フラッシュ */
    opacity: 0; /* 初期は透明 */
    pointer-events: none; /* クリック無効 */
    z-index: 9000; /* 最前面 */
    transition: opacity 0.15s ease; /* フェード速度 */
}

.lightning-flash.active {
    opacity: 1; /* フラッシュ発動 */
}

/* 背景暗転（動画前の暗転） */
.fade-to-black::before {
    opacity: 0;
    transition: opacity 1s ease;
}

/* フェードなし動画（火花動画） */
.intro-video {
    display: none; /* 初期非表示 */
    opacity: 1 !important; /* フェード無効 */
    position: fixed;
    top: 0;
    left: 0;
    width: 100%; /* 全画面動画 */
    height: 100%;
    object-fit: cover; /* 画面にフィット */
    z-index: 5000; /* 前面 */
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

<body id="story8Body" class="bg-cliff"> <!-- 背景 cliff -->

<!-- ★ 全画面揺れ用ラッパー -->
<div id="shakeWrapper">

    <!-- 雷光エフェクト -->
    <div id="flash" class="lightning-flash"></div>

    <!-- 勇者画像 -->
    <img src="images/透過装備全有.png" class="hero-image" id="hero">

    <!-- 敵画像 -->
    <img src="images/doragon.png" class="enemy-image" id="enemy">

    <!-- 火花動画 -->
    <video id="introVideo" class="intro-video" muted>
        <source src="videos/hinoko.mp4" type="video/mp4">
    </video>

    <!-- テキストボックス -->
    <div class="textbox">
        <div id="story-text" class="story-text"></div> <!-- 文章表示領域 -->
    </div>

    <!-- 右下のヒント -->
    <div id="next-hint" class="next-hint">クリックで次へ</div>

</div>

<!-- ▼▼ StoryServlet に送るフォーム（非表示） ▼▼ -->
<form id="storyForm" action="StoryServlet" method="post" style="display:none;">
    <input type="hidden" name="current" value="story8"> <!-- 現在のストーリー番号 -->
</form>
<!-- ▲▲ ここまで ▲▲ -->

<!-- 暗転レイヤー（フェードアウト用） -->
<div id="fadeout" class="fadeout-screen"></div>

<script>
/* 文章構成（表示するテキスト） */

const firstLine = "城の外、断崖に面した広場に出る。"; /* 最初の一文 */

const beforeVideo =
"風が吹き荒れ、空は重く沈んでいる。\nその中央に、巨大な影があった。"; /* 動画前の文章 */

const afterVideoLines = [
    "巨体がこちらを向く。\n低い呼吸音が、大地を震わせる。",
    "ドラゴンは首を上げ、咆哮を放つ。\n空気が震え、城の外壁に反響する。",
    "逃げ場はない。\n城を背に、戦いが始まる。"
]; /* 動画後の文章 */

let phase = 0;      /* 進行フェーズ管理 */
let lineIndex = 0;  /* 表示する文章のインデックス */
let charIndex = 0;  /* タイプライターの文字位置 */
let typing = false; /* タイピング中フラグ */
const speed = 35;   /* タイプ速度 */

/* タイプライター処理 */
function typeWriter(text) {
    typing = true;
    const target = document.getElementById("story-text");

    if (charIndex < text.length) {
        /* 改行は <br> に変換 */
        target.innerHTML += (text[charIndex] === "\n") ? "<br>" : text[charIndex];
        charIndex++;
        setTimeout(() => typeWriter(text), speed); /* 次の文字へ */
    } else {
        typing = false;
        document.getElementById("next-hint").style.opacity = 1; /* ヒント表示 */
    }
}

/* クリックで進行 */
document.addEventListener("click", () => {

    if (typing) return; /* タイピング中は無視 */

    document.getElementById("next-hint").style.opacity = 0; /* ヒント消す */

    if (phase === 0) {

        if (lineIndex === 0) {
            /* 動画前の文章を表示 */
            document.getElementById("story-text").innerHTML = "";
            charIndex = 0;
            typeWriter(beforeVideo);
            lineIndex = 1;
            return;
        }

        if (lineIndex === 1) {
            /* 動画開始シーケンスへ */
            startVideoSequence();
            phase = 1;
            return;
        }
    }

    if (phase === 1) {

        if (lineIndex < afterVideoLines.length) {
            /* 動画後の文章を順に表示 */
            document.getElementById("story-text").innerHTML = "";
            charIndex = 0;
            typeWriter(afterVideoLines[lineIndex]);
            lineIndex++;
            return;
        }

        /* 全文表示後 → フェードアウト → 次のストーリーへ */
        document.getElementById("fadeout").classList.add("active");

        setTimeout(() => {
            document.getElementById("storyForm").submit(); /* サーブレットへ送信 */
        }, 1200);
    }
});

/* 3連続フラッシュ */
function tripleFlash(callback) {
    const flash = document.getElementById("flash");
    let count = 0;

    function doFlash() {
        flash.classList.add("active"); /* フラッシュON */

        setTimeout(() => {
            flash.classList.remove("active"); /* フラッシュOFF */
            count++;

            if (count < 3) {
                setTimeout(doFlash, 120); /* 次のフラッシュ */
            } else {
                callback(); /* 完了後コールバック */
            }
        }, 150);
    }

    doFlash();
}

/* 暗転 → 3連続フラッシュ → 動画再生 */
function startVideoSequence() {
    const body = document.getElementById("story8Body");

    body.classList.add("fade-to-black"); /* 暗転開始 */

    setTimeout(() => {
        tripleFlash(() => {
            startVideo(); /* フラッシュ後に動画開始 */
        });
    }, 800);
}

/* 動画開始 → 終了後に敵登場 */
function startVideo() {
    const video = document.getElementById("introVideo");

    video.style.display = "block"; /* 動画表示 */
    video.style.opacity = 1;

    video.play().catch(e => console.log("video.play() エラー:", e)); /* 再生 */

    video.onended = () => {

        video.style.display = "none"; /* 動画非表示 */

        const enemy = document.getElementById("enemy");
        const wrapper = document.getElementById("shakeWrapper");

        enemy.classList.add("enemy-pop"); /* 敵ポップ演出 */
        enemy.classList.add("show");

        /* 動画後の文章1行目を表示 */
        document.getElementById("story-text").innerHTML = "";
        charIndex = 0;
        lineIndex = 0;
        typeWriter(afterVideoLines[0]);
        lineIndex = 1;

        /* 画面揺れ演出 */
        setTimeout(() => {
            wrapper.classList.add("screen-shake");
        }, 50);

        setTimeout(() => {
            wrapper.classList.remove("screen-shake");
            enemy.classList.remove("enemy-pop");
        }, 550);
    };
}

/* ページ読み込み時の初期処理 */
window.onload = () => {
    document.getElementById("next-hint").style.opacity = 0; /* ヒント非表示 */

    setTimeout(() => {
        document.getElementById("hero").classList.add("show"); /* 勇者フェードイン */
    }, 400);

    setTimeout(() => {
        typeWriter(firstLine); /* 最初の文章表示 */
    }, 800);
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