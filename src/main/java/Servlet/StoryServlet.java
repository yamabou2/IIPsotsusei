package Servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/StoryServlet")
public class StoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // どの画面から来たか
        String current = request.getParameter("current");

        String next = "";

        // ▼ ストーリー遷移管理（mode は廃止）
        switch (current) {

            case "story":
                next = "story2.jsp";
                break;

            case "story2":
                next = "higashi_index.jsp"; // ゲーム1
                break;

            case "higashi":
                next = "story3.jsp";
                break;

            case "story3":
                next = "story4.jsp";
                break;

            case "story4":
                next = "yamazaki_index.jsp"; // ゲーム2
                break;

            case "yamazaki":
                next = "story5.jsp";
                break;

            case "story5":
                next = "story6.jsp";
                break;

            case "story6":
                next = "kazuya_index.jsp"; // ゲーム3
                break;

            case "kazuya":
                next = "story7.jsp";
                break;

            case "story7":
                next = "story8.jsp";
                break;

            case "story8":
                next = "kazuyaJ_index.jsp"; // じゃんけんゲーム入口
                break;

            case "janken":
                next = "story9.jsp"; // じゃんけん終了後
                break;
                
            case "story9":
                next = "story10.jsp"; // じゃんけん終了後
                break;
                
            case "story10":
                next = "Quizindex.jsp"; // じゃんけん終了後
                break;
                
            case "QuizGame":
                next = "story11.jsp"; // じゃんけん終了後
                break;
            
            case "story11":
                next = "epilogue.jsp"; // じゃんけん終了後
                break;

            default:
                next = "story.jsp"; // 初期位置
                break;
        }

        // 遷移
        RequestDispatcher rd = request.getRequestDispatcher(next);
        rd.forward(request, response);
    }
}