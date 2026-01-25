package model;

import java.io.Serializable;

public class OthelloBoard implements Serializable {

    public static final int SIZE = 8;
    public static final int EMPTY = 0;
    public static final int BLACK = 1;
    public static final int WHITE = -1;

    private final int[][] board = new int[SIZE][SIZE];
    private static final int[] DR = {-1,-1,-1,0,0,1,1,1};
    private static final int[] DC = {-1,0,1,-1,1,-1,0,1};

    public OthelloBoard() {
        reset();
    }

    public void reset() {
        for (int r = 0; r < SIZE; r++) {
            for (int c = 0; c < SIZE; c++) {
                board[r][c] = EMPTY;
            }
        }
        board[3][3] = WHITE;
        board[3][4] = BLACK;
        board[4][3] = BLACK;
        board[4][4] = WHITE;
    }

    public int get(int r, int c) {
        return board[r][c];
    }

    private boolean inBounds(int r, int c) {
        return r >= 0 && r < SIZE && c >= 0 && c < SIZE;
    }

    public boolean isValidMove(int r, int c, int color) {
        if (!inBounds(r, c) || board[r][c] != EMPTY) return false;
        int opp = -color;

        for (int d = 0; d < 8; d++) {
            int rr = r + DR[d];
            int cc = c + DC[d];
            boolean seenOpp = false;

            while (inBounds(rr, cc) && board[rr][cc] == opp) {
                seenOpp = true;
                rr += DR[d];
                cc += DC[d];
            }

            if (seenOpp && inBounds(rr, cc) && board[rr][cc] == color) {
                return true;
            }
        }
        return false;
    }

    public boolean[][] validMoves(int color) {
        boolean[][] v = new boolean[SIZE][SIZE];
        for (int r = 0; r < SIZE; r++) {
            for (int c = 0; c < SIZE; c++) {
                v[r][c] = isValidMove(r, c, color);
            }
        }
        return v;
    }

    public boolean hasAnyValidMove(int color) {
        for (int r = 0; r < SIZE; r++) {
            for (int c = 0; c < SIZE; c++) {
                if (isValidMove(r, c, color)) return true;
            }
        }
        return false;
    }

    public int countFlips(int r, int c, int color) {
        if (!isValidMove(r, c, color)) return 0;
        int opp = -color;
        int total = 0;

        for (int d = 0; d < 8; d++) {
            int rr = r + DR[d];
            int cc = c + DC[d];
            int cnt = 0;

            while (inBounds(rr, cc) && board[rr][cc] == opp) {
                cnt++;
                rr += DR[d];
                cc += DC[d];
            }

            if (cnt > 0 && inBounds(rr, cc) && board[rr][cc] == color) {
                total += cnt;
            }
        }
        return total;
    }

    public boolean applyMove(int r, int c, int color) {
        if (!isValidMove(r, c, color)) return false;
        int opp = -color;
        board[r][c] = color;

        for (int d = 0; d < 8; d++) {
            int rr = r + DR[d];
            int cc = c + DC[d];
            int cnt = 0;

            while (inBounds(rr, cc) && board[rr][cc] == opp) {
                cnt++;
                rr += DR[d];
                cc += DC[d];
            }

            if (cnt > 0 && inBounds(rr, cc) && board[rr][cc] == color) {
                int fr = r + DR[d];
                int fc = c + DC[d];
                for (int i = 0; i < cnt; i++) {
                    board[fr][fc] = color;
                    fr += DR[d];
                    fc += DC[d];
                }
            }
        }
        return true;
    }

    public int count(int color) {
        int n = 0;
        for (int r = 0; r < SIZE; r++) {
            for (int c = 0; c < SIZE; c++) {
                if (board[r][c] == color) n++;
            }
        }
        return n;
    }
}