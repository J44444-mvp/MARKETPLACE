package com.marketplace.controller;

import java.io.*;
import java.sql.*;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/SellItemServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 5,   // 5MB
    maxRequestSize = 1024 * 1024 * 15 // 15MB (increased for 3 images)
)
public class SellItemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            response.sendRedirect("login.jsp?error=Please login to sell items");
            return;
        }
        
        String itemName = request.getParameter("item_name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String category = request.getParameter("category");
        String condition = request.getParameter("condition");
        String brand = request.getParameter("brand");
        String negotiable = request.getParameter("negotiable");
        String meetupLocation = request.getParameter("meetup_location");
        
        // Validate required fields
        if (itemName == null || itemName.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            condition == null || condition.trim().isEmpty()) {
            
            response.sendRedirect("sell-item.jsp?error=Please fill in all required fields");
            return;
        }
        
        double price;
        try {
            price = Double.parseDouble(priceStr);
            if (price <= 0) {
                response.sendRedirect("sell-item.jsp?error=Price must be greater than 0");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("sell-item.jsp?error=Invalid price format");
            return;
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // Handle multiple image uploads
            String imageUrl1 = null;
            String imageUrl2 = null;
            String imageUrl3 = null;
            
            // Process first image (required)
            Part filePart1 = request.getPart("image1");
            if (filePart1 != null && filePart1.getSize() > 0) {
                imageUrl1 = saveUploadedFile(filePart1, getServletContext());
            } else {
                response.sendRedirect("sell-item.jsp?error=Please upload at least one photo (Photo 1 is required)");
                return;
            }
            
            // Process second image (optional)
            Part filePart2 = request.getPart("image2");
            if (filePart2 != null && filePart2.getSize() > 0) {
                imageUrl2 = saveUploadedFile(filePart2, getServletContext());
            }
            
            // Process third image (optional)
            Part filePart3 = request.getPart("image3");
            if (filePart3 != null && filePart3.getSize() > 0) {
                imageUrl3 = saveUploadedFile(filePart3, getServletContext());
            }
            
            // Map category to category_id
            int categoryId = getCategoryId(category);
            
            // Insert item into database with all image URLs
            String sql = "INSERT INTO ITEMS (user_id, item_name, description, price, status, " +
                        "image_url, image_url2, image_url3, category_id, condition, brand, " +
                        "negotiable, meetup_location, date_submitted) " +
                        "VALUES (?, ?, ?, ?, 'PENDING', ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
            
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userId);
            ps.setString(2, itemName);
            ps.setString(3, description);
            ps.setDouble(4, price);
            ps.setString(5, imageUrl1);
            ps.setString(6, imageUrl2);
            ps.setString(7, imageUrl3);
            ps.setInt(8, categoryId);
            ps.setString(9, condition);
            ps.setString(10, brand);
            ps.setString(11, negotiable);
            ps.setString(12, meetupLocation);
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                response.sendRedirect("sell-item.jsp?success=Item submitted for approval! It will appear in listings after admin approval.");
            } else {
                response.sendRedirect("sell-item.jsp?error=Failed to create listing. Please try again.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("sell-item.jsp?error=Database error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }
    
    private String saveUploadedFile(Part filePart, ServletContext servletContext) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        String fileName = getFileName(filePart);
        if (fileName != null && !fileName.isEmpty()) {
            // Save file to uploads directory
            String uploadPath = servletContext.getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            
            // Generate unique filename
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            File file = new File(uploadDir, uniqueFileName);
            
            try (InputStream fileContent = filePart.getInputStream();
                 OutputStream out = new FileOutputStream(file)) {
                
                byte[] buffer = new byte[1024];
                int length;
                while ((length = fileContent.read(buffer)) > 0) {
                    out.write(buffer, 0, length);
                }
            }
            
            return uniqueFileName;
        }
        
        return null;
    }
    
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }
    
    private int getCategoryId(String categoryName) {
        // Simple mapping based on your categories table
        switch(categoryName.toLowerCase()) {
            case "textbooks": return 1;
            case "electronics": return 2;
            case "uniforms": return 3;
            case "other": return 4;
            default: return 4; // Default to "Other" category
        }
    }
}