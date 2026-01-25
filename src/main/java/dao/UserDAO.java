package dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import db.DBManager;

public class UserDAO {

    public boolean login(String username, String password) {
        boolean isValid = false;

        try (Connection con = DBManager.getConnection()) {

            System.out.println("✅ DB接続成功: " + con);

            // ✅ H2 のカラム名は大文字で、ダブルクォート必須
            String sql = "SELECT * FROM users WHERE USERNAME = ? AND PASSWORD = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            System.out.println("✅ 入力値: " + username + " / " + password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                System.out.println("✅ ログイン成功: ユーザーが見つかりました");
                isValid = true;
            } else {
                System.out.println("❌ ログイン失敗: 該当ユーザーなし");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return isValid;
    }
}