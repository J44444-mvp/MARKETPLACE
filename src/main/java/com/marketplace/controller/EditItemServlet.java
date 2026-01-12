package com.marketplace.controller;

import com.marketplace.model.Item;
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

@WebServlet("/EditItemServlet")
public class EditItemServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get item ID from request
        String itemIdStr = request.getParameter("id");
        
        if (itemIdStr == null || itemIdStr.trim().isEmpty()) {
            response.sendRedirect("profile.jsp?error=No item ID specified");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(itemIdStr);
            
            // Connect to database
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // Get item details
            String query = "SELECT * FROM ITEMS WHERE ITEM_ID = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, itemId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("ITEM_ID"));
                item.setItemName(rs.getString("ITEM_NAME"));
                item.setDescription(rs.getString("DESCRIPTION"));
                item.setPrice(rs.getDouble("PRICE"));
                item.setStatus(rs.getString("STATUS"));
                item.setUserId(rs.getInt("USER_ID"));
                item.setCategoryId(rs.getInt("CATEGORY_ID"));
                item.setCondition(rs.getString("CONDITION"));
                item.setBrand(rs.getString("BRAND"));
                item.setNegotiable(rs.getString("NEGOTIABLE"));
                item.setMeetupLocation(rs.getString("MEETUP_LOCATION"));
                
                // Try to set image URL if method exists
                try {
                    String imageUrl = rs.getString("IMAGE_URL");
                    if (imageUrl != null) {
                        item.getClass().getMethod("setImageUrl", String.class).invoke(item, imageUrl);
                    }
                } catch (Exception e) {
                    // Ignore if method doesn't exist
                }
                
                // Store item in request
                request.setAttribute("item", item);
                
                // Forward to edit-item.jsp
                request.getRequestDispatcher("edit-item.jsp").forward(request, response);
            } else {
                response.sendRedirect("profile.jsp?error=Item not found");
            }
            
            stmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=Error: " + e.getMessage());
        }
    }
}