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
import java.net.URLEncoder;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get parameters from JSP
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNumber");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 2. Connect to Database
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

            // 3. Check if username already exists
            String checkUserSQL = "SELECT USER_ID FROM USERS WHERE USERNAME = ?";
            pstmt = conn.prepareStatement(checkUserSQL);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Username already exists
                response.sendRedirect("register.jsp?status=error&message=" + 
                    URLEncoder.encode("Username already exists. Please choose another.", "UTF-8"));
                return;
            }
            rs.close();
            pstmt.close();
            
            // 4. Check if email already exists
            String checkEmailSQL = "SELECT USER_ID FROM USERS WHERE EMAIL = ?";
            pstmt = conn.prepareStatement(checkEmailSQL);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Email already exists
                response.sendRedirect("register.jsp?status=error&message=" + 
                    URLEncoder.encode("Email already registered. Please use another email.", "UTF-8"));
                return;
            }
            rs.close();
            pstmt.close();

            // 5. Insert Query
            String insertSQL = "INSERT INTO USERS (FULL_NAME, USERNAME, EMAIL, PASSWORD, PHONE_NUMBER) VALUES (?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(insertSQL);
            pstmt.setString(1, fullName);
            pstmt.setString(2, username);
            pstmt.setString(3, email);
            pstmt.setString(4, password);
            pstmt.setString(5, phone);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                // Success: Redirect back to register page with success status
                response.sendRedirect("register.jsp?status=success");
            } else {
                // Insert failed
                response.sendRedirect("register.jsp?status=error&message=" + 
                    URLEncoder.encode("Registration failed. Please try again.", "UTF-8"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.sendRedirect("register.jsp?status=error&message=" + 
                    URLEncoder.encode("Server error: " + e.getMessage(), "UTF-8"));
            } catch (Exception ex) {
                response.sendRedirect("register.jsp?status=error&message=Server+error");
            }
        } finally {
            // Clean up resources
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}