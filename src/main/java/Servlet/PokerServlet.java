package Servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/PokerServlet")
public class PokerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String nextPage = "kazuya_index.jsp"; // デフォルトはスタート画面

        if ("rule".equals(action)) {
            nextPage = "poker_rules.jsp"; // ルール画面
        } else if ("start".equals(action)) {
            // GameServlet に stage=preflop 付きでリダイレクト
            response.sendRedirect("GameServlet?stage=preflop");
            return;
        }

        RequestDispatcher rd = request.getRequestDispatcher(nextPage);
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
