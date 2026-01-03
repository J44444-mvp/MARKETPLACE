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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get Data from JSP (Using "username" to match your form)
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

            // 2. Check Database for USERNAME and PASSWORD
            String sql = "SELECT * FROM USERS WHERE USERNAME = ? AND PASSWORD = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // --- SUCCESS: LOGIN CORRECT ---
                HttpSession session = request.getSession();
                session.setAttribute("user", rs.getString("FULL_NAME"));
                session.setAttribute("role", rs.getString("ROLE"));
                session.setAttribute("user_id", rs.getInt("USER_ID"));

                // Redirect based on Role
                String role = rs.getString("ROLE");
                
                if ("ADMIN".equalsIgnoreCase(role)) {
                    // Go to Admin Dashboard
                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    // Go to Student Home Page
                    response.sendRedirect("index.jsp");
                }

            } else {
                // --- FAILURE: WRONG PASSWORD ---
                // Send error message back to login.jsp
                request.setAttribute("errorMessage", "Login Unsuccessful! Incorrect Username or Password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}