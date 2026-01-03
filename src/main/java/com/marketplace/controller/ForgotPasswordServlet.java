import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:derby://localhost:1527/campus_marketplace";
    private static final String DB_USER = "app";
    private static final String DB_PASS = "app";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        if (email != null) email = email.trim(); // Remove spaces from input

        Connection conn = null;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // --- FIX: Use TRIM(email) to ignore database padding spaces ---
            String checkSql = "SELECT * FROM users WHERE TRIM(email) = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // --- USER FOUND ---
                Random rand = new Random();
                int pin = 1000 + rand.nextInt(9000); 
                String token = String.valueOf(pin); 

                // Update the token in the database (using TRIM again to be safe)
                String updateSql = "UPDATE users SET reset_token = ? WHERE TRIM(email) = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setString(1, token);
                updateStmt.setString(2, email);
                updateStmt.executeUpdate();

                // Generate Link
                String contextPath = request.getContextPath();
                String resetLink = "http://localhost:8080" + contextPath + "/reset_password.jsp?token=" + token;
                
                // --- PRINT TO GLASSFISH OUTPUT ---
                System.out.println("=========================================");
                System.out.println(" PASSWORD RESET REQUESTED ");
                System.out.println(" Email: " + email);
                System.out.println(" SECRET PIN: " + token);
                System.out.println(" LINK: " + resetLink);
                System.out.println("=========================================");
                
                request.setAttribute("message", "Reset PIN sent! Check Server Output.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);

            } else {
                // --- EMAIL NOT FOUND ---
                System.out.println("FAILED: Email not found in DB: '" + email + "'");
                request.setAttribute("error", "Email not found.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}