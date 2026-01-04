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

@WebServlet(name = "AdminItemServlet", urlPatterns = {"/AdminItemServlet"})
public class AdminItemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        String dbUrl = "jdbc:derby://localhost:1527/campus_marketplace";
        String dbUser = "app";
        String dbPass = "app";

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            if ("updateItem".equals(action)) {
                // 1. GET DATA FROM JSP FORM
                String id = request.getParameter("itemId");
                String newPrice = request.getParameter("price");
                String newStatus = request.getParameter("status");

                // 2. UPDATE DATABASE
                String sql = "UPDATE ITEMS SET PRICE = ?, STATUS = ? WHERE ITEM_ID = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setDouble(1, Double.parseDouble(newPrice));
                pstmt.setString(2, newStatus);
                pstmt.setInt(3, Integer.parseInt(id));
                
                pstmt.executeUpdate();
                pstmt.close();

            } else if ("delete".equals(action)) {
                // DELETE LOGIC
                String id = request.getParameter("itemId");
                String sql = "DELETE FROM ITEMS WHERE ITEM_ID = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(id));
                
                pstmt.executeUpdate();
                pstmt.close();
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 3. REFRESH THE PAGE
        response.sendRedirect("manage_items.jsp");
    }
}