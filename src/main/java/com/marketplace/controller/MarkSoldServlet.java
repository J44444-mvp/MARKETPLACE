package com.marketplace.controller;

import com.marketplace.dao.ItemDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "MarkSoldServlet", value = "/MarkSoldServlet")
public class MarkSoldServlet extends HttpServlet {
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
            String buyerUsername = request.getParameter("buyerUsername");
            
            // Mark item as sold in database
            boolean success = itemDAO.markItemAsSold(itemId, buyerUsername);
            
            if (success) {
                session.setAttribute("successMessage", "Item marked as sold successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to mark item as sold. Please check if buyer exists.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid item ID.");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
        }
        
        response.sendRedirect("ProfileServlet");
    }
}