package Servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.QuizQuestion;
import model.QuizSet;

@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        /* =========================
           クイズ開始
        ========================= */
        if ("start".equals(action)) {

            QuizSet set = QuizSet.createSample();

            // 全30問をリスト化
            List<QuizQuestion> all = new ArrayList<>();
            for (int i = 0; i < set.size(); i++) {
                all.add(set.getQuestion(i));
            }

            // シャッフル
            Collections.shuffle(all);

            // ランダム3問を確定
            List<QuizQuestion> quizList = all.subList(0, 3);

            session.setAttribute("quizList", quizList);
            session.setAttribute("index", 0);
            session.setAttribute("result", new String[]{"", "", ""});

            response.sendRedirect("QuizGame.jsp");
            return;
        }

        /* =========================
           回答処理
        ========================= */
        @SuppressWarnings("unchecked")
        List<QuizQuestion> quizList =
                (List<QuizQuestion>) session.getAttribute("quizList");
        Integer indexObj = (Integer) session.getAttribute("index");
        String[] result = (String[]) session.getAttribute("result");

        // セーフティ
        if (quizList == null || indexObj == null || result == null) {
            response.sendRedirect("Quizindex.jsp");
            return;
        }

        int index = indexObj;

        // 回答取得
        String ansStr = request.getParameter("answer");
        if (ansStr == null) {
            response.sendRedirect("QuizGame.jsp");
            return;
        }

        int answer = Integer.parseInt(ansStr);
        QuizQuestion q = quizList.get(index);

        /* =========================
           即死判定
        ========================= */
        if (!q.isCorrect(answer)) {
            result[index] = "×";
            session.setAttribute("result", result);
            response.sendRedirect("sokushi.jsp");
            return;
        }

        // 正解
        result[index] = "○";
        index++;

        session.setAttribute("index", index);
        session.setAttribute("result", result);

        /* =========================
           全問正解
        ========================= */
        if (index >= 3) {
            response.sendRedirect("story11.jsp");
            return;
        }

        // 次の問題へ
        response.sendRedirect("QuizGame.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Quizindex.jsp");
    }
}
