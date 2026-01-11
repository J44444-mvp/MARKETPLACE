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

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // Check if user exists with matching username and password
            String sql = "SELECT * FROM USERS WHERE USERNAME = ? AND PASSWORD = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                // --- LOGIN SUCCESSFUL ---
                
                // Get the exact username from DB (to be safe)
                String dbUsername = rs.getString("USERNAME");
                int userId = rs.getInt("USER_ID");
                
                // Create Session
                HttpSession session = request.getSession();
                session.setAttribute("user", dbUsername);
                session.setAttribute("userId", userId);
                
                // --- SEPARATION LOGIC ---
                // If username starts with "admin" -> Go to Admin Dashboard
                // Else -> Go to User Homepage
                
                if (dbUsername.toLowerCase().startsWith("admin")) {
                    session.setAttribute("role", "admin"); // Mark session as admin
                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    session.setAttribute("role", "user"); // Mark session as user
                    response.sendRedirect("index.jsp"); // Or 'market.jsp' depending on your homepage
                }
                
            } else {
                // --- LOGIN FAILED ---
                response.sendRedirect("login.jsp?error=invalid");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server");
        } finally {
            try { if(rs!=null) rs.close(); if(stmt!=null) stmt.close(); if(conn!=null) conn.close(); } catch(Exception e){}
        }
    }
}