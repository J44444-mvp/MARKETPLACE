package com.marketplace.controller;

import com.marketplace.dao.UserDAO;
import com.marketplace.dao.ItemDAO;
import com.marketplace.model.User;
import com.marketplace.model.Item;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProfileServlet", value = "/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;
    private ItemDAO itemDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
        itemDAO = new ItemDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();
        
        // Get user's active listings (status = 'available')
        List<Item> activeItems = itemDAO.getItemsByUserIdAndStatus(userId, "available");
        
        // Get user's sold items (status = 'sold')
        List<Item> soldItems = itemDAO.getItemsByUserIdAndStatus(userId, "sold");
        
        // Get user's purchased items
        List<Item> purchasedItems = itemDAO.getPurchasedItemsByUserId(userId);
        
        // Get user's total sold count
        int soldCount = itemDAO.getSoldItemCountByUser(userId);
        
        // Set attributes for JSP
        request.setAttribute("activeItems", activeItems);
        request.setAttribute("soldItems", soldItems);
        request.setAttribute("purchasedItems", purchasedItems);
        request.setAttribute("soldCount", soldCount);
        
        // Forward to profile.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
        dispatcher.forward(request, response);
    }
}