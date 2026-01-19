package com.smartpark.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class GetConnection {

    private static Connection con;
    private static final String URL = "jdbc:mysql://localhost:3306/parking_lot_db";
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    public static Connection getConnection() {
        try {
            if (con == null || con.isClosed()) {
              
                Class.forName("com.mysql.cj.jdbc.Driver");

                con = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("Connected to parking_lot_db successfully!");
            }
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
        }
        return con;
    }

    public static void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                System.out.println("Connection closed successfully.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    
    public static void main(String[] args) {
        Connection testCon = GetConnection.getConnection();
        if (testCon != null) {
            System.out.println("DB Connection test passed!");
            closeConnection();
        } else {
            System.out.println("DB Connection test failed!");
        }
    }
}

