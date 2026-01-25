<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
 <%
    String heroName = (String) session.getAttribute("username");
    if (heroName == null || heroName.isEmpty()) {
        heroName = "ゆうしゃさま";
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>コンティニュー</title>

<style>

/* ▼ 背景（黒＋光差し込み画像） ▼ */
body {
    margin: 0;
    padding: 0;
    background: black url('${pageContext.request.contextPath}/images/continue.png') no-repeat center top;
    background-size: cover;
    font-family: "Yu Gothic", sans-serif;
    color: white;

    /* ▼ ページ全体フェードイン ▼ */
    opacity: 0;
    animation: pageFadeIn 1.8s ease forwards;
}

@keyframes pageFadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

/* ▼ 天使画像 ▼ */
.angel {
    position: absolute;
    top: 15%;
    left: 50%;
    transform: translateX(-50%);
    width: 280px;
    opacity: 0;
    animation: fadeIn 2s ease forwards, float 3s ease-in-out infinite;
}

/* ▼ 天使の上下揺れアニメーション ▼ */
@keyframes float {
    0%   { transform: translate(-50%, 0); }
    50%  { transform: translate(-50%, -15px); }
    100% { transform: translate(-50%, 0); }
}

/* ▼ ページ全体フェードアウト（html に適用） ▼ */
html.fadeout {
    animation: fadeOut 2.2s ease forwards;
}

@keyframes fadeOut {
    from { opacity: 1; }
    to { opacity: 0; }
}

/* ▼ テキストボックス ▼ */
.text-box {
    position: absolute;
    bottom: 180px;
    left: 50%;
    transform: translateX(-50%);
    width: 80%;
    max-width: 700px;
    padding: 20px;
    background: rgba(0,0,0,0.6);
    border: 2px solid white;
    border-radius: 10px;
    font-size: 22px;
    line-height: 1.6;
    min-height: 120px;
}

/* ▼ ボタン ▼ */
.btn-area {
    position: absolute;
    bottom: 60px;
    left: 50%;
    transform: translateX(-50%);
    text-align: center;
    display: none;
}

.continue-btn {
    padding: 12px 40px;
    margin: 10px;
    font-size: 22px;
    cursor: pointer;
    border: none;
    border-radius: 8px;
    background: white;
    color: black;
    transition: 0.2s;
}

.continue-btn:hover {
    background: #ddd;
}

/* ▼ フェードイン（天使用） ▼ */
@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
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
<body>

<!-- 天使画像 -->
<img src="${pageContext.request.contextPath}/images/Angel-clear.png" class="angel">

<!-- テキストボックス -->
<div class="text-box" id="textBox"></div>

<!-- ボタン -->
<div class="btn-area" id="btnArea">
    <button class="continue-btn" onclick="startContinue()">復活する</button>

    <!-- ★ 修正済み：絶対パス -->
    <button class="continue-btn" onclick="location.href='${pageContext.request.contextPath}/gameover.jsp'">あきらめる</button>
</div>

<script>
// ▼ 表示する文章 ▼
const message =
`……<%= heroName %>しゃま、……。

ねんね、しちゃったの……？

でもね……まだ、おしまいじゃないよ。

いっしょに……もういちど、がんばろ……？`;

let index = 0;
const speed = 45;

function typeWriter() {
    const box = document.getElementById("textBox");

    if (index < message.length) {
        box.innerHTML += (message[index] === "\n") ? "<br>" : message[index];
        index++;
        setTimeout(typeWriter, speed);
    } else {
        // 文章が終わったらボタン表示
        document.getElementById("btnArea").style.display = "block";
    }
}

window.onload = () => {
    typeWriter();
};

// ▼ 復活ボタン演出：ページ全体フェードアウト → 遷移
function startContinue() {
    // ページ全体フェードアウト（html に付与）
    document.documentElement.classList.add("fadeout");

    // フェードアウト後に遷移
    setTimeout(() => {

        // ★ 修正済み：絶対パス
        location.href = '${pageContext.request.contextPath}/Quizindex.jsp';

    }, 2200);
}

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