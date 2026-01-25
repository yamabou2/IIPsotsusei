<%@ page language="java" contentType="text/html; charset=UTF-8" %>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ストーリー 3</title>

<link rel="stylesheet" type="text/css" href="story3.css">
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

<body id="story3Body" class="bg-grass">

    <!-- 勇者 -->
    <img src="images/透過装備全有.png" class="hero-image" id="hero">

    <!-- 敵 -->
    <img src="images/T_Othelloboss.png" class="enemy-image dark" id="enemy">

    <!-- テキストボックス -->
    <div class="textbox">
        <div id="story-text" class="story-text"></div>
    </div>

    <!-- 右下の「クリックで次へ」 -->
    <div id="next-hint" class="next-hint">クリックで次へ</div>

    <!-- ▼▼ StoryServlet に送るフォーム（非表示） ▼▼ -->
    <form id="storyForm" action="StoryServlet" method="post" style="display:none;">
        <input type="hidden" name="current" value="story3">
    </form>
    <!-- ▲▲ ここまで ▲▲ -->

<script>
const firstLine = "戦いが終わると、草原には再び静けさが戻った。";

const nextLines = [
    "風が吹き、踏み倒された草がゆっくりと起き上がる。",
    "勇者は剣を下ろし、息を整えまた歩き出す。\n次の場所へ向かうために。",
    
];

let lineIndex = 0;
let charIndex = 0;
let typing = false;
const speed = 35;

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

document.addEventListener("click", () => {
    if (typing) return;

    document.getElementById("next-hint").style.opacity = 0;

    if (lineIndex < nextLines.length) {
        document.getElementById("story-text").innerHTML = "";
        charIndex = 0;
        typeWriter(nextLines[lineIndex]);
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

window.onload = () => {
    document.getElementById("next-hint").style.opacity = 0;
    typeWriter(firstLine);

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

<div id="fadeout" class="fadeout-screen"></div>

</body>
</html>