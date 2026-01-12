package com.marketplace.controller;

import com.marketplace.model.User;
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

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        int userId = currentUser.getUserId();
        
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            String updateQuery = "UPDATE USERS SET FULL_NAME = ?, EMAIL = ?, PHONE_NUMBER = ? WHERE USER_ID = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
            updateStmt.setString(1, fullName);
            updateStmt.setString(2, email);
            updateStmt.setString(3, phoneNumber);
            updateStmt.setInt(4, userId);
            
            int rowsAffected = updateStmt.executeUpdate();
            updateStmt.close();
            
            if (rowsAffected > 0) {
                // Get updated user data
                String selectQuery = "SELECT * FROM USERS WHERE USER_ID = ?";
                PreparedStatement selectStmt = conn.prepareStatement(selectQuery);
                selectStmt.setInt(1, userId);
                ResultSet rs = selectStmt.executeQuery();
                
                if (rs.next()) {
                    User updatedUser = new User();
                    updatedUser.setUserId(rs.getInt("USER_ID"));
                    updatedUser.setUsername(rs.getString("USERNAME"));
                    updatedUser.setPassword(rs.getString("PASSWORD"));
                    updatedUser.setFullName(rs.getString("FULL_NAME"));
                    updatedUser.setEmail(rs.getString("EMAIL"));
                    updatedUser.setPhoneNumber(rs.getString("PHONE_NUMBER"));
                    updatedUser.setRole(rs.getString("ROLE"));
                    
                    session.setAttribute("user", updatedUser);
                    session.setAttribute("successMessage", "Profile updated successfully!");
                }
                selectStmt.close();
            } else {
                session.setAttribute("errorMessage", "Failed to update profile. Please try again.");
            }
            
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }
        
        response.sendRedirect("ProfileServlet");
    }
}