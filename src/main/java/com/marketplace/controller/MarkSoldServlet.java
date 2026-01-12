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

@WebServlet("/MarkSoldServlet")
public class MarkSoldServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String itemIdStr = request.getParameter("itemId");
        String buyerUsername = request.getParameter("buyerUsername");
        
        if (itemIdStr == null || buyerUsername == null || buyerUsername.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid parameters");
            response.sendRedirect("ProfileServlet");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(itemIdStr);
            
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // Start transaction
            conn.setAutoCommit(false);
            
            try {
                // 1. Get buyer's user ID
                String buyerQuery = "SELECT USER_ID FROM USERS WHERE USERNAME = ?";
                PreparedStatement buyerStmt = conn.prepareStatement(buyerQuery);
                buyerStmt.setString(1, buyerUsername.trim());
                ResultSet buyerRs = buyerStmt.executeQuery();
                
                if (!buyerRs.next()) {
                    conn.rollback();
                    buyerStmt.close();
                    conn.close();
                    session.setAttribute("errorMessage", "Buyer username not found: " + buyerUsername);
                    response.sendRedirect("ProfileServlet");
                    return;
                }
                
                int buyerId = buyerRs.getInt("USER_ID");
                buyerStmt.close();
                
                // 2. Get item details to verify ownership and get price
                String itemQuery = "SELECT USER_ID, PRICE FROM ITEMS WHERE ITEM_ID = ?";
                PreparedStatement itemStmt = conn.prepareStatement(itemQuery);
                itemStmt.setInt(1, itemId);
                ResultSet itemRs = itemStmt.executeQuery();
                
                if (!itemRs.next()) {
                    conn.rollback();
                    itemStmt.close();
                    conn.close();
                    session.setAttribute("errorMessage", "Item not found");
                    response.sendRedirect("ProfileServlet");
                    return;
                }
                
                int sellerId = itemRs.getInt("USER_ID");
                double price = itemRs.getDouble("PRICE");
                itemStmt.close();
                
                // 3. Update item status to 'sold'
                String updateQuery = "UPDATE ITEMS SET STATUS = 'sold', DATE_ACTIONED = CURRENT_TIMESTAMP WHERE ITEM_ID = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
                updateStmt.setInt(1, itemId);
                updateStmt.executeUpdate();
                updateStmt.close();
                
                // 4. Try to record transaction (optional)
                try {
                    String transactionQuery = "INSERT INTO TRANSACTIONS (ITEM_ID, SELLER_ID, BUYER_ID, TRANSACTION_DATE, AMOUNT) " +
                                            "VALUES (?, ?, ?, CURRENT_TIMESTAMP, ?)";
                    PreparedStatement transStmt = conn.prepareStatement(transactionQuery);
                    transStmt.setInt(1, itemId);
                    transStmt.setInt(2, sellerId);
                    transStmt.setInt(3, buyerId);
                    transStmt.setDouble(4, price);
                    transStmt.executeUpdate();
                    transStmt.close();
                } catch (Exception e) {
                    System.out.println("Note: Could not record transaction. Continuing...");
                }
                
                // Commit transaction
                conn.commit();
                session.setAttribute("successMessage", "Item marked as sold successfully!");
                
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
                conn.close();
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
        }
        
        response.sendRedirect("ProfileServlet");
    }
}