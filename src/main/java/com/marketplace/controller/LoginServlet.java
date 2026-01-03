package com.marketplace.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    // Database Credentials
    private static final String DB_URL = "jdbc:derby://localhost:1527/campus_marketplace";
    private static final String DB_USER = "app";
    private static final String DB_PASS = "app";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get Form Data
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // 2. Connect to Database
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // 3. Check Credentials
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);
            
            rs = stmt.executeQuery();

            if (rs.next()) {
                // --- LOGIN SUCCESS ---
                
                // Get User Details from Database
                String fullName = rs.getString("full_name");
                String role = rs.getString("role");
                int userId = rs.getInt("user_id");

                // Start Session
                HttpSession session = request.getSession();
                session.setAttribute("user", fullName);
                session.setAttribute("role", role);
                session.setAttribute("user_id", userId); // Useful for saving products later

                // --- REDIRECT LOGIC ---
                if ("ADMIN".equalsIgnoreCase(role)) {
                    // If Admin -> Go to Admin Dashboard
                    System.out.println("Login: Admin Detected. Redirecting to Dashboard.");
                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    // If Student -> Go to Main Page
                    System.out.println("Login: Student Detected. Redirecting to Index.");
                    response.sendRedirect("index.jsp");
                }

            } else {
                // --- LOGIN FAILED ---
                request.setAttribute("errorMessage", "Invalid Email or Password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database Error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            // 4. Close Connections safely
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}