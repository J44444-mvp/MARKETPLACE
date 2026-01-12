package com.marketplace.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateItemUserServlet")
public class UpdateItemUserServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        String userName = (String) session.getAttribute("user");
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userName == null || userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get form parameters
        String itemIdStr = request.getParameter("itemId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String categoryIdStr = request.getParameter("category");
        String condition = request.getParameter("condition");
        String brand = request.getParameter("brand");
        String negotiable = request.getParameter("negotiable");
        String meetupLocation = request.getParameter("meetup");
        
        // Validate required fields
        if (itemIdStr == null || title == null || description == null || priceStr == null || 
            categoryIdStr == null || condition == null || meetupLocation == null) {
            session.setAttribute("errorMessage", "All required fields must be filled");
            response.sendRedirect("edit-item.jsp?id=" + itemIdStr);
            return;
        }
        
        try {
            int itemId = Integer.parseInt(itemIdStr);
            double price = Double.parseDouble(priceStr);
            int categoryId = Integer.parseInt(categoryIdStr);
            
            // Validate price
            if (price <= 0) {
                session.setAttribute("errorMessage", "Price must be greater than 0");
                response.sendRedirect("edit-item.jsp?id=" + itemId);
                return;
            }
            
            // Connect to database
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // First, verify the item belongs to the user
            String verifyQuery = "SELECT ITEM_ID FROM ITEMS WHERE ITEM_ID = ? AND USER_ID = ?";
            PreparedStatement verifyStmt = conn.prepareStatement(verifyQuery);
            verifyStmt.setInt(1, itemId);
            verifyStmt.setInt(2, userId);
            
            if (!verifyStmt.executeQuery().next()) {
                session.setAttribute("errorMessage", "You don't have permission to update this item");
                response.sendRedirect("profile.jsp");
                verifyStmt.close();
                conn.close();
                return;
            }
            verifyStmt.close();
            
            // Update the item
            String updateQuery = "UPDATE ITEMS SET " +
                                "ITEM_NAME = ?, " +
                                "DESCRIPTION = ?, " +
                                "PRICE = ?, " +
                                "CATEGORY_ID = ?, " +
                                "CONDITION = ?, " +
                                "BRAND = ?, " +
                                "NEGOTIABLE = ?, " +
                                "MEETUP_LOCATION = ?, " +
                                "DATE_SUBMITTED = CURRENT_TIMESTAMP " +
                                "WHERE ITEM_ID = ? AND USER_ID = ?";
            
            PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
            updateStmt.setString(1, title);
            updateStmt.setString(2, description);
            updateStmt.setDouble(3, price);
            updateStmt.setInt(4, categoryId);
            updateStmt.setString(5, condition);
            updateStmt.setString(6, brand != null && !brand.trim().isEmpty() ? brand : null);
            updateStmt.setString(7, negotiable != null ? negotiable : "no");
            updateStmt.setString(8, meetupLocation);
            updateStmt.setInt(9, itemId);
            updateStmt.setInt(10, userId);
            
            int rowsUpdated = updateStmt.executeUpdate();
            
            updateStmt.close();
            conn.close();
            
            if (rowsUpdated > 0) {
                session.setAttribute("successMessage", "Item updated successfully!");
                response.sendRedirect("profile.jsp");
            } else {
                session.setAttribute("errorMessage", "Failed to update item. Please try again.");
                response.sendRedirect("edit-item.jsp?id=" + itemId);
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Invalid number format for price or category");
            response.sendRedirect("edit-item.jsp?id=" + itemIdStr);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("edit-item.jsp?id=" + itemIdStr);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests only
        response.sendRedirect("profile.jsp");
    }
}