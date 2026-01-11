package com.marketplace.controller;

import com.marketplace.dao.ItemDAO;
import com.marketplace.model.Item;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "UpdateItemServlet", value = "/UpdateItemServlet")
public class UpdateItemServlet extends HttpServlet {
    private ItemDAO itemDAO;
    
    @Override
    public void init() {
        itemDAO = new ItemDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            
            // Create item object from form data
            Item item = new Item();
            item.setItemId(itemId);
            item.setItemName(request.getParameter("title"));
            item.setDescription(request.getParameter("description"));
            item.setPrice(Double.parseDouble(request.getParameter("price")));
            item.setCategoryId(Integer.parseInt(request.getParameter("category")));
            item.setCondition(request.getParameter("condition"));
            item.setBrand(request.getParameter("brand"));
            item.setNegotiable(request.getParameter("negotiable"));
            item.setMeetupLocation(request.getParameter("meetup"));
            
            // Update item in database
            boolean success = itemDAO.updateItem(item);
            
            if (success) {
                session.setAttribute("successMessage", "Item updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update item.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error updating item: " + e.getMessage());
        }
        
        response.sendRedirect("ProfileServlet");
    }
}