package com.marketplace.dao;

import com.marketplace.model.Category;
import com.marketplace.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM CATEGORIES"; // Assuming your table name is CATEGORIES
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Category cat = new Category();
                cat.setId(rs.getInt("category_id"));
                cat.setName(rs.getString("category_name"));
                // Optional: add description/icon mapping if columns exist
                categories.add(cat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
}