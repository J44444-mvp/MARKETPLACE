package com.marketplace.dao;

import com.marketplace.model.Item;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {
    private Connection connection;
    
    public ItemDAO() {
        try {
            // Initialize Derby database connection
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            
            Connection conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/campus_marketplace", 
                "app", 
                "app"
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Get items by user ID and status
        public List<Item> getItemsByUserIdAndStatus(int userId, String status) {
         List<Item> items = new ArrayList<>();
         String query = "SELECT i.*, c.CATEGORY_NAME FROM ITEMS i " +
                        "LEFT JOIN CATEGORIES c ON i.CATEGORY_ID = c.CATEGORY_ID " +
                        "WHERE i.USER_ID = ? AND i.STATUS = ? " +
                        "ORDER BY i.DATE_SUBMITTED DESC";

         try (PreparedStatement stmt = connection.prepareStatement(query)) {
             stmt.setInt(1, userId);
             stmt.setString(2, status);

             System.out.println("Executing query: " + query);
             System.out.println("Parameters: userId=" + userId + ", status=" + status);

             ResultSet rs = stmt.executeQuery();
             int count = 0;
             while (rs.next()) {
                 count++;
                 Item item = extractItemFromResultSet(rs);
                 items.add(item);
                 System.out.println("Found item: " + item.getItemName());
             }
             System.out.println("Total items found: " + count);

         } catch (SQLException e) {
             System.out.println("SQL Error in getItemsByUserIdAndStatus: " + e.getMessage());
             e.printStackTrace();
         }

         return items;
     }
    
    // Get items purchased by a user (using TRANSACTIONS table)
    public List<Item> getPurchasedItemsByUserId(int userId) {
        List<Item> items = new ArrayList<>();
        String query = "SELECT i.* FROM ITEMS i " +
                      "INNER JOIN TRANSACTIONS t ON i.ITEM_ID = t.ITEM_ID " +
                      "WHERE t.BUYER_ID = ? AND i.STATUS = 'sold' " +
                      "ORDER BY t.TRANSACTION_DATE DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Item item = extractItemFromResultSet(rs);
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return items;
    }
    
    // Get count of sold items by user
    public int getSoldItemCountByUser(int userId) {
        int count = 0;
        String query = "SELECT COUNT(*) FROM ITEMS WHERE USER_ID = ? AND STATUS = 'sold'";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }
    
    // Mark item as sold
    public boolean markItemAsSold(int itemId, String buyerUsername) {
        // First, get buyer's user ID from username
        UserDAO userDAO = new UserDAO();
        int buyerId = userDAO.getUserIdByUsername(buyerUsername);
        
        if (buyerId == -1) {
            return false; // Buyer not found
        }
        
        try {
            connection.setAutoCommit(false);
            
            // Get seller ID and price for the transaction
            int sellerId = 0;
            double price = 0;
            String getItemQuery = "SELECT USER_ID, PRICE FROM ITEMS WHERE ITEM_ID = ?";
            
            try (PreparedStatement stmt = connection.prepareStatement(getItemQuery)) {
                stmt.setInt(1, itemId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    sellerId = rs.getInt("USER_ID");
                    price = rs.getDouble("PRICE");
                } else {
                    connection.rollback();
                    return false;
                }
            }
            
            // Update item status and date
            String updateItemQuery = "UPDATE ITEMS SET STATUS = 'sold', DATE_ACTIONED = CURRENT_TIMESTAMP WHERE ITEM_ID = ?";
            try (PreparedStatement stmt = connection.prepareStatement(updateItemQuery)) {
                stmt.setInt(1, itemId);
                stmt.executeUpdate();
            }
            
            // Record transaction
            String insertTransactionQuery = "INSERT INTO TRANSACTIONS (ITEM_ID, SELLER_ID, BUYER_ID, TRANSACTION_DATE, AMOUNT) " +
                                          "VALUES (?, ?, ?, CURRENT_TIMESTAMP, ?)";
            try (PreparedStatement stmt = connection.prepareStatement(insertTransactionQuery)) {
                stmt.setInt(1, itemId);
                stmt.setInt(2, sellerId);
                stmt.setInt(3, buyerId);
                stmt.setDouble(4, price);
                stmt.executeUpdate();
            }
            
            connection.commit();
            return true;
            
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Delete item
    public boolean deleteItem(int itemId) {
        String query = "DELETE FROM ITEMS WHERE ITEM_ID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, itemId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get item by ID
    public Item getItemById(int itemId) {
        Item item = null;
        String query = "SELECT * FROM ITEMS WHERE ITEM_ID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, itemId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                item = extractItemFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return item;
    }
    
    // Get all available items (for browsing)
    public List<Item> getAvailableItems() {
        List<Item> items = new ArrayList<>();
        String query = "SELECT * FROM ITEMS WHERE STATUS = 'available' ORDER BY DATE_SUBMITTED DESC";
        
        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                Item item = extractItemFromResultSet(rs);
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return items;
    }
    
    // Add new item
    public boolean addItem(Item item) {
        String query = "INSERT INTO ITEMS (ITEM_NAME, DESCRIPTION, PRICE, STATUS, USER_ID, CATEGORY_ID, " +
                      "DATE_SUBMITTED, IMAGE_URL, IMAGE_URL2, IMAGE_URL3, CONDITION, BRAND, NEGOTIABLE, MEETUP_LOCATION) " +
                      "VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, item.getItemName());
            stmt.setString(2, item.getDescription());
            stmt.setDouble(3, item.getPrice());
            stmt.setString(4, "available");
            stmt.setInt(5, item.getUserId());
            stmt.setInt(6, item.getCategoryId());
            stmt.setString(7, item.getImageUrl());
            stmt.setString(8, item.getImageUrl2());
            stmt.setString(9, item.getImageUrl3());
            stmt.setString(10, item.getCondition());
            stmt.setString(11, item.getBrand());
            stmt.setString(12, item.getNegotiable());
            stmt.setString(13, item.getMeetupLocation());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get the generated item ID (Derby specific)
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    item.setItemId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Update item
    public boolean updateItem(Item item) {
        String query = "UPDATE ITEMS SET ITEM_NAME = ?, DESCRIPTION = ?, PRICE = ?, CATEGORY_ID = ?, " +
                      "IMAGE_URL = ?, IMAGE_URL2 = ?, IMAGE_URL3 = ?, CONDITION = ?, BRAND = ?, " +
                      "NEGOTIABLE = ?, MEETUP_LOCATION = ? WHERE ITEM_ID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, item.getItemName());
            stmt.setString(2, item.getDescription());
            stmt.setDouble(3, item.getPrice());
            stmt.setInt(4, item.getCategoryId());
            stmt.setString(5, item.getImageUrl());
            stmt.setString(6, item.getImageUrl2());
            stmt.setString(7, item.getImageUrl3());
            stmt.setString(8, item.getCondition());
            stmt.setString(9, item.getBrand());
            stmt.setString(10, item.getNegotiable());
            stmt.setString(11, item.getMeetupLocation());
            stmt.setInt(12, item.getItemId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get items by category
    public List<Item> getItemsByCategory(int categoryId) {
        List<Item> items = new ArrayList<>();
        String query = "SELECT * FROM ITEMS WHERE CATEGORY_ID = ? AND STATUS = 'available' ORDER BY DATE_SUBMITTED DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, categoryId);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Item item = extractItemFromResultSet(rs);
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return items;
    }
    
    // Search items
    public List<Item> searchItems(String keyword) {
        List<Item> items = new ArrayList<>();
        String query = "SELECT * FROM ITEMS WHERE (ITEM_NAME LIKE ? OR DESCRIPTION LIKE ?) " +
                      "AND STATUS = 'available' ORDER BY DATE_SUBMITTED DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Item item = extractItemFromResultSet(rs);
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return items;
    }
    
    // Helper method to extract Item from ResultSet
    private Item extractItemFromResultSet(ResultSet rs) throws SQLException {
        Item item = new Item();
        item.setItemId(rs.getInt("ITEM_ID"));
        item.setItemName(rs.getString("ITEM_NAME"));
        item.setDescription(rs.getString("DESCRIPTION"));
        item.setPrice(rs.getDouble("PRICE"));
        item.setStatus(rs.getString("STATUS"));
        item.setUserId(rs.getInt("USER_ID"));
        item.setCategoryId(rs.getInt("CATEGORY_ID"));
        item.setDateSubmitted(rs.getTimestamp("DATE_SUBMITTED"));
        item.setDateActioned(rs.getTimestamp("DATE_ACTIONED"));
        item.setImageUrl(rs.getString("IMAGE_URL"));
        item.setImageUrl2(rs.getString("IMAGE_URL2"));
        item.setImageUrl3(rs.getString("IMAGE_URL3"));
        item.setCondition(rs.getString("CONDITION"));
        item.setBrand(rs.getString("BRAND"));
        item.setNegotiable(rs.getString("NEGOTIABLE"));
        item.setMeetupLocation(rs.getString("MEETUP_LOCATION"));
        return item;
    }
    
    // Close connection
    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}