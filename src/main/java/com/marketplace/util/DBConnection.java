package com.marketplace.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Java DB (Derby) Credentials
    private static final String URL = "jdbc:derby://localhost:1527/campus_marketplace";
    private static final String USER = "app";
    private static final String PASSWORD = "app";
    private static final String DRIVER = "org.apache.derby.jdbc.ClientDriver";

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName(DRIVER);
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("DB Connection Error: " + e.getMessage());
        }
        return con;
    }
}