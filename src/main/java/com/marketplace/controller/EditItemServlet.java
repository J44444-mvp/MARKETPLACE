package com.marketplace.controller;

import com.marketplace.model.Item;
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

@WebServlet("/EditItemServlet")
public class EditItemServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String itemIdStr = request.getParameter("id");
        
        if (itemIdStr == null) {
            session.setAttribute("errorMessage", "Invalid item ID");
            response.sendRedirect("ProfileServlet");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(itemIdStr);
            
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            String selectQuery = "SELECT * FROM ITEMS WHERE ITEM_ID = ?";
            PreparedStatement selectStmt = conn.prepareStatement(selectQuery);
            selectStmt.setInt(1, itemId);
            ResultSet rs = selectStmt.executeQuery();
            
            if (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("ITEM_ID"));
                item.setItemName(rs.getString("ITEM_NAME"));
                item.setDescription(rs.getString("DESCRIPTION"));
                item.setPrice(rs.getDouble("PRICE"));
                item.setStatus(rs.getString("STATUS"));
                item.setUserId(rs.getInt("USER_ID"));
                item.setCategoryId(rs.getInt("CATEGORY_ID"));
                item.setCondition(rs.getString("CONDITION"));
                item.setBrand(rs.getString("BRAND"));
                item.setNegotiable(rs.getString("NEGOTIABLE"));
                item.setMeetupLocation(rs.getString("MEETUP_LOCATION"));
                
                request.setAttribute("item", item);
                
                selectStmt.close();
                conn.close();
                
                request.getRequestDispatcher("edit-item.jsp").forward(request, response);
            } else {
                selectStmt.close();
                conn.close();
                
                session.setAttribute("errorMessage", "Item not found");
                response.sendRedirect("ProfileServlet");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading item: " + e.getMessage());
            response.sendRedirect("ProfileServlet");
        }
    }
}