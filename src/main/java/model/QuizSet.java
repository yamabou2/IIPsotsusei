package model;

import java.util.ArrayList;
import java.util.List;

public class QuizSet {

    private List<QuizQuestion> questions;

    public QuizSet() {
        questions = new ArrayList<>();
    }

    public void addQuestion(QuizQuestion q) {
        questions.add(q);
    }

    public QuizQuestion getQuestion(int index) {
        return questions.get(index);
    }

    public int size() {
        return questions.size();
    }

    /* サンプル問題30問（知識問題のみ） */
    public static QuizSet createSample() {
        QuizSet set = new QuizSet();

        set.addQuestion(new QuizQuestion(
                "extends は何に使う？",
                new String[]{"実装", "継承", "例外", "型変換"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "interface は多重継承できる？",
                new String[]{"できる", "できない", "条件付き", "一部できる"},
                0
        ));

        set.addQuestion(new QuizQuestion(
                "static メソッドはオーバーライドできる？",
                new String[]{"できる", "できない", "条件付き", "一部できる"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "final クラスの特徴は？",
                new String[]{"継承できる", "インスタンス化できない", "継承できない", "抽象クラスになる"},
                2
        ));

        set.addQuestion(new QuizQuestion(
                "abstract メソッドを持てるのは？",
                new String[]{"通常クラス", "final クラス", "abstract クラス", "static クラス"},
                2
        ));

        set.addQuestion(new QuizQuestion(
                "implements は何に使う？",
                new String[]{"継承", "実装", "例外処理", "型変換"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "コンストラクタの特徴は？",
                new String[]{"戻り値を持つ", "クラス名と同じ名前", "static 必須", "override 必須"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "this は何を指す？",
                new String[]{"親クラス", "現在のオブジェクト", "子クラス", "パッケージ"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "super は何を指す？",
                new String[]{"自分自身", "子クラス", "親クラス", "インターフェース"},
                2
        ));

        set.addQuestion(new QuizQuestion(
                "オーバーロードの条件は？",
                new String[]{"戻り値が違う", "引数の型や数が違う", "アクセス修飾子が違う", "static が違う"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "オーバーライドの条件は？",
                new String[]{"メソッド名が同じ", "引数が同じ", "戻り値が同じ", "すべて正しい"},
                3
        ));

        set.addQuestion(new QuizQuestion(
                "private メンバに直接アクセスできるのは？",
                new String[]{"同じクラス", "同じパッケージ", "サブクラス", "どこからでも"},
                0
        ));

        set.addQuestion(new QuizQuestion(
                "protected メンバにアクセスできるのは？",
                new String[]{"同一クラスのみ", "同一パッケージとサブクラス", "どこからでも", "サブクラスのみ"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "Javaで多重継承ができない理由は？",
                new String[]{"速度が遅くなる", "ダイヤモンド問題", "文法が複雑", "不要だから"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "interface に定義できないものは？",
                new String[]{"抽象メソッド", "定数", "インスタンスフィールド", "default メソッド"},
                2
        ));

        set.addQuestion(new QuizQuestion(
                "default メソッドはどこで使う？",
                new String[]{"クラス", "abstract クラス", "interface", "enum"},
                2
        ));

        set.addQuestion(new QuizQuestion(
                "static フィールドの特徴は？",
                new String[]{"オブジェクトごとに持つ", "クラスで共有される", "final 必須", "private 必須"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "final 変数の特徴は？",
                new String[]{"値を変更できる", "一度だけ代入可能", "必ずstatic", "必ずpublic"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "enum の主な用途は？",
                new String[]{"数値計算", "定数の集合", "文字列操作", "例外処理"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "例外の基底クラスは？",
                new String[]{"Error", "Throwable", "Exception", "Runtime"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "checked 例外の特徴は？",
                new String[]{"try-catch 不要", "コンパイル時にチェックされる", "RuntimeException のみ", "無視できる"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "try-with-resources の目的は？",
                new String[]{"速度向上", "自動クローズ", "例外無視", "並列処理"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "List の実装クラスは？",
                new String[]{"HashMap", "HashSet", "ArrayList", "TreeSet"},
                2
        ));

        set.addQuestion(new QuizQuestion(
                "Map の特徴は？",
                new String[]{"重複不可", "順序保持", "キーと値のペア", "インデックス管理"},
                2
        ));

        set.addQuestion(new QuizQuestion(
                "ジェネリクスの目的は？",
                new String[]{"速度向上", "型安全", "メモリ削減", "並列処理"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "String はイミュータブル？",
                new String[]{"はい", "いいえ", "条件付き", "環境依存"},
                0
        ));

        set.addQuestion(new QuizQuestion(
                "== と equals の違いは？",
                new String[]{"同じ", "参照と内容", "速度", "型変換"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "パッケージの役割は？",
                new String[]{"高速化", "名前空間管理", "例外処理", "メモリ管理"},
                1
        ));

        set.addQuestion(new QuizQuestion(
                "アクセス修飾子で最も制限が厳しいのは？",
                new String[]{"public", "protected", "default", "private"},
                3
        ));

        set.addQuestion(new QuizQuestion(
                "JVM の役割は？",
                new String[]{"コンパイル", "実行環境", "エディタ", "デバッガ"},
                1
        ));

        return set;
    }
}