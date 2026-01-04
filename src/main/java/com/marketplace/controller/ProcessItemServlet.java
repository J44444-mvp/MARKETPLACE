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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemId = request.getParameter("itemId");
        String action = request.getParameter("action"); // Will be "approve" or "reject"

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

            String sql;
            if ("approve".equals(action)) {
                sql = "UPDATE ITEMS SET STATUS = 'APPROVED' WHERE ITEM_ID = ?";
            } else {
                // Option A: Mark as Rejected (Keeps record)
                sql = "UPDATE ITEMS SET STATUS = 'REJECTED' WHERE ITEM_ID = ?";
                // Option B: Delete completely (Uncomment below if you prefer delete)
                // sql = "DELETE FROM ITEMS WHERE ITEM_ID = ?";
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(itemId));
            stmt.executeUpdate();
            
            conn.close();
            
            // Redirect back with success message
            response.sendRedirect("approvals.jsp?status=success&act=" + action);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("approvals.jsp?status=error");
        }
    }
}