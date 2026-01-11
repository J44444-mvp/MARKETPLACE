package com.marketplace.model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String role;
    private String resetToken;
    private Timestamp tokenExpiry;
    private String phoneNumber;
    
    // Constructors
    public User() {}
    
    public User(int userId, String username, String password, String fullName, 
                String email, String role, String resetToken, Timestamp tokenExpiry, 
                String phoneNumber) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
        this.resetToken = resetToken;
        this.tokenExpiry = tokenExpiry;
        this.phoneNumber = phoneNumber;
    }
    
    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getResetToken() { return resetToken; }
    public void setResetToken(String resetToken) { this.resetToken = resetToken; }
    
    public Timestamp getTokenExpiry() { return tokenExpiry; }
    public void setTokenExpiry(Timestamp tokenExpiry) { this.tokenExpiry = tokenExpiry; }
    
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    
    // Convenience method for getting initials
    public String getInitials() {
        if (fullName != null && !fullName.isEmpty()) {
            String[] names = fullName.split(" ");
            if (names.length >= 2) {
                return (names[0].charAt(0) + "" + names[names.length - 1].charAt(0)).toUpperCase();
            } else {
                return fullName.substring(0, Math.min(2, fullName.length())).toUpperCase();
            }
        }
        return "U";
    }
}