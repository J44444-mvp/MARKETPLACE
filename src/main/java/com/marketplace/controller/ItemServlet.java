/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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

@WebServlet("/ItemServlet")
public class ItemServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String itemId = request.getParameter("id");
        
        if ("detail".equals(action) && itemId != null) {
            try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                
                // Get item details
                String sql = "SELECT i.*, u.full_name, u.email, u.phone " +
                           "FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id " +
                           "WHERE i.item_id = ? AND i.status = 'APPROVED'";
                
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(itemId));
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    // Store item details in request
                    request.setAttribute("item", rs);
                    request.getRequestDispatcher("item-detail.jsp").forward(request, response);
                } else {
                    // Item not found or not approved
                    response.sendRedirect("browse-item.jsp?error=item_not_found");
                }
                
                conn.close();
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("browse-item.jsp?error=load_failed");
            }
        } else {
            response.sendRedirect("browse-item.jsp");
        }
    }
}