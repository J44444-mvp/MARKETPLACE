import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    // Database Connection Settings (Matches your screenshot)
    private static final String DB_URL = "jdbc:derby://localhost:1527/campus_marketplace";
    private static final String DB_USER = "app";
    private static final String DB_PASS = "app";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. GET AND CLEAN INPUT
        String email = request.getParameter("email");
        if (email != null) {
            email = email.trim(); // CRITICAL FIX: Removes hidden spaces!
        }

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement updateStmt = null;
        ResultSet rs = null;

        try {
            // 2. CONNECT TO DATABASE
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // 3. CHECK IF EMAIL EXISTS
            String checkSql = "SELECT * FROM users WHERE email = ?";
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                // --- USER FOUND ---
                
                // 4. GENERATE TOKEN
                String token = UUID.randomUUID().toString();
                // Token expires in 1 hour (3600000 milliseconds)
                Timestamp expiry = new Timestamp(System.currentTimeMillis() + 3600000);

                // 5. UPDATE DATABASE WITH TOKEN
                String updateSql = "UPDATE users SET reset_token = ?, token_expiry = ? WHERE email = ?";
                updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setString(1, token);
                updateStmt.setTimestamp(2, expiry);
                updateStmt.setString(3, email);
                updateStmt.executeUpdate();

                // 6. GENERATE LINK (For testing, we print to console)
                // NOTE: Change 'MARKETPLACE' below to your actual project name if different
                // Get the correct project name automatically (e.g., /MARKETPLACE-1.0-SNAPSHOT)
String contextPath = request.getContextPath(); 
String resetLink = "http://localhost:8080" + contextPath + "/reset_password.jsp?token=" + token;
                
                System.out.println("=========================================");
                System.out.println(" PASSWORD RESET REQUESTED ");
                System.out.println(" Email: " + email);
                System.out.println(" LINK: " + resetLink);
                System.out.println("=========================================");

                // In a real app, you would send this link via JavaMail here.
                
                request.setAttribute("message", "Reset link has been sent to your email (Check Server Logs for link).");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);

            } else {
                // --- USER NOT FOUND ---
                System.out.println("FAILED: Email not found for input: '" + email + "'");
                request.setAttribute("error", "Email address not found.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
        } finally {
            // 7. CLOSE RESOURCES
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (checkStmt != null) checkStmt.close(); } catch (Exception e) {}
            try { if (updateStmt != null) updateStmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}