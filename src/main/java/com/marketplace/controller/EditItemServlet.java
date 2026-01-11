package com.marketplace.controller;

import com.marketplace.dao.ItemDAO;
import com.marketplace.model.Item;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "EditItemServlet", value = "/EditItemServlet")
public class EditItemServlet extends HttpServlet {
    private ItemDAO itemDAO;
    
    @Override
    public void init() {
        itemDAO = new ItemDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(request.getParameter("id"));
            Item item = itemDAO.getItemById(itemId);
            
            if (item != null) {
                request.setAttribute("item", item);
                RequestDispatcher dispatcher = request.getRequestDispatcher("edit-item.jsp");
                dispatcher.forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Item not found.");
                response.sendRedirect("ProfileServlet");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid item ID.");
            response.sendRedirect("ProfileServlet");
        }
    }
}