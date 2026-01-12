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

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            session.setAttribute("errorMessage", "Please login first");
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("user_id");
        String currentUsername = (String) session.getAttribute("user");
        
        if (userId == null) {
            session.setAttribute("errorMessage", "User not logged in properly");
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        
        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Full name is required");
            response.sendRedirect("ProfileServlet");
            return;
        }
        
        if (email == null || email.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Email is required");
            response.sendRedirect("ProfileServlet");
            return;
        }
        
        fullName = fullName.trim();
        email = email.trim();
        phoneNumber = (phoneNumber != null) ? phoneNumber.trim() : "";
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // Check if email already exists for another user
            String checkEmailSql = "SELECT COUNT(*) FROM USERS WHERE EMAIL = ? AND USER_ID != ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkEmailSql);
            checkStmt.setString(1, email);
            checkStmt.setInt(2, userId);
            ResultSet checkRs = checkStmt.executeQuery();
            
            if (checkRs.next() && checkRs.getInt(1) > 0) {
                checkStmt.close();
                conn.close();
                session.setAttribute("errorMessage", "Email already exists. Please use a different email address.");
                response.sendRedirect("ProfileServlet");
                return;
            }
            checkStmt.close();
            
            // Update user profile
            String updateQuery = "UPDATE USERS SET FULL_NAME = ?, EMAIL = ?, PHONE_NUMBER = ? WHERE USER_ID = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
            updateStmt.setString(1, fullName);
            updateStmt.setString(2, email);
            updateStmt.setString(3, phoneNumber);
            updateStmt.setInt(4, userId);
            
            int rowsAffected = updateStmt.executeUpdate();
            updateStmt.close();
            
            if (rowsAffected > 0) {
                // Update session attributes with new values
                session.setAttribute("fullName", fullName);
                session.setAttribute("email", email);
                
                // Also update the user object in session if it exists
                try {
                    // If using User object in session, update it
                    Object userObj = session.getAttribute("user");
                    if (userObj != null && userObj.getClass().getName().equals("com.marketplace.model.User")) {
                        // Use reflection to update User object
                        Class<?> userClass = userObj.getClass();
                        
                        // Update fullName if setFullName method exists
                        try {
                            java.lang.reflect.Method setFullName = userClass.getMethod("setFullName", String.class);
                            setFullName.invoke(userObj, fullName);
                        } catch (NoSuchMethodException e) {
                            // Method doesn't exist, that's okay
                        }
                        
                        // Update email if setEmail method exists
                        try {
                            java.lang.reflect.Method setEmail = userClass.getMethod("setEmail", String.class);
                            setEmail.invoke(userObj, email);
                        } catch (NoSuchMethodException e) {
                            // Method doesn't exist, that's okay
                        }
                        
                        // Update phoneNumber if setPhoneNumber method exists
                        try {
                            java.lang.reflect.Method setPhoneNumber = userClass.getMethod("setPhoneNumber", String.class);
                            setPhoneNumber.invoke(userObj, phoneNumber);
                        } catch (NoSuchMethodException e) {
                            // Method doesn't exist, that's okay
                        }
                    }
                } catch (Exception e) {
                    // If reflection fails, just continue
                    System.out.println("Note: Could not update User object in session: " + e.getMessage());
                }
                
                session.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update profile. Please try again.");
            }
            
            conn.close();
            
            // Redirect back to ProfileServlet to load updated data
            response.sendRedirect("ProfileServlet");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error updating profile: " + e.getMessage());
            response.sendRedirect("ProfileServlet");
        }
    }
}