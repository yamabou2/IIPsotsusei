package model;

public class QuizQuestion {

    private String question;
    private String[] choices;
    private int correct;

    public QuizQuestion(String question, String[] choices, int correct) {
        this.question = question;
        this.choices = choices;
        this.correct = correct;
    }

    public String getQuestion() {
        return question;
    }

    public String[] getChoices() {
        return choices;
    }

    public boolean isCorrect(int answer) {
        return answer == correct;
    }
}