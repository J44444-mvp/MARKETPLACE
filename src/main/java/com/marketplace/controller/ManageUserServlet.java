import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ManageUserServlet", urlPatterns = {"/ManageUserServlet"})
public class ManageUserServlet extends HttpServlet {

    // Database Configuration
    private static final String DB_URL = "jdbc:derby://localhost:1527/campus_marketplace";
    private static final String DB_USER = "app";
    private static final String DB_PASS = "app";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        // Retrieve username to determine if the target is an Admin or User
        String username = request.getParameter("username"); 
        boolean isAdmin = (username != null && username.toLowerCase().startsWith("admin"));

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // --- UPDATE LOGIC ---
            if ("update".equals(action)) {
                
                int userId = Integer.parseInt(request.getParameter("userId"));
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String password = request.getParameter("password");

                String sql;

                // Update password only if a new one is provided
                if (password != null && !password.trim().isEmpty()) {
                    sql = "UPDATE USERS SET FULL_NAME=?, EMAIL=?, PHONE_NUMBER=?, PASSWORD=? WHERE USER_ID=?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, fullName);
                    stmt.setString(2, email);
                    stmt.setString(3, phone);
                    stmt.setString(4, password);
                    stmt.setInt(5, userId);
                } else {
                    sql = "UPDATE USERS SET FULL_NAME=?, EMAIL=?, PHONE_NUMBER=? WHERE USER_ID=?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, fullName);
                    stmt.setString(2, email);
                    stmt.setString(3, phone);
                    stmt.setInt(4, userId);
                }

                stmt.executeUpdate();
                
                // Redirect with specific message
                if (isAdmin) {
                    response.sendRedirect("manage_user.jsp?msg=admin_updated");
                } else {
                    response.sendRedirect("manage_user.jsp?msg=user_updated");
                }

            // --- DELETE LOGIC ---
            } else if ("delete".equals(action)) {
                
                int userId = Integer.parseInt(request.getParameter("userId"));

                String sql = "DELETE FROM USERS WHERE USER_ID=?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);

                stmt.executeUpdate();

                // Redirect with specific message
                if (isAdmin) {
                    response.sendRedirect("manage_user.jsp?msg=admin_deleted");
                } else {
                    response.sendRedirect("manage_user.jsp?msg=user_deleted");
                }
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manage_user.jsp?error=true");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}