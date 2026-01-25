package Servlet;

import java.io.IOException;
import java.util.Random;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/JankenServlet")
public class JankenServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String[] HANDS = {"グー", "チョキ", "パー"};

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        
     // ★ 「もう一度遊びたい」などでリセットされた場合 
        String reset = request.getParameter("reset");
        if ("true".equals(reset)) {
            session.removeAttribute("player");
            session.removeAttribute("cpu");
            session.removeAttribute("reresult");
            session.removeAttribute("isisAiko");
        }


        
        String player = request.getParameter("hand");

        // ★ 初回アクセス（hand が無いとき）
        if (player == null) {
            session.removeAttribute("player");
            session.removeAttribute("cpu");
            session.removeAttribute("reresult");
            session.removeAttribute("isisAiko");
        }
 else {
            // CPU の手
            Random rand = new Random();
            String cpu = HANDS[rand.nextInt(3)];

            // 勝敗判定
            String result = judge(player, cpu);

            // あいこ判定
            boolean isAiko = result.equals("あいこでしょ！");

            // セッションに保存
            session.setAttribute("player", player);
            session.setAttribute("cpu", cpu);
            session.setAttribute("reresult", result);
            session.setAttribute("isisAiko", isAiko);
        }

        request.getRequestDispatcher("kazuyaJ_index.jsp").forward(request, response);
    }

    private String judge(String p, String c) {
        if (p.equals(c)) return "あいこでしょ！";

        if (p.equals("グー") && c.equals("チョキ")) return "あなたの勝ち！";
        if (p.equals("チョキ") && c.equals("パー")) return "あなたの勝ち！";
        if (p.equals("パー") && c.equals("グー")) return "あなたの勝ち！";

        return "CPUの勝ち…";
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	HttpSession session = request.getSession(); // ★ じゃんけん用セッション情報を削除
    	session.removeAttribute("player"); session.removeAttribute("cpu"); session.removeAttribute("result"); session.removeAttribute("isAiko");
        doGet(request, response);
    }
}
