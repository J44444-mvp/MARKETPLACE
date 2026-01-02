package com.marketplace.controller;

import com.marketplace.dao.UserDAO;
import com.marketplace.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String name = request.getParameter("fullname");
        String email = request.getParameter("email");
        
        User newUser = new User();
        newUser.setUsername(user);
        newUser.setPassword(pass);
        newUser.setFullName(name);
        newUser.setEmail(email);
        
        UserDAO dao = new UserDAO();
        boolean success = dao.register(newUser);
        
        if (success) {
            response.sendRedirect("login.jsp?success=Registration Successful! Please Login.");
        } else {
            response.sendRedirect("register.jsp?error=Username already taken.");
        }
    }
}