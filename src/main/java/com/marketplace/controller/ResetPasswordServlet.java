import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:derby://localhost:1527/campus_marketplace";
    private static final String DB_USER = "app";
    private static final String DB_PASS = "app";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get Inputs
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // --- THE FIX: Clean everything that isn't a number ---
        if (token != null) {
            token = token.replaceAll("[^0-9]", ""); 
        }

        // 2. Check Passwords Match
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("reset_password.jsp?token=" + token).forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // 3. Update Password
            // We still use TRIM(reset_token) in SQL just to be safe
            String sql = "UPDATE users SET password = ?, reset_token = NULL WHERE TRIM(reset_token) = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, password); 
            stmt.setString(2, token);
            
            int rowsUpdated = stmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                System.out.println("DEBUG: Password Updated for Token: " + token);
                response.sendRedirect("login.jsp?success=Password+Updated");
            } else {
                System.out.println("DEBUG: Failed. Token in DB didn't match: " + token);
                request.setAttribute("error", "Invalid PIN (Check if expired)");
                request.getRequestDispatcher("reset_password.jsp?token=" + token).forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database Error: " + e.getMessage());
            request.getRequestDispatcher("reset_password.jsp").forward(request, response);
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}