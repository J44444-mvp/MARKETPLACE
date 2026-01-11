package com.marketplace.controller;

import com.marketplace.dao.UserDAO;
import com.marketplace.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "UpdateProfileServlet", value = "/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        int userId = currentUser.getUserId();
        
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        
        // Update user in database
        boolean success = userDAO.updateUserProfile(userId, fullName, email, phoneNumber);
        
        if (success) {
            // Update session with new user data
            User updatedUser = userDAO.getUserById(userId);
            session.setAttribute("user", updatedUser);
            session.setAttribute("successMessage", "Profile updated successfully!");
        } else {
            session.setAttribute("errorMessage", "Failed to update profile. Please try again.");
        }
        
        response.sendRedirect("ProfileServlet");
    }
}