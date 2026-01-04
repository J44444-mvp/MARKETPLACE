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
import jakarta.servlet.http.HttpSession;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String query = request.getParameter("query");
        String category = request.getParameter("category");
        
        HttpSession session = request.getSession();
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // Build SQL query based on search parameters
            StringBuilder sql = new StringBuilder(
                "SELECT i.item_id, i.item_name, i.description, i.price, i.status, " +
                "i.image_url, u.full_name, u.username " +
                "FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id " +
                "WHERE i.status = 'APPROVED' "
            );
            
            if (query != null && !query.trim().isEmpty()) {
                sql.append("AND (LOWER(i.item_name) LIKE ? OR LOWER(i.description) LIKE ?) ");
            }
            
            if (category != null && !category.isEmpty()) {
                sql.append("AND LOWER(i.item_name) LIKE ? ");
            }
            
            sql.append("ORDER BY i.date_submitted DESC");
            
            PreparedStatement stmt = conn.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (query != null && !query.trim().isEmpty()) {
                String searchTerm = "%" + query.toLowerCase() + "%";
                stmt.setString(paramIndex++, searchTerm);
                stmt.setString(paramIndex++, searchTerm);
            }
            
            if (category != null && !category.isEmpty()) {
                String categoryTerm = "%" + category.toLowerCase() + "%";
                stmt.setString(paramIndex, categoryTerm);
            }
            
            ResultSet rs = stmt.executeQuery();
            
            // Store results in session to display on browse-item.jsp
            // We'll store them in session for simplicity
            // In real application, you might want to use request attributes
            // But we need to pass them to browse-item.jsp
            
            request.setAttribute("searchResults", rs);
            request.setAttribute("searchQuery", query);
            request.setAttribute("searchCategory", category);
            
            conn.close();
            
            // Forward to browse-item.jsp
            request.getRequestDispatcher("browse-item.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("browse-item.jsp?error=search_failed");
        }
    }
}