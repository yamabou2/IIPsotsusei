<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  <!-- JSPページの基本設定（文字コードなど） -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> <!-- HTML文書の文字コード指定 -->
<title>ゲームタイトル画面</title> <!-- ブラウザタブに表示されるタイトル -->
<link rel="stylesheet" type="text/css"
    href="${pageContext.request.contextPath}/Style.css"> <!-- 外部CSS読み込み -->

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
    /* ★ 右上の外部リンク画像 */
    #externalLink {
        position: absolute; /* 画面右上に固定配置 */
        top: 20px;
        right: 20px;
        display: none; /* 最初は非表示 */
        z-index: 9999; /* 最前面に表示 */
    }

    #externalLink img {
        width: 90px; /* 画像サイズ */
        cursor: pointer; /* マウスカーソルをポインタに */
        opacity: 0.1; /* 初期は薄く表示 */
        transition: opacity 0.3s ease; /* ホバー時のフェードアニメ */
    }

    #externalLink img:hover {
        opacity: 1; /* ホバーで濃く表示 */
    }
</style>

</head>
<body>
    <!-- ローディング画面 -->
    <div id="loading"> <!-- ローディング全体のコンテナ -->
        <div class="kitou"> <!-- 祈祷中シルエットとテキスト -->
            <img src="${pageContext.request.contextPath}/images/シルエット改.png"
                alt="祈祷中シルエット">
            <div class="loading-text">Now Loading...</div> <!-- ローディング文字 -->
        </div>
        <div class="caution"> <!-- 注意書き・ヒント表示 -->
            【ヒント】<br>
            <br> 安全に冒険を楽しむために――<br> 部屋を明るくし、画面から距離をとりましょう。<br>
            長い旅の途中では、時に休息も必要です。<br> 目を閉じ、耳を澄ませば、<br>
            少女の祈りがあなたを導いてくれるでしょう。
        </div>
    </div>

    <!-- タイトル画面 -->
    <div id="titleScreen" onclick="showButtons()"> <!-- クリックでボタン表示 -->
        <header>
            <h1>TWISTED SCALE</h1> <!-- メインタイトル -->
            <h2 class="subtitle">― Conquer or Be Lost ―</h2> <!-- サブタイトル -->
        </header>

        <div id="clickToStart">
            --Click to Start--<br>(画面をクリックしてください) <!-- クリック誘導 -->
        </div>

        <div class="button-container" id="buttons"> <!-- ボタン群（初期非表示） -->
            <button onclick="goToStory()">ストーリー</button> <!-- ストーリー画面へ遷移 -->
        </div>
    </div>

    <!-- ★ 右上の外部リンク画像 -->
    <a id="externalLink" href="https://www.job-card.mhlw.go.jp/" target="_blank">
        <img src="${pageContext.request.contextPath}/images/job.png" alt="外部リンク">
    </a>

<script>

    /* URLパラメータ取得 */
    const params = new URLSearchParams(window.location.search); // URLの?以降を解析
    const skipLoading = params.get("skipLoading") === "true"; // ローディングスキップ判定
    const showButtonsFlag = params.get("showButtons") === "true"; // ボタン即表示判定

    /* ローディングスキップ処理 */
    if (skipLoading) {
        document.getElementById("loading").style.display = "none"; // ローディング非表示
        const titleScreen = document.getElementById("titleScreen");
        titleScreen.classList.add("show"); // タイトル画面を表示

        if (showButtonsFlag) {
            const clickText = document.getElementById("clickToStart");
            const buttons = document.getElementById("buttons");
            const externalLink = document.getElementById("externalLink");

            clickText.style.display = "none"; // 「Click to Start」非表示
            buttons.style.display = "flex"; // ボタン表示
            externalLink.style.display = "block"; // ★ 右上画像表示

            setTimeout(() => {
                buttons.classList.add("show"); // ボタンのフェードイン
            }, 50);
        }
    }

    /* 通常ローディング */
    if (!skipLoading) {
        setTimeout(() => { // ローディング画面を7秒表示
            const loading = document.getElementById("loading");
            const titleScreen = document.getElementById("titleScreen");

            loading.classList.add("fade-out"); // フェードアウト開始

            setTimeout(() => { // フェードアウト後に非表示
                loading.style.display = "none";
                titleScreen.classList.add("show"); // タイトル画面表示

                setTimeout(() => {
                    document.getElementById("clickToStart").classList.add("show"); // クリック誘導表示
                }, 800);

            }, 2000); // フェードアウト時間
        }, 7000); // ローディング表示時間
    }

    /* ボタン表示処理 */
    function showButtons() {
        const clickText = document.getElementById("clickToStart");
        const buttons = document.getElementById("buttons");
        const externalLink = document.getElementById("externalLink");

        if (buttons.classList.contains("show")) return; // 既に表示済みなら何もしない

        if (clickText.classList.contains("show")) { // 「Click to Start」が表示されている場合
            clickText.classList.remove("show"); // フェードアウト開始
            setTimeout(() => {
                clickText.style.display = "none"; // 完全に非表示
                buttons.style.display = "flex"; // ボタン表示

                externalLink.style.display = "block"; // ★ 右上画像表示

                setTimeout(() => {
                    buttons.classList.add("show"); // ボタンのフェードイン
                }, 50);
            }, 300); // フェードアウト時間
        }
    }

    /* ストーリー遷移 */
    function goToStory() {
        const elements = document.querySelectorAll(
            "#titleScreen h1, #titleScreen h2, #titleScreen button, #titleScreen #clickToStart"
        ); // タイトル画面の全要素を取得

        elements.forEach(el => {
            const x = (Math.random() - 0.5) * 200 + "px"; // ランダムなX方向飛散
            const y = (Math.random() - 0.5) * 200 + "px"; // ランダムなY方向飛散
            const rot = (Math.random() - 0.5) * 720 + "deg"; // ランダム回転
            el.style.setProperty("--x", x);
            el.style.setProperty("--y", y);
            el.style.setProperty("--rot", rot);
            el.classList.add("fly-out"); // 飛び散るアニメーションを適用
        });

        setTimeout(() => {
            location.href = 'login.jsp'; // 1秒後にストーリー画面へ遷移
        }, 1000);
    }

 // クリックした場所に波紋を出す
    document.addEventListener("click", function(e) {
        const ripple = document.createElement("div");
        ripple.classList.add("ripple");
        ripple.style.left = e.clientX + "px";
        ripple.style.top = e.clientY + "px";

        document.body.appendChild(ripple);

        ripple.addEventListener("animationend", () => ripple.remove());
    });

 // クリックした場所に波紋を出す
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