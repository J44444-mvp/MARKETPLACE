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

@WebServlet("/DeleteItemServlet")
public class DeleteItemServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String itemIdStr = request.getParameter("itemId");
        
        if (itemIdStr == null) {
            session.setAttribute("errorMessage", "Invalid item ID");
            response.sendRedirect("ProfileServlet");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(itemIdStr);
            
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            String deleteQuery = "DELETE FROM ITEMS WHERE ITEM_ID = ?";
            PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery);
            deleteStmt.setInt(1, itemId);
            
            int rowsAffected = deleteStmt.executeUpdate();
            deleteStmt.close();
            conn.close();
            
            if (rowsAffected > 0) {
                session.setAttribute("successMessage", "Item deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Item not found or could not be deleted");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error deleting item: " + e.getMessage());
        }
        
        response.sendRedirect("ProfileServlet");
    }
}