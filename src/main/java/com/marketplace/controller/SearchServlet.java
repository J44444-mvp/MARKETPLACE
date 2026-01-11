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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String query = request.getParameter("query");
        String category = request.getParameter("category");
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // Build SQL query based on search parameters
            StringBuilder sql = new StringBuilder(
                "SELECT i.item_id, i.item_name, i.description, i.price, i.status, " +
                "i.image_url, u.full_name, u.username, i.date_submitted " +
                "FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id " +
                "WHERE (i.status = 'APPROVED' OR i.status = 'AVAILABLE') "
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
            
            // Create a list to store results
            List<Item> searchResults = new ArrayList<>();
            
            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("item_id"));
                item.setName(rs.getString("item_name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getDouble("price"));
                item.setStatus(rs.getString("status"));
                item.setImageUrl(rs.getString("image_url"));
                item.setSellerName(rs.getString("full_name"));
                item.setSellerUsername(rs.getString("username"));
                item.setDateSubmitted(rs.getTimestamp("date_submitted"));
                searchResults.add(item);
            }
            
            // Store in request
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("searchQuery", query);
            request.setAttribute("searchCategory", category);
            
            rs.close();
            stmt.close();
            conn.close();
            
            // Forward to browse-item.jsp
            request.getRequestDispatcher("browse-item.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Redirect with error parameter
            response.sendRedirect("browse-item.jsp?error=search_failed&query=" + 
                (query != null ? query : ""));
        }
    }
    
    // Simple inner class to hold item data
    private static class Item {
        private int id;
        private String name;
        private String description;
        private double price;
        private String status;
        private String imageUrl;
        private String sellerName;
        private String sellerUsername;
        private java.sql.Timestamp dateSubmitted;
        
        // Getters and setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public double getPrice() { return price; }
        public void setPrice(double price) { this.price = price; }
        
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        
        public String getImageUrl() { return imageUrl; }
        public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
        
        public String getSellerName() { return sellerName; }
        public void setSellerName(String sellerName) { this.sellerName = sellerName; }
        
        public String getSellerUsername() { return sellerUsername; }
        public void setSellerUsername(String sellerUsername) { this.sellerUsername = sellerUsername; }
        
        public java.sql.Timestamp getDateSubmitted() { return dateSubmitted; }
        public void setDateSubmitted(java.sql.Timestamp dateSubmitted) { this.dateSubmitted = dateSubmitted; }
    }
}