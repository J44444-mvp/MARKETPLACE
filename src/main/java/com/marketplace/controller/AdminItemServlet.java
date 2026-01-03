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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int itemId = Integer.parseInt(request.getParameter("itemId"));

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

            if ("delete".equals(action)) {
                // DELETE ITEM
                PreparedStatement ps = conn.prepareStatement("DELETE FROM ITEMS WHERE ITEM_ID = ?");
                ps.setInt(1, itemId);
                ps.executeUpdate();
                response.sendRedirect("manage_items.jsp?msg=Item deleted successfully");
                
            } else if ("update".equals(action)) {
                // UPDATE PRICE AND STATUS
                double price = Double.parseDouble(request.getParameter("price"));
                String status = request.getParameter("status");

                String sql = "UPDATE ITEMS SET PRICE = ?, STATUS = ? WHERE ITEM_ID = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setDouble(1, price);
                ps.setString(2, status);
                ps.setInt(3, itemId);
                ps.executeUpdate();
                
                response.sendRedirect("manage_items.jsp?msg=Item updated successfully");
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_items.jsp?msg=Error: " + e.getMessage());
        }
    }
}