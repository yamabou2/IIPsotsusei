<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.*" %>

<%
    @SuppressWarnings("unchecked")
    List<QuizQuestion> quizList =
            (List<QuizQuestion>) session.getAttribute("quizList");
    Integer indexObj = (Integer) session.getAttribute("index");
    String[] result = (String[]) session.getAttribute("result");

    if (quizList == null || indexObj == null || result == null) {
        response.sendRedirect("Quizindex.jsp");
        return;
    }

    int index = indexObj;
    QuizQuestion q = quizList.get(index);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quiz</title>

<style>
html, body {
    margin: 0;
    height: 100%;
    font-family: sans-serif;
}

/* 背景 */
body {
    background-image: url("<%= request.getContextPath() %>/images/quiz.png");
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
}

/* 黒系オーバーレイ */
.overlay {
    min-height: 100%;
    background: rgba(0, 0, 0, 0.30);
    color: #fff;
}

/* 上部 */
.top {
    display: flex;
    justify-content: flex-end;
    padding: 20px;
}

.result {
    display: flex;
    gap: 10px;
}

.square {
    width: 40px;
    height: 40px;
    border: 2px solid #fff;
    text-align: center;
    line-height: 40px;
    font-size: 20px;
}

/* 下部固定 */
.bottom {
    position: fixed;
    bottom: 0;
    width: 100%;
    padding-bottom: 20px;
}

/* 問題 */
.question {
    margin: 20px 30px;
    font-size: 22px;
}

/* 選択肢 */
.choices {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 15px;
    margin: 20px 30px;
}

.choice {
    border: 2px solid #fff;
    padding: 15px;
    cursor: pointer;
    background: rgba(0,0,0,0.4);
}

.choice:hover {
    background: rgba(255,255,255,0.15);
}

.choice input {
    margin-right: 10px;
}

/* 回答 */
.submit {
    text-align: center;
    margin-top: 10px;
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
<div class="overlay">

<div class="top">
    <div class="result">
        <% for (int i = 0; i < 3; i++) { %>
            <div class="square"><%= result[i] %></div>
        <% } %>
    </div>
</div>

<div class="bottom">

    <div class="question">
        Q<%= index + 1 %>. <%= q.getQuestion() %>
    </div>

    <form method="post" action="quiz">
        <div class="choices">
            <% for (int i = 0; i < 4; i++) { %>
                <label class="choice">
                    <input type="radio" name="answer" value="<%= i %>" required>
                    <%= q.getChoices()[i] %>
                </label>
            <% } %>
        </div>

        <div class="submit">
            <button type="submit">回答</button>
        </div>
    </form>

</div>
</div>
<script>
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
