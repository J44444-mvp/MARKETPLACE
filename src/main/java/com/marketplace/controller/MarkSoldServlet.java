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
            session.setAttribute("errorMessage", "Please login first");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String itemIdStr = request.getParameter("itemId");
        String buyerUsername = request.getParameter("buyerUsername");
        
        if (itemIdStr == null || buyerUsername == null || buyerUsername.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Please enter buyer's username");
            response.sendRedirect("ProfileServlet");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(itemIdStr);
            buyerUsername = buyerUsername.trim();
            
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // Start transaction
            conn.setAutoCommit(false);
            
            try {
                // 1. Get seller ID from session
                Integer sellerId = (Integer) session.getAttribute("user_id");
                String sellerUsername = (String) session.getAttribute("user");
                
                if (sellerId == null) {
                    conn.rollback();
                    conn.close();
                    session.setAttribute("errorMessage", "User not logged in properly");
                    response.sendRedirect("ProfileServlet");
                    return;
                }
                
                // 2. Get buyer's user ID
                String buyerQuery = "SELECT USER_ID, FULL_NAME FROM USERS WHERE USERNAME = ?";
                PreparedStatement buyerStmt = conn.prepareStatement(buyerQuery);
                buyerStmt.setString(1, buyerUsername);
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
                String buyerName = buyerRs.getString("FULL_NAME");
                buyerStmt.close();
                
                // 3. Check if buyer and seller are the same person
                if (sellerId == buyerId) {
                    conn.rollback();
                    conn.close();
                    session.setAttribute("errorMessage", "You cannot mark an item as sold to yourself!");
                    response.sendRedirect("ProfileServlet");
                    return;
                }
                
                // 4. Get item details and verify ownership
                String itemQuery = "SELECT ITEM_NAME, PRICE FROM ITEMS WHERE ITEM_ID = ? AND USER_ID = ? AND (STATUS = 'AVAILABLE' OR STATUS = 'APPROVED')";
                PreparedStatement itemStmt = conn.prepareStatement(itemQuery);
                itemStmt.setInt(1, itemId);
                itemStmt.setInt(2, sellerId);
                ResultSet itemRs = itemStmt.executeQuery();
                
                if (!itemRs.next()) {
                    conn.rollback();
                    itemStmt.close();
                    conn.close();
                    session.setAttribute("errorMessage", "Item not found, not owned by you, or not available for sale");
                    response.sendRedirect("ProfileServlet");
                    return;
                }
                
                String itemName = itemRs.getString("ITEM_NAME");
                double price = itemRs.getDouble("PRICE");
                itemStmt.close();
                
                // 5. Update item status to 'SOLD'
                String updateQuery = "UPDATE ITEMS SET STATUS = 'SOLD', DATE_ACTIONED = CURRENT_TIMESTAMP WHERE ITEM_ID = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
                updateStmt.setInt(1, itemId);
                int rowsUpdated = updateStmt.executeUpdate();
                updateStmt.close();
                
                if (rowsUpdated == 0) {
                    conn.rollback();
                    conn.close();
                    session.setAttribute("errorMessage", "Failed to update item status");
                    response.sendRedirect("ProfileServlet");
                    return;
                }
                
                // 6. Check if TRANSACTIONS table exists, create if not
                boolean transactionsTableExists = false;
                try {
                    PreparedStatement checkTableStmt = conn.prepareStatement(
                        "SELECT 1 FROM SYS.SYSTABLES WHERE TABLENAME = 'TRANSACTIONS'"
                    );
                    transactionsTableExists = checkTableStmt.executeQuery().next();
                    checkTableStmt.close();
                } catch (Exception e) {
                    // Table doesn't exist
                }
                
                if (!transactionsTableExists) {
                    // Create TRANSACTIONS table if it doesn't exist
                    String createTransactionsTable = 
                        "CREATE TABLE TRANSACTIONS (" +
                        "TRANSACTION_ID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, " +
                        "ITEM_ID INT NOT NULL, " +
                        "SELLER_ID INT NOT NULL, " +
                        "BUYER_ID INT NOT NULL, " +
                        "TRANSACTION_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "AMOUNT DECIMAL(10,2) NOT NULL, " +
                        "FOREIGN KEY (ITEM_ID) REFERENCES ITEMS(ITEM_ID), " +
                        "FOREIGN KEY (SELLER_ID) REFERENCES USERS(USER_ID), " +
                        "FOREIGN KEY (BUYER_ID) REFERENCES USERS(USER_ID)" +
                        ")";
                    PreparedStatement createStmt = conn.prepareStatement(createTransactionsTable);
                    createStmt.executeUpdate();
                    createStmt.close();
                }
                
                // 7. Insert into TRANSACTIONS table
                String transactionQuery = "INSERT INTO TRANSACTIONS (ITEM_ID, SELLER_ID, BUYER_ID, AMOUNT) VALUES (?, ?, ?, ?)";
                PreparedStatement transStmt = conn.prepareStatement(transactionQuery);
                transStmt.setInt(1, itemId);
                transStmt.setInt(2, sellerId);
                transStmt.setInt(3, buyerId);
                transStmt.setDouble(4, price);
                transStmt.executeUpdate();
                transStmt.close();
                
                // 8. Also try to insert into old PURCHASES table for backward compatibility
                try {
                    String purchaseQuery = "INSERT INTO PURCHASES (ITEM_ID, BUYER_ID, SELLER_ID, AMOUNT) VALUES (?, ?, ?, ?)";
                    PreparedStatement purchaseStmt = conn.prepareStatement(purchaseQuery);
                    purchaseStmt.setInt(1, itemId);
                    purchaseStmt.setInt(2, buyerId);
                    purchaseStmt.setInt(3, sellerId);
                    purchaseStmt.setDouble(4, price);
                    purchaseStmt.executeUpdate();
                    purchaseStmt.close();
                } catch (Exception e) {
                    System.out.println("Note: PURCHASES table doesn't exist. Using TRANSACTIONS table only.");
                }
                
                // 9. Commit transaction
                conn.commit();
                
                // Set success message
                String successMsg = "Item '" + itemName + "' successfully marked as sold to " + 
                                   (buyerName != null ? buyerName : buyerUsername) + "!";
                session.setAttribute("successMessage", successMsg);
                
                // Redirect back to profile
                response.sendRedirect("ProfileServlet");
                
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
            response.sendRedirect("ProfileServlet");
        }
    }
}