package com.marketplace.controller;

import com.marketplace.model.User;
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
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();
        
        try {
           Class.forName("org.apache.derby.jdbc.ClientDriver");
           Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // 1. Get user's active listings (status = 'available')
            List<Item> activeItems = new ArrayList<>();
            String activeQuery = "SELECT * FROM ITEMS WHERE USER_ID = ? AND STATUS = 'available' ORDER BY DATE_SUBMITTED DESC";
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
                activeItems.add(item);
            }
            activeStmt.close();
            
            // 2. Get user's sold items (status = 'sold')
            List<Item> soldItems = new ArrayList<>();
            String soldQuery = "SELECT * FROM ITEMS WHERE USER_ID = ? AND STATUS = 'sold' ORDER BY DATE_ACTIONED DESC";
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
                soldItems.add(item);
            }
            soldStmt.close();
            
            // 3. Get user's purchased items
            List<Item> purchasedItems = new ArrayList<>();
            try {
                String purchaseQuery = "SELECT i.* FROM ITEMS i " +
                                     "INNER JOIN TRANSACTIONS t ON i.ITEM_ID = t.ITEM_ID " +
                                     "WHERE t.BUYER_ID = ? AND i.STATUS = 'sold' " +
                                     "ORDER BY t.TRANSACTION_DATE DESC";
                PreparedStatement purchaseStmt = conn.prepareStatement(purchaseQuery);
                purchaseStmt.setInt(1, userId);
                ResultSet purchaseRs = purchaseStmt.executeQuery();
                
                while (purchaseRs.next()) {
                    Item item = new Item();
                    item.setItemId(purchaseRs.getInt("ITEM_ID"));
                    item.setItemName(purchaseRs.getString("ITEM_NAME"));
                    item.setDescription(purchaseRs.getString("DESCRIPTION"));
                    item.setPrice(purchaseRs.getDouble("PRICE"));
                    item.setStatus(purchaseRs.getString("STATUS"));
                    item.setUserId(purchaseRs.getInt("USER_ID"));
                    item.setCategoryId(purchaseRs.getInt("CATEGORY_ID"));
                    item.setDateSubmitted(purchaseRs.getTimestamp("DATE_SUBMITTED"));
                    item.setDateActioned(purchaseRs.getTimestamp("DATE_ACTIONED"));
                    item.setCondition(purchaseRs.getString("CONDITION"));
                    item.setBrand(purchaseRs.getString("BRAND"));
                    item.setNegotiable(purchaseRs.getString("NEGOTIABLE"));
                    item.setMeetupLocation(purchaseRs.getString("MEETUP_LOCATION"));
                    purchasedItems.add(item);
                }
                purchaseStmt.close();
            } catch (Exception e) {
                System.out.println("Note: TRANSACTIONS table might not exist. No purchased items to show.");
            }
            
            // 4. Get sold count
            int soldCount = 0;
            String countQuery = "SELECT COUNT(*) FROM ITEMS WHERE USER_ID = ? AND STATUS = 'sold'";
            PreparedStatement countStmt = conn.prepareStatement(countQuery);
            countStmt.setInt(1, userId);
            ResultSet countRs = countStmt.executeQuery();
            if (countRs.next()) {
                soldCount = countRs.getInt(1);
            }
            countStmt.close();
            
            // Set attributes for JSP
            request.setAttribute("activeItems", activeItems);
            request.setAttribute("soldItems", soldItems);
            request.setAttribute("purchasedItems", purchasedItems);
            request.setAttribute("soldCount", soldCount);
            
            conn.close();
            
            // Forward to profile.jsp
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
}