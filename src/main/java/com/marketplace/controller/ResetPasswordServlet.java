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

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:derby://localhost:1527/campus_marketplace";
    private static final String DB_USER = "app";
    private static final String DB_PASS = "app";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. GET DATA & CLEAN SPACES
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (token != null) token = token.trim(); // Fixes "invisible space" copy-paste errors
        
        // --- DEBUGGING OUTPUT ---
        System.out.println("----------------------------------------");
        System.out.println("DEBUG: Password Reset Attempt");
        System.out.println("Received Token: [" + token + "]"); // Brackets show if there are spaces
        System.out.println("New Password: " + password);
        System.out.println("----------------------------------------");

        // 2. CHECK PASSWORDS MATCH
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            // We must send the token back so the user doesn't lose it
            request.getRequestDispatcher("reset_password.jsp?token=" + token).forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement updateStmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // 3. VERIFY TOKEN
            String checkSql = "SELECT * FROM users WHERE reset_token = ?";
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, token);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                System.out.println("DEBUG: Token Found! Updating user ID: " + rs.getString("id"));
                
                // 4. UPDATE PASSWORD
                // Note: We also clear the token so it can't be used twice
                String updateSql = "UPDATE users SET password = ?, reset_token = NULL, token_expiry = NULL WHERE reset_token = ?";
                updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setString(1, password);
                updateStmt.setString(2, token);
                
                int rows = updateStmt.executeUpdate();
                
                if(rows > 0) {
                   System.out.println("DEBUG: Update Successful.");
                   response.sendRedirect("login.jsp?success=Password+Updated+Successfully");
                } else {
                   System.out.println("DEBUG: Update Failed (Rows = 0).");
                   request.setAttribute("error", "Database update failed.");
                   request.getRequestDispatcher("reset_password.jsp?token=" + token).forward(request, response);
                }
                
            } else {
                System.out.println("DEBUG: Token NOT found in database.");
                request.setAttribute("error", "Invalid or expired link. Please request a new one.");
                request.getRequestDispatcher("reset_password.jsp?token=" + token).forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System Error: " + e.getMessage());
            request.getRequestDispatcher("reset_password.jsp?token=" + token).forward(request, response);
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}