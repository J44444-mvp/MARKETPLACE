package com.marketplace.controller;

import com.marketplace.dao.ItemDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "DeleteItemServlet", value = "/DeleteItemServlet")
public class DeleteItemServlet extends HttpServlet {
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
            
            // Delete item from database
            boolean success = itemDAO.deleteItem(itemId);
            
            if (success) {
                session.setAttribute("successMessage", "Item deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to delete item.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid item ID.");
        }
        
        response.sendRedirect("ProfileServlet");
    }
}