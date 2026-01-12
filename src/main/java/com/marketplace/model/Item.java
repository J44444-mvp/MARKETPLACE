package com.marketplace.model;

import java.sql.Timestamp;

public class Item {
    private int itemId;
    private String itemName;
    private String description;
    private double price;
    private String status;
    private int userId;
    private int categoryId;
    private Timestamp dateSubmitted;
    private Timestamp dateActioned;
    private String imageUrl;
    private String imageUrl2;
    private String imageUrl3;
    private String condition;
    private String brand;
    private String negotiable;
    private String meetupLocation;
    
    // Constructors
    public Item() {}
    
    public Item(int itemId, String itemName, String description, double price, String status, 
                int userId, int categoryId, Timestamp dateSubmitted, Timestamp dateActioned,
                String imageUrl, String imageUrl2, String imageUrl3, String condition,
                String brand, String negotiable, String meetupLocation) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.description = description;
        this.price = price;
        this.status = status;
        this.userId = userId;
        this.categoryId = categoryId;
        this.dateSubmitted = dateSubmitted;
        this.dateActioned = dateActioned;
        this.imageUrl = imageUrl;
        this.imageUrl2 = imageUrl2;
        this.imageUrl3 = imageUrl3;
        this.condition = condition;
        this.brand = brand;
        this.negotiable = negotiable;
        this.meetupLocation = meetupLocation;
    }
    
    // Getters and Setters
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    
    public Timestamp getDateSubmitted() { return dateSubmitted; }
    public void setDateSubmitted(Timestamp dateSubmitted) { this.dateSubmitted = dateSubmitted; }
    
    public Timestamp getDateActioned() { return dateActioned; }
    public void setDateActioned(Timestamp dateActioned) { this.dateActioned = dateActioned; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public String getImageUrl2() { return imageUrl2; }
    public void setImageUrl2(String imageUrl2) { this.imageUrl2 = imageUrl2; }
    
    public String getImageUrl3() { return imageUrl3; }
    public void setImageUrl3(String imageUrl3) { this.imageUrl3 = imageUrl3; }
    
    public String getCondition() { return condition; }
    public void setCondition(String condition) { this.condition = condition; }
    
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    
    public String getNegotiable() { return negotiable; }
    public void setNegotiable(String negotiable) { this.negotiable = negotiable; }
    
    public String getMeetupLocation() { return meetupLocation; }
    public void setMeetupLocation(String meetupLocation) { this.meetupLocation = meetupLocation; }
}