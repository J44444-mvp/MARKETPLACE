package com.marketplace.controller;

import com.marketplace.model.Item;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in - using String, not User object
        String userName = (String) session.getAttribute("user");
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userName == null || userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
           Class.forName("org.apache.derby.jdbc.ClientDriver");
           Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // 1. Get user's active listings (status = 'AVAILABLE' or 'APPROVED') - FIXED
            List<Item> activeItems = new ArrayList<>();
            String activeQuery = "SELECT * FROM ITEMS WHERE USER_ID = ? AND (STATUS = 'AVAILABLE' OR STATUS = 'APPROVED') ORDER BY DATE_SUBMITTED DESC"; // Changed 'available' to 'AVAILABLE'
            PreparedStatement activeStmt = conn.prepareStatement(activeQuery);
            activeStmt.setInt(1, userId);
            ResultSet activeRs = activeStmt.executeQuery();
            
            while (activeRs.next()) {
                Item item = new Item();
                item.setItemId(activeRs.getInt("ITEM_ID"));
                item.setItemName(activeRs.getString("ITEM_NAME"));
                item.setDescription(activeRs.getString("DESCRIPTION"));
                item.setPrice(activeRs.getDouble("PRICE"));
                item.setStatus(activeRs.getString("STATUS"));
                item.setUserId(activeRs.getInt("USER_ID"));
                item.setCategoryId(activeRs.getInt("CATEGORY_ID"));
                item.setDateSubmitted(activeRs.getTimestamp("DATE_SUBMITTED"));
                item.setDateActioned(activeRs.getTimestamp("DATE_ACTIONED"));
                item.setCondition(activeRs.getString("CONDITION"));
                item.setBrand(activeRs.getString("BRAND"));
                item.setNegotiable(activeRs.getString("NEGOTIABLE"));
                item.setMeetupLocation(activeRs.getString("MEETUP_LOCATION"));
                
                // Try to get image URL if Item class has the method
                try {
                    String imageUrl = activeRs.getString("IMAGE_URL");
                    if (imageUrl != null) {
                        item.getClass().getMethod("setImageUrl", String.class).invoke(item, imageUrl);
                    }
                } catch (Exception e) {
                    // Method doesn't exist or imageUrl is null, continue
                }
                
                activeItems.add(item);
            }
            activeStmt.close();
            
            // 2. Get user's sold items (status = 'SOLD') - FIXED
            List<Item> soldItems = new ArrayList<>();
            String soldQuery = "SELECT * FROM ITEMS WHERE USER_ID = ? AND STATUS = 'SOLD' ORDER BY DATE_ACTIONED DESC"; // Changed to only 'SOLD'
            PreparedStatement soldStmt = conn.prepareStatement(soldQuery);
            soldStmt.setInt(1, userId);
            ResultSet soldRs = soldStmt.executeQuery();
            
            while (soldRs.next()) {
                Item item = new Item();
                item.setItemId(soldRs.getInt("ITEM_ID"));
                item.setItemName(soldRs.getString("ITEM_NAME"));
                item.setDescription(soldRs.getString("DESCRIPTION"));
                item.setPrice(soldRs.getDouble("PRICE"));
                item.setStatus(soldRs.getString("STATUS"));
                item.setUserId(soldRs.getInt("USER_ID"));
                item.setCategoryId(soldRs.getInt("CATEGORY_ID"));
                item.setDateSubmitted(soldRs.getTimestamp("DATE_SUBMITTED"));
                item.setDateActioned(soldRs.getTimestamp("DATE_ACTIONED"));
                item.setCondition(soldRs.getString("CONDITION"));
                item.setBrand(soldRs.getString("BRAND"));
                item.setNegotiable(soldRs.getString("NEGOTIABLE"));
                item.setMeetupLocation(soldRs.getString("MEETUP_LOCATION"));
                
                // Try to get image URL if Item class has the method
                try {
                    String imageUrl = soldRs.getString("IMAGE_URL");
                    if (imageUrl != null) {
                        item.getClass().getMethod("setImageUrl", String.class).invoke(item, imageUrl);
                    }
                } catch (Exception e) {
                    // Method doesn't exist or imageUrl is null, continue
                }
                
                soldItems.add(item);
            }
            soldStmt.close();
            
            // 3. Get sold count - FIXED
            int soldCount = 0;
            String countQuery = "SELECT COUNT(*) FROM ITEMS WHERE USER_ID = ? AND STATUS = 'SOLD'"; // Changed to only 'SOLD'
            PreparedStatement countStmt = conn.prepareStatement(countQuery);
            countStmt.setInt(1, userId);
            ResultSet countRs = countStmt.executeQuery();
            if (countRs.next()) {
                soldCount = countRs.getInt(1);
            }
            countStmt.close();
            
            // 4. Get user details
            String fullName = "";
            String email = "";
            String phoneNumber = "";
            String userQuery = "SELECT full_name, email, phone_number FROM USERS WHERE user_id = ?";
            PreparedStatement userStmt = conn.prepareStatement(userQuery);
            userStmt.setInt(1, userId);
            ResultSet userRs = userStmt.executeQuery();
            
            if (userRs.next()) {
                fullName = userRs.getString("full_name");
                email = userRs.getString("email");
                phoneNumber = userRs.getString("phone_number");
            }
            userStmt.close();
            
            conn.close();
            
            // Set attributes for JSP
            request.setAttribute("activeItems", activeItems);
            request.setAttribute("soldItems", soldItems);
            request.setAttribute("soldCount", soldCount);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.setAttribute("userName", userName);
            
            // Forward to profile.jsp
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("profile.jsp");
        }
    }
}