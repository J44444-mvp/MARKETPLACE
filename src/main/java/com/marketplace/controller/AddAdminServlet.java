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

        // 2. Get role parameter (default to 'admin' if not provided)
        String role = request.getParameter("role");
        if (role == null || role.trim().isEmpty()) {
            role = "admin"; // Default to admin for Add Admin functionality
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // 3. Connect to Database
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

            // 4. Check if username already exists
            String checkSql = "SELECT COUNT(*) FROM USERS WHERE USERNAME = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, username);
            var rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                // Username already exists
                response.sendRedirect("manage_user.jsp?error=username_exists");
                rs.close();
                checkStmt.close();
                return;
            }
            rs.close();
            checkStmt.close();

            // 5. Insert new admin user with ROLE column
            String sql = "INSERT INTO USERS (USERNAME, FULL_NAME, EMAIL, PHONE_NUMBER, PASSWORD, ROLE) VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, fullName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, password); // In a real app, hash this password!
            ps.setString(6, role); // Set ROLE to 'admin'
            
            int result = ps.executeUpdate();
            
            if(result > 0) {
                // Success
                response.sendRedirect("manage_user.jsp?msg=added");
            } else {
                response.sendRedirect("manage_user.jsp?error=failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_user.jsp?error=exception&message=" + e.getMessage());
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e){}
            try { if(conn != null) conn.close(); } catch(Exception e){}
        }
    }
}