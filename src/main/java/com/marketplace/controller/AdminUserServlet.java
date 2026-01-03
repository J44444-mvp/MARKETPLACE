package com.marketplace.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AdminUserServlet")
public class AdminUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int userId = Integer.parseInt(request.getParameter("userId"));

        if ("delete".equals(action)) {
            try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

                // 1. First Delete User's Items (Foreign Key Constraint)
                String deleteItems = "DELETE FROM ITEMS WHERE USER_ID = ?";
                PreparedStatement ps1 = conn.prepareStatement(deleteItems);
                ps1.setInt(1, userId);
                ps1.executeUpdate();

                // 2. Then Delete the User
                String deleteUser = "DELETE FROM USERS WHERE USER_ID = ?";
                PreparedStatement ps2 = conn.prepareStatement(deleteUser);
                ps2.setInt(1, userId);
                ps2.executeUpdate();

                conn.close();
                response.sendRedirect("manage_users.jsp?msg=User deleted successfully");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("manage_users.jsp?msg=Error deleting user");
            }
        }
    }
}