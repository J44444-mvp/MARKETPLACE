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

@WebServlet("/ProcessItemServlet")
public class ProcessItemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String itemId = request.getParameter("itemId");
        String action = request.getParameter("action"); // 'approve' or 'reject'

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // LOGIC: Update status AND set the 'Date Actioned' to right now
            String sql = "UPDATE ITEMS SET STATUS = ?, DATE_ACTIONED = CURRENT_TIMESTAMP WHERE ITEM_ID = ?";
            
            PreparedStatement pstmt = conn.prepareStatement(sql);
            
            if ("approve".equals(action)) {
                pstmt.setString(1, "APPROVED");
            } else {
                pstmt.setString(1, "REJECTED");
            }
            
            pstmt.setInt(2, Integer.parseInt(itemId));
            
            pstmt.executeUpdate();
            conn.close();
            
            // Success: Reload the page
            response.sendRedirect("approvals.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            // Optional: Redirect to an error page if something goes wrong
            response.sendRedirect("approvals.jsp?error=true");
        }
    }
}