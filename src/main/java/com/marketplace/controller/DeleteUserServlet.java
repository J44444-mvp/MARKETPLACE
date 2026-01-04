import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get parameters from the form
        String userId = request.getParameter("userId");
        String username = request.getParameter("username"); // Get name for the popup

        try {
            // 2. Database Connection
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

            // 3. Delete Query
            String sql = "DELETE FROM USERS WHERE USER_ID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(userId));
            
            stmt.executeUpdate();
            conn.close();

            // 4. STAY ON PAGE: Redirect back to manage_user.jsp with a success flag and the name
            // We use java.net.URLEncoder to handle spaces/special characters in names safely
            response.sendRedirect("manage_user.jsp?status=success&deletedName=" + java.net.URLEncoder.encode(username, "UTF-8"));

        } catch (Exception e) {
            e.printStackTrace();
            // If error, redirect back with error message
            response.sendRedirect("manage_user.jsp?status=error");
        }
    }
}