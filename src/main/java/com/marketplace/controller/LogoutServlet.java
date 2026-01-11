package com.marketplace.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if this is a confirmed logout (after user clicks OK in popup)
        String confirmed = request.getParameter("confirmed");
        String userRole = (String) request.getSession().getAttribute("role");
        
        if ("true".equals(confirmed)) {
            // User confirmed logout
            HttpSession session = request.getSession();
            session.invalidate();
            response.sendRedirect("login.jsp");
        } else {
            // Show confirmation page with JavaScript popup
            response.setContentType("text/html");
            
            // Determine redirect URL based on user role
            String cancelUrl = "ADMIN".equals(userRole) ? "admin_dashboard.jsp" : "homepage.jsp";
            
            String html = "<!DOCTYPE html>"
                    + "<html>"
                    + "<head>"
                    + "<meta charset=\"UTF-8\">"
                    + "<title>Confirm Logout</title>"
                    + "<style>"
                    + "body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background-color: #f5f5f5; }"
                    + ".container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); text-align: center; max-width: 400px; width: 100%; }"
                    + "h2 { color: #800000; margin-bottom: 20px; }"
                    + "p { color: #666; margin-bottom: 30px; line-height: 1.5; }"
                    + ".btn-group { display: flex; gap: 15px; justify-content: center; }"
                    + ".btn { padding: 10px 25px; border-radius: 5px; cursor: pointer; font-weight: 600; text-decoration: none; display: inline-block; border: none; transition: all 0.3s; }"
                    + ".btn-confirm { background-color: #800000; color: white; }"
                    + ".btn-confirm:hover { background-color: #600000; }"
                    + ".btn-cancel { background-color: #6c757d; color: white; }"
                    + ".btn-cancel:hover { background-color: #5a6268; }"
                    + ".loader { display: none; border: 4px solid #f3f3f3; border-top: 4px solid #800000; border-radius: 50%; width: 30px; height: 30px; animation: spin 1s linear infinite; margin: 20px auto; }"
                    + "@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }"
                    + "</style>"
                    + "</head>"
                    + "<body>"
                    + "<div class=\"container\">"
                    + "<h2>Confirm Logout</h2>"
                    + "<p>Are you sure you want to log out of Campus Marketplace?</p>"
                    + "<div class=\"btn-group\">"
                    + "<a href=\"javascript:void(0)\" onclick=\"confirmLogout()\" class=\"btn btn-confirm\">Yes, Log Out</a>"
                    + "<a href=\"" + cancelUrl + "\" class=\"btn btn-cancel\">Cancel</a>"
                    + "</div>"
                    + "<div class=\"loader\" id=\"loader\"></div>"
                    + "</div>"
                    + "<script>"
                    + "function confirmLogout() {"
                    + "document.getElementById('loader').style.display = 'block';"
                    + "window.location.href = 'LogoutServlet?confirmed=true';"
                    + "}"
                    + "</script>"
                    + "</body>"
                    + "</html>";
            response.getWriter().write(html);
        }
    }
}