package com.marketplace.model;

import java.io.Serializable;

/**
 * Model class representing a product category in the marketplace.
 */
public class Category implements Serializable {
    private int id;
    private String name;
    private String description;
    private String iconClass; // Stores FontAwesome icon classes (e.g., "fas fa-book")

    public Category() {}

    public Category(int id, String name, String description, String iconClass) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.iconClass = iconClass;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIconClass() { return iconClass; }
    public void setIconClass(String iconClass) { this.iconClass = iconClass; }
}