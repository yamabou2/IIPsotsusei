<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ストーリー 6</title>

<link rel="stylesheet" type="text/css" href="story6.css">
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

<body id="story6Body" class="bg-grass">

    <!-- 勇者 -->
    <img src="images/透過装備全有.png" class="hero-image" id="hero">
    <div class="bubble" id="heroBubble"></div>

    <!-- 敵 -->
    <img src="images/toukapokerboss.png" class="enemy-image" id="enemy">
    <div class="bubble" id="enemyBubble"></div>

    <!-- テキストボックス -->
    <div class="textbox">
        <div id="story-text" class="story-text"></div>
    </div>

    <!-- 右下のヒント -->
    <div id="next-hint" class="next-hint">クリックで次へ</div>

    <!-- StoryServlet に送るフォーム -->
    <form id="storyForm" action="StoryServlet" method="post" style="display:none;">
        <input type="hidden" name="current" value="story6">
    </form>

<script>
const firstLine = "村を離れ、進んだ先に崖道が現れる。勇者は慎重に歩を進める。";

const nextLines = [
    "道の先に、女が立っていた。\n軽い身なりで、武器は持っていない。\nその手には、数枚のカード。",
    "次の瞬間、指先からカードが放たれた。\nカードは刃のように舞い、崖道に突き刺さる。",
    "意味の分からないまま、理解する。\nこれは戦いだ。",
    "勇者は剣を抜き、崖の上で、勝負が始まる。"
];

let lineIndex = 0;
let charIndex = 0;
let typing = false;
const speed = 35;

/* 吹き出し表示関数 */
function showBubble(id, text) {
    const bubble = document.getElementById(id);
    bubble.textContent = text;
    bubble.classList.add("show");
}

function typeWriter(text) {
    typing = true;
    const target = document.getElementById("story-text");

    if (charIndex < text.length) {

        // nextLines[0] の終わり付近で敵を出す
        if (lineIndex === 1 && charIndex === text.length - 3) {
            document.getElementById("enemy").classList.add("show");
        }

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

document.addEventListener("click", () => {
    if (typing) return;

    document.getElementById("next-hint").style.opacity = 0;

    /* ★ 次に表示する文章が nextLines[3]（戦闘開始）なら吹き出しを同時に出す */
    if (lineIndex === 3) {
        showBubble("heroBubble", "いざ、勝負！！");
        showBubble("enemyBubble", "ふふ、楽しませてね…");
    }

    if (lineIndex < nextLines.length) {
        document.getElementById("story-text").innerHTML = "";
        charIndex = 0;
        typeWriter(nextLines[lineIndex]);
        lineIndex++;
        return;
    }

    // 全部終わったら暗転
    const fade = document.getElementById("fadeout");
    fade.classList.add("active");

    setTimeout(() => {
        document.getElementById("storyForm").submit();
    }, 1200);
});

window.onload = () => {
    document.getElementById("next-hint").style.opacity = 0;
    typeWriter(firstLine);

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

<div id="fadeout" class="fadeout-screen"></div>

</body>
</html>