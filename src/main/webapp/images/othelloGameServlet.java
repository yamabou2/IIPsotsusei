package Servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.CpuPlayer;
import model.OthelloBoard;

@WebServlet("/game")
public class othelloGameServlet extends HttpServlet {

    private final CpuPlayer cpu = new CpuPlayer();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // 新規開始 or 続ける
        if ("start".equals(request.getParameter("mode"))) {
            session.invalidate();
            session = request.getSession(true);
        }

        OthelloBoard board = (OthelloBoard) session.getAttribute("board");
        if (board == null) {
            board = new OthelloBoard();
            session.setAttribute("board", board);
            session.setAttribute("state", "play");
            session.setAttribute("msg", "黒の手番です");
            session.setAttribute("shown", false);
        }

        // 初回アニメーション判定
        boolean first = false;
        if (Boolean.FALSE.equals(session.getAttribute("shown"))) {
            first = true;
            session.setAttribute("shown", true);
        }

        request.setAttribute("first", first);
        request.setAttribute("state", session.getAttribute("state"));
        request.setAttribute("board", board);

        boolean[][] valid =
                "play".equals(session.getAttribute("state"))
                        ? board.validMoves(OthelloBoard.BLACK)
                        : new boolean[OthelloBoard.SIZE][OthelloBoard.SIZE];

        request.setAttribute("valid", valid);
        request.setAttribute("black", board.count(OthelloBoard.BLACK));
        request.setAttribute("white", board.count(OthelloBoard.WHITE));
        request.setAttribute("msg", session.getAttribute("msg"));

        request.getRequestDispatcher("/game.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        // リスタート
        if ("restart".equals(action)) {
            response.sendRedirect("game?mode=start");
            return;
        }

        // 続ける（WIN / LOSE 共通）
        if ("continue".equals(action)) {
            response.sendRedirect("game?mode=start");
            return;
        }

        OthelloBoard board = (OthelloBoard) session.getAttribute("board");

        int r = Integer.parseInt(request.getParameter("r"));
        int c = Integer.parseInt(request.getParameter("c"));

        if (!board.applyMove(r, c, OthelloBoard.BLACK)) {
            session.setAttribute("msg", "そこには置けません");
            response.sendRedirect("game");
            return;
        }

        if (board.hasAnyValidMove(OthelloBoard.WHITE)) {
            int[] mv = cpu.chooseMove(board, OthelloBoard.WHITE);
            if (mv != null) {
                board.applyMove(mv[0], mv[1], OthelloBoard.WHITE);
            }
        }

        if (!board.hasAnyValidMove(OthelloBoard.BLACK)
                && !board.hasAnyValidMove(OthelloBoard.WHITE)) {

            int b = board.count(OthelloBoard.BLACK);
            int w = board.count(OthelloBoard.WHITE);

            if (b > w) {
                session.setAttribute("state", "win");
                session.setAttribute("msg", "WIN");
            } else {
                session.setAttribute("state", "lose");
                session.setAttribute("msg", "LOSE");
            }
        } else {
            session.setAttribute("msg", "黒の手番です");
        }

        response.sendRedirect("game");
    }
}