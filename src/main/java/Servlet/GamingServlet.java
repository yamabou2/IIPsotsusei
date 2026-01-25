package Servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Egame;
import model.EgameLogic;
import model.Te;

@WebServlet("/GamingServlet")
public class GamingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // ▼ ゲーム状態の取得
        ServletContext application = this.getServletContext();
        Egame egame = (Egame) application.getAttribute("Egame");
        if (egame == null) {
            egame = new Egame();
        }

        Te pcTe = (Te) session.getAttribute("pcTe");
        if (pcTe == null) {
            pcTe = new Te();
            session.setAttribute("pcTe", pcTe);
        }

        String action = request.getParameter("action");
        EgameLogic egameLogic = new EgameLogic();

        // ▼ ゲーム開始（皇帝）
        if ("startEmperor".equals(action)) {
            egame = new Egame();
            application.setAttribute("Egame", egame);

            pcTe = new Te();
            session.setAttribute("pcTe", pcTe);

            RequestDispatcher dispatcher = request.getRequestDispatcher("emperor.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // ▼ ゲーム開始（奴隷）
        if ("startDorei".equals(action)) {
            egame = new Egame();
            application.setAttribute("Egame", egame);

            pcTe = new Te();
            session.setAttribute("pcTe", pcTe);

            RequestDispatcher dispatcher = request.getRequestDispatcher("dorei.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // ▼ カード処理（皇帝側）
        if ("emperor".equals(action)) {
            egameLogic.killer(egame);
            pcTe.logic();
            request.setAttribute("playTe", "killer");
            session.setAttribute("pcTe", pcTe);

            RequestDispatcher dispatcher = request.getRequestDispatcher("emperor.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // ▼ カード処理（奴隷側）
        if ("dorei".equals(action)) {
            egameLogic.killer(egame);
            pcTe.logic();
            request.setAttribute("playTe", "killer");
            session.setAttribute("pcTe", pcTe);

            RequestDispatcher dispatcher = request.getRequestDispatcher("dorei.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // ▼ 市民（皇帝側）
        if ("siminE".equals(action)) {
            egameLogic.simin(egame);
            pcTe.logic();
            request.setAttribute("playTe", "simin");
            session.setAttribute("pcTe", pcTe);

            RequestDispatcher dispatcher = request.getRequestDispatcher("emperor.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // ▼ 市民（奴隷側）
        if ("siminD".equals(action)) {
            egameLogic.simin(egame);
            pcTe.logic();
            request.setAttribute("playTe", "simin");
            session.setAttribute("pcTe", pcTe);

            RequestDispatcher dispatcher = request.getRequestDispatcher("dorei.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // ▼ ゲーム状態を保存
        application.setAttribute("Egame", egame);

        // ▼ ゲーム終了処理
        if (egame.getCard() == 0) {
            System.out.println("終了");

            session.removeAttribute("pcTe");
            application.removeAttribute("Egame");
            request.removeAttribute("playTe");

            // ★ ストーリーに戻す
            request.setAttribute("current", "yamazaki");
            request.getRequestDispatcher("StoryServlet").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}