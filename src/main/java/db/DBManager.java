package db;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBManager {

    public static Connection getConnection() throws Exception {
        Class.forName("org.h2.Driver");

        String url = "jdbc:h2:~/aGame";  // ← 今あなたが使っているURL
        System.out.println("✅ DB接続URL: " + url);

        Connection con = DriverManager.getConnection(url, "sa", "");
        System.out.println("✅ 実際に接続されたDB: " + con.getMetaData().getURL());

        return con;
    }
}