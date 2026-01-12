import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UpdateItemServlet")
public class UpdateItemServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            if ("update_price".equals(action)) {
                String price = request.getParameter("price");
                String sql = "UPDATE ITEMS SET price = ? WHERE item_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setDouble(1, Double.parseDouble(price));
                pstmt.setInt(2, Integer.parseInt(idStr));
                pstmt.executeUpdate();
                
            } else if ("update_status".equals(action)) {
                String status = request.getParameter("status");
                String sql = "UPDATE ITEMS SET status = ? WHERE item_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, status.toUpperCase()); // Ensure uppercase consistency
                pstmt.setInt(2, Integer.parseInt(idStr));
                pstmt.executeUpdate();
                
            } else if ("delete".equals(action)) {
                String sql = "DELETE FROM ITEMS WHERE item_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(idStr));
                pstmt.executeUpdate();
            }
            
            response.sendRedirect("manage_items.jsp?msg=success");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_items.jsp?msg=error&message=" + e.getMessage());
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}