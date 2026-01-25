package Servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.UserDAO;

@WebServlet("/LoginCheck")
public class LoginCheck extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ▼▼ デバッグログ（サーブレット到達確認） ▼▼
        System.out.println("=== LoginCheck START ===");

        // ▼▼ 受け取ったパラメータを全部表示 ▼▼
        System.out.println("guest param = " + request.getParameter("guest"));
        System.out.println("username param = " + request.getParameter("username"));
        System.out.println("password param = " + request.getParameter("password"));

        // ▼▼ ゲストログイン判定 ▼▼
        String guest = request.getParameter("guest");
        if ("true".equals(guest)) {

            System.out.println(">>> Guest login detected!");

            // ★ ゲストの勇者名（username）をデフォルト名にする
            request.getSession().setAttribute("username", "フィルレイン");

            System.out.println("Session username set to: フィルレイン");
            System.out.println("Redirecting to indexLoading.jsp...");
            System.out.println("=== LoginCheck END (GUEST) ===");

            response.sendRedirect("indexLoading.jsp");
            return;
        }

        // ▼▼ 通常ログイン ▼▼
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println(">>> Normal login attempt: " + username);

        UserDAO dao = new UserDAO();
        boolean result = dao.login(username, password);

        System.out.println("DAO login result = " + result);

        if (result) {
            // ログイン成功 → 勇者名はログイン名
            request.getSession().setAttribute("username", username);

            System.out.println("Login success! Session username set to: " + username);
            System.out.println("Redirecting to indexLoading.jsp...");
            System.out.println("=== LoginCheck END (SUCCESS) ===");

            response.sendRedirect("indexLoading.jsp");

        } else {
            // ログイン失敗 → login.jsp に戻す
            System.out.println("Login failed. Forwarding to login.jsp...");
            System.out.println("=== LoginCheck END (FAIL) ===");

            request.setAttribute("error", "ユーザー名またはパスワードが違います");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}