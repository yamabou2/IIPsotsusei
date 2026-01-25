<%@ page language="java" contentType="text/html; charset=UTF-8" %>  <!-- JSP設定 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> <!-- 文字コード -->
<title>ストーリー 10</title>

<link rel="stylesheet" type="text/css" href="story10.css"> <!-- 外部CSS -->
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

<!-- ★ 背景は CSS の .bg-story10 に任せる -->
<body id="story10Body" class="bg-story10">

    <!-- 勇者 -->
    <img src="images/透過装備全有.png" class="hero-image" id="hero">

    <!-- ★ SVG霧（ストーリー9と同じ構造） -->
    <div class="fog-wrap">
        <svg class="fog" viewBox="0 0 350 350">
            <defs>
                <!-- 霧の中心が白→外側黒のマスク -->
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

    <!-- ★ 敵画像（div で包む：オーラ演出用） -->
    <div class="enemy-image" id="enemy">
        <img src="images/t_lastboss.png" class="enemy-img">
    </div>

    <!-- テキストボックス -->
    <div class="textbox">
        <div id="story-text" class="story-text"></div> <!-- 文章表示領域 -->
    </div>

    <!-- 右下のヒント -->
    <div id="next-hint" class="next-hint">クリックで次へ</div>

    <!-- StoryServlet に送るフォーム（非表示） -->
    <form id="storyForm" action="StoryServlet" method="post" style="display:none;">
        <input type="hidden" name="current" value="story10">
    </form>

<script>
// ★ 表示する文章
const firstLine = "城の中は、異様な静けさに包まれていた。";

const nextLines = [
    "広間の奥、青白い霧が渦を巻いている。",
    "霧はゆっくりと形を取り、\nやがて一人の人間の姿へと変わった。",
    "「ここまで来たか」",
    "そう言って、静かに構えを取る。\nここからが、本当の勝負だ。"
];

let lineIndex = 0;   // 表示中の文章番号
let charIndex = 0;   // タイプライターの文字位置
let typing = false;  // タイピング中フラグ
const speed = 35;    // タイプ速度

/* タイプライター処理 */
function typeWriter(text) {
    typing = true;
    const target = document.getElementById("story-text");

    if (charIndex < text.length) {

        // ★ 霧が形を取る文章（nextLines[1]）の最後で霧が消えてボス登場
        if (lineIndex === 2 && charIndex === text.length - 1) {
            const fogWrap = document.querySelector(".fog-wrap");

            fogWrap.classList.add("fadeout"); // 霧をフェードアウト

            // 少し遅れてボス登場
            setTimeout(() => {
                document.getElementById("enemy").classList.add("show");
            }, 700);
        }

        // ★ 1文字ずつ表示（改行は <br>）
        target.innerHTML += (text[charIndex] === "\n") ? "<br>" : text[charIndex];
        charIndex++;
        setTimeout(() => typeWriter(text), speed);

    } else {
        typing = false;
        document.getElementById("next-hint").style.opacity = 1; // ヒント表示
    }
}

/* クリックで次の文章へ */
document.addEventListener("click", () => {
    if (typing) return; // タイピング中は無視

    document.getElementById("next-hint").style.opacity = 0;

    if (lineIndex < nextLines.length) {
        document.getElementById("story-text").innerHTML = "";
        charIndex = 0;
        typeWriter(nextLines[lineIndex]); // 次の文章
        lineIndex++;
        return;
    }

    // ▼ 全部終わったら暗転 → StoryServlet に送る
    const fade = document.getElementById("fadeout");
    fade.classList.add("active");

    setTimeout(() => {
        document.getElementById("storyForm").submit();
    }, 1200);
});

/* ページ読み込み時 */
window.onload = () => {
    document.getElementById("next-hint").style.opacity = 0;
    typeWriter(firstLine); // 最初の文章

    // 勇者フェードイン
    setTimeout(() => {
        document.getElementById("hero").classList.add("show");
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