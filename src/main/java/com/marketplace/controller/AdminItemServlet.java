import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminItemServlet", urlPatterns = {"/AdminItemServlet"})
public class AdminItemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

            if ("updateItem".equals(action)) {
                // --- UPDATE LOGIC ---
                int id = Integer.parseInt(request.getParameter("itemId"));
                double price = Double.parseDouble(request.getParameter("price"));
                String status = request.getParameter("status");

                String sql = "UPDATE ITEMS SET PRICE = ?, STATUS = ? WHERE ITEM_ID = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setDouble(1, price);
                pstmt.setString(2, status);
                pstmt.setInt(3, id);
                
                pstmt.executeUpdate();
                pstmt.close();
            } 
            else if ("delete".equals(action)) {
                // --- DELETE LOGIC ---
                int id = Integer.parseInt(request.getParameter("itemId"));
                
                String sql = "DELETE FROM ITEMS WHERE ITEM_ID = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, id);
                
                pstmt.executeUpdate();
                pstmt.close();
            }

            conn.close();
            // Redirect back to the page to show changes
            response.sendRedirect("manage_items.jsp?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_items.jsp?msg=error");
        }
    }
}