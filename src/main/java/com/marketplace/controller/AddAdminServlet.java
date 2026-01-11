package com.marketplace.controller; // <--- CHECK YOUR PACKAGE NAME

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddAdminServlet")
public class AddAdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Retrieve form data
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // 2. Connect to Database
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

            // 3. Insert new user
            String sql = "INSERT INTO USERS (USERNAME, FULL_NAME, EMAIL, PHONE_NUMBER, PASSWORD) VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, fullName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, password); // In a real app, hash this password!
            
            int result = ps.executeUpdate();
            
            if(result > 0) {
                // Success
                response.sendRedirect("manage_user.jsp?msg=added");
            } else {
                response.sendRedirect("manage_user.jsp?error=failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_user.jsp?error=exception");
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e){}
            try { if(conn != null) conn.close(); } catch(Exception e){}
        }
    }
}