/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.marketplace.controller;

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

@WebServlet("/CategoryServlet")
public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String categoryId = request.getParameter("id");
        
        if ("view".equals(action) && categoryId != null) {
            // Map category IDs to search terms
            String categoryTerm = "";
            switch(categoryId) {
                case "1": categoryTerm = "book"; break;
                case "2": categoryTerm = "laptop|phone|electronic|gadget"; break;
                case "3": categoryTerm = "uniform|clothing|shirt|dress"; break;
                case "4": categoryTerm = ""; break; // Other items
                default: categoryTerm = "";
            }
            
            // Redirect to browse with category filter
            if (!categoryTerm.isEmpty()) {
                response.sendRedirect("browse-item.jsp?category=" + categoryTerm);
            } else {
                response.sendRedirect("browse-item.jsp");
            }
        } else {
            response.sendRedirect("categories.jsp");
        }
    }
}