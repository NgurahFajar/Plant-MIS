package com; // or your full package name if deeper

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/plant_mis", "root", "BaliDewata"
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}
