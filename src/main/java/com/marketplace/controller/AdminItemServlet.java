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

@WebServlet("/AdminItemServlet")
public class AdminItemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String itemIdStr = request.getParameter("itemId");
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            if ("updatePrice".equals(action)) {
                double newPrice = Double.parseDouble(request.getParameter("newPrice"));
                String sql = "UPDATE ITEMS SET PRICE = ? WHERE ITEM_ID = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setDouble(1, newPrice);
                stmt.setInt(2, Integer.parseInt(itemIdStr));
                stmt.executeUpdate();
                
                // Redirect with success message
                response.sendRedirect("manage_items.jsp?msg=success");
                
            } else if ("updateStatus".equals(action)) {
                String newStatus = request.getParameter("newStatus");
                String sql = "UPDATE ITEMS SET STATUS = ? WHERE ITEM_ID = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, newStatus);
                stmt.setInt(2, Integer.parseInt(itemIdStr));
                stmt.executeUpdate();
                
                // Redirect with success message
                response.sendRedirect("manage_items.jsp?msg=success");
                
            } else if ("delete".equals(action)) {
                String sql = "DELETE FROM ITEMS WHERE ITEM_ID = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(itemIdStr));
                stmt.executeUpdate();
                
                // Redirect with deleted message
                response.sendRedirect("manage_items.jsp?msg=deleted");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Optional: Redirect with error message
            response.sendRedirect("manage_items.jsp?msg=error");
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}