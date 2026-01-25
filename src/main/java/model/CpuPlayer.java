package model;

public class CpuPlayer {

    public int[] chooseMove(OthelloBoard board, int color) {
        int bestScore = -1;
        int br = -1;
        int bc = -1;

        for (int r = 0; r < OthelloBoard.SIZE; r++) {
            for (int c = 0; c < OthelloBoard.SIZE; c++) {
                if (board.isValidMove(r, c, color)) {
                    int score = board.countFlips(r, c, color);
                    if (score > bestScore) {
                        bestScore = score;
                        br = r;
                        bc = c;
                    }
                }
            }
        }
        if (br == -1) return null;
        return new int[]{br, bc};
    }
}
