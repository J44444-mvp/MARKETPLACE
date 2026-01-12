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
        
        // Check if user is logged in - using String, not User object
        String userName = (String) session.getAttribute("user");
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userName == null || userId == null) {
            session.setAttribute("errorMessage", "Please login first");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String itemIdStr = request.getParameter("itemId");
        
        if (itemIdStr == null || itemIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid item ID");
            response.sendRedirect("profile.jsp");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(itemIdStr);
            
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // Verify item belongs to user before deleting
            String verifyQuery = "SELECT COUNT(*) FROM ITEMS WHERE ITEM_ID = ? AND USER_ID = ?";
            PreparedStatement verifyStmt = conn.prepareStatement(verifyQuery);
            verifyStmt.setInt(1, itemId);
            verifyStmt.setInt(2, userId);
            var verifyRs = verifyStmt.executeQuery();
            
            if (verifyRs.next() && verifyRs.getInt(1) == 0) {
                verifyStmt.close();
                conn.close();
                session.setAttribute("errorMessage", "Item not found or you don't have permission to delete it");
                response.sendRedirect("profile.jsp");
                return;
            }
            verifyStmt.close();
            
            // Delete the item
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
            
            // Redirect back to profile page
            response.sendRedirect("profile.jsp");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid item ID format");
            response.sendRedirect("profile.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error deleting item: " + e.getMessage());
            response.sendRedirect("profile.jsp");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle GET requests (from edit-item.jsp Delete link)
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        String userName = (String) session.getAttribute("user");
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userName == null || userId == null) {
            session.setAttribute("errorMessage", "Please login first");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String itemIdStr = request.getParameter("itemId");
        
        if (itemIdStr == null || itemIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid item ID");
            response.sendRedirect("profile.jsp");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(itemIdStr);
            
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // Verify item belongs to user before deleting
            String verifyQuery = "SELECT COUNT(*) FROM ITEMS WHERE ITEM_ID = ? AND USER_ID = ?";
            PreparedStatement verifyStmt = conn.prepareStatement(verifyQuery);
            verifyStmt.setInt(1, itemId);
            verifyStmt.setInt(2, userId);
            var verifyRs = verifyStmt.executeQuery();
            
            if (verifyRs.next() && verifyRs.getInt(1) == 0) {
                verifyStmt.close();
                conn.close();
                session.setAttribute("errorMessage", "Item not found or you don't have permission to delete it");
                response.sendRedirect("profile.jsp");
                return;
            }
            verifyStmt.close();
            
            // Delete the item
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
            
            // Redirect back to profile page
            response.sendRedirect("profile.jsp");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid item ID format");
            response.sendRedirect("profile.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error deleting item: " + e.getMessage());
            response.sendRedirect("profile.jsp");
        }
    }
}