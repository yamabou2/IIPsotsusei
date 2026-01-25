<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // ▼ 勇者名を決定（ログイン名 or ゲスト名）
    String heroName = (String) session.getAttribute("username");
    if (heroName == null || heroName.isEmpty()) {
        heroName = "フィルレイン"; // デフォルト名
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ストーリー</title>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Style.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/story.css">

</head>
<body id="storyBody">

    <div class="story-container">
        <div id="story-text" class="story-text"></div>
    </div>

    <!-- 右下の「クリックで次へ」案内 -->
    <div id="next-hint" class="next-hint">クリックで次へ</div>


    <!-- ▼▼ StoryServlet に送るフォーム（非表示） ▼▼ -->
    <form id="storyForm" action="StoryServlet" method="post" style="display:none;">
        <input type="hidden" name="current" value="story">
    </form>
    <!-- ▲▲ ここまで ▲▲ -->

    <script>
    function goBack() {
        location.href = "index.jsp?skipLoading=true&showButtons=true";
    }

    const pages = [
`この世界は、人々の選択によって均衡を保っている。
人々は正しさだけでなく、迷いや葛藤を抱えながらも選び続けることで、
平和な日常を築いてきた。

しかしある日、突如として異国の者が現れる。
彼は山の上に城のような建造物を築き、世界の均衡を歪める呪いを国中に広げていった。
人々の選択は狂わされ、民衆は恐怖に支配されていく。`,

`混乱の中、一人の女が立ち上がる。
「私が異国の者を倒し、この国にかけられた呪いを解く」

彼女は旅の中で数々の試練に直面し、時に選択を誤り、代償を払うことになる。
それでもなお選び続けた先に、彼女は真実へと辿り着く。

果たして彼女は、あらゆる試練を乗り越え、
歪められた世界の均衡を取り戻すことができるのか。
`
    ];

    let pageIndex = 0;
    let charIndex = 0;
    const speed = 35;
    let typing = false;

    function typeWriter() {

        const hint = document.getElementById("next-hint");
        hint.style.opacity = 0;
        hint.style.animation = "none";

        typing = true;
        const text = pages[pageIndex];
        const target = document.getElementById("story-text");

        if (charIndex < text.length) {
            if (text[charIndex] === "\n") {
                target.innerHTML += "<br>";
            } else {
                target.innerHTML += text[charIndex];
            }
            charIndex++;
            setTimeout(typeWriter, speed);
        } else {
            typing = false;

            hint.style.opacity = 1;
            hint.style.animation = "blink 1.4s ease-in-out infinite";
        }
    }

    document.addEventListener("click", () => {
        if (typing) return;

        pageIndex++;

        // ▼ 最後のページ → StoryServlet に送る
        if (pageIndex >= pages.length) {
            document.getElementById("storyForm").submit();
            return;
        }

        const hint = document.getElementById("next-hint");
        hint.style.opacity = 0;
        hint.style.animation = "none";

        document.getElementById("story-text").innerHTML = "";
        charIndex = 0;
        typeWriter();
    });

    window.onload = () => {
        const hint = document.getElementById("next-hint");
        hint.style.opacity = 0;
        hint.style.animation = "none";
        typeWriter();
    };
    </script>

</body>
</html>