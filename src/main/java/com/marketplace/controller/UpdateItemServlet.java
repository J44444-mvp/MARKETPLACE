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

@WebServlet("/UpdateItemServlet")
public class UpdateItemServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            String itemName = request.getParameter("title");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int categoryId = Integer.parseInt(request.getParameter("category"));
            String condition = request.getParameter("condition");
            String brand = request.getParameter("brand");
            String negotiable = request.getParameter("negotiable");
            String meetupLocation = request.getParameter("meetup");
            
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            String updateQuery = "UPDATE ITEMS SET ITEM_NAME = ?, DESCRIPTION = ?, PRICE = ?, " +
                                "CATEGORY_ID = ?, CONDITION = ?, BRAND = ?, NEGOTIABLE = ?, " +
                                "MEETUP_LOCATION = ? WHERE ITEM_ID = ?";
            
            PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
            updateStmt.setString(1, itemName);
            updateStmt.setString(2, description);
            updateStmt.setDouble(3, price);
            updateStmt.setInt(4, categoryId);
            updateStmt.setString(5, condition);
            updateStmt.setString(6, brand);
            updateStmt.setString(7, negotiable);
            updateStmt.setString(8, meetupLocation);
            updateStmt.setInt(9, itemId);
            
            int rowsAffected = updateStmt.executeUpdate();
            updateStmt.close();
            conn.close();
            
            if (rowsAffected > 0) {
                session.setAttribute("successMessage", "Item updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update item.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error updating item: " + e.getMessage());
        }
        
        response.sendRedirect("ProfileServlet");
    }
}