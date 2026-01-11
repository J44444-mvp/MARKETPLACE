package com.marketplace.dao;

import com.marketplace.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private Connection connection;
    
    public UserDAO() {
        try {
            // Initialize Derby database connection
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn= DriverManager.getConnection(
                "jdbc:derby://localhost:1527/campus_marketplace", 
                "app", 
                "app"
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // User registration
    public boolean registerUser(User user) {
        String query = "INSERT INTO USERS (USERNAME, PASSWORD, FULL_NAME, EMAIL, PHONE_NUMBER, ROLE) " +
                      "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getPhoneNumber());
            stmt.setString(6, "user"); // Default role
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // User login
    public User login(String username, String password) {
        User user = null;
        String query = "SELECT * FROM USERS WHERE USERNAME = ? AND PASSWORD = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
    }
    
    // Get user by ID
    public User getUserById(int userId) {
        User user = null;
        String query = "SELECT * FROM USERS WHERE USER_ID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
    }
    
    // Get user by username
    public User getUserByUsername(String username) {
        User user = null;
        String query = "SELECT * FROM USERS WHERE USERNAME = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
    }
    
    // Get user by email
    public User getUserByEmail(String email) {
        User user = null;
        String query = "SELECT * FROM USERS WHERE EMAIL = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, email);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
    }
    
    // Update user profile
    public boolean updateUserProfile(int userId, String fullName, String email, String phoneNumber) {
        String query = "UPDATE USERS SET FULL_NAME = ?, EMAIL = ?, PHONE_NUMBER = ? WHERE USER_ID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, phoneNumber);
            stmt.setInt(4, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Update password
    public boolean updatePassword(int userId, String newPassword) {
        String query = "UPDATE USERS SET PASSWORD = ? WHERE USER_ID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Save reset token
    public boolean saveResetToken(String email, String token, Timestamp expiry) {
        String query = "UPDATE USERS SET RESET_TOKEN = ?, TOKEN_EXPIRY = ? WHERE EMAIL = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, token);
            stmt.setTimestamp(2, expiry);
            stmt.setString(3, email);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get user by reset token
    public User getUserByResetToken(String token) {
        User user = null;
        String query = "SELECT * FROM USERS WHERE RESET_TOKEN = ? AND TOKEN_EXPIRY > CURRENT_TIMESTAMP";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, token);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
    }
    
    // Clear reset token after password reset
    public boolean clearResetToken(int userId) {
        String query = "UPDATE USERS SET RESET_TOKEN = NULL, TOKEN_EXPIRY = NULL WHERE USER_ID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all users (for admin)
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM USERS ORDER BY USER_ID DESC";
        
        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                User user = extractUserFromResultSet(rs);
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return users;
    }
    
    // Delete user (for admin)
    public boolean deleteUser(int userId) {
        String query = "DELETE FROM USERS WHERE USER_ID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Update user role (for admin)
    public boolean updateUserRole(int userId, String role) {
        String query = "UPDATE USERS SET ROLE = ? WHERE USER_ID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, role);
            stmt.setInt(2, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Check if username exists
    public boolean usernameExists(String username) {
        String query = "SELECT COUNT(*) FROM USERS WHERE USERNAME = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Check if email exists
    public boolean emailExists(String email) {
        String query = "SELECT COUNT(*) FROM USERS WHERE EMAIL = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, email);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Get user ID by username (needed for ItemDAO)
    public int getUserIdByUsername(String username) {
        int userId = -1;
        String query = "SELECT USER_ID FROM USERS WHERE USERNAME = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("USER_ID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return userId;
    }
    
    // Helper method to extract User from ResultSet
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("USER_ID"));
        user.setUsername(rs.getString("USERNAME"));
        user.setPassword(rs.getString("PASSWORD"));
        user.setFullName(rs.getString("FULL_NAME"));
        user.setEmail(rs.getString("EMAIL"));
        user.setRole(rs.getString("ROLE"));
        user.setResetToken(rs.getString("RESET_TOKEN"));
        user.setTokenExpiry(rs.getTimestamp("TOKEN_EXPIRY"));
        user.setPhoneNumber(rs.getString("PHONE_NUMBER"));
        return user;
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