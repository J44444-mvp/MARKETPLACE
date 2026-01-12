import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/UpdateItemServlet"})
public class UpdateItemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String id = request.getParameter("id");
        
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            String sql = "";

            // 1. UPDATE PRICE
            if ("update_price".equals(action)) {
                String price = request.getParameter("price");
                sql = "UPDATE ITEMS SET price = ? WHERE item_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setDouble(1, Double.parseDouble(price));
                pstmt.setInt(2, Integer.parseInt(id));
                pstmt.executeUpdate();
            } 
            // 2. UPDATE STATUS
            else if ("update_status".equals(action)) {
                String status = request.getParameter("status");
                sql = "UPDATE ITEMS SET status = ? WHERE item_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, status);
                pstmt.setInt(2, Integer.parseInt(id));
                pstmt.executeUpdate();
            } 
            // 3. DELETE ITEM
            else if ("delete".equals(action)) {
                sql = "DELETE FROM ITEMS WHERE item_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(id));
                pstmt.executeUpdate();
            }

            // SUCCESS: Redirect back to JSP with success flag to trigger Popup
            response.sendRedirect("manage_items.jsp?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            // ERROR: Redirect back with error message (optional)
            response.sendRedirect("manage_items.jsp?msg=error");
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}