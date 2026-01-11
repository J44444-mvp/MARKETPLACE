import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AdminItemServlet")
public class AdminItemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Capture Data
        String action = request.getParameter("action");
        String itemIdStr = request.getParameter("itemId");
        
        // Debugging: Print to NetBeans Output
        System.out.println("--- ADMIN UPDATE DEBUG ---");
        System.out.println("Action Received: " + action);
        System.out.println("Item ID: " + itemIdStr);

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // 2. Validate ID
            if (itemIdStr == null || itemIdStr.trim().isEmpty()) {
                System.out.println("Error: Item ID is missing.");
                response.sendRedirect("manage_items.jsp?msg=error_missing_id");
                return;
            }
            int itemId = Integer.parseInt(itemIdStr.trim());

            // 3. Connect to Database
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

            if ("updatePrice".equals(action)) {
                // Update Price Logic
                String newPriceStr = request.getParameter("newPrice");
                System.out.println("New Price Input: " + newPriceStr);
                
                if(newPriceStr != null && !newPriceStr.isEmpty()){
                    double newPrice = Double.parseDouble(newPriceStr.trim());
                    String sql = "UPDATE ITEMS SET PRICE = ? WHERE ITEM_ID = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setDouble(1, newPrice);
                    ps.setInt(2, itemId);
                    int rows = ps.executeUpdate();
                    System.out.println("Rows updated: " + rows);
                }

            } else if ("updateStatus".equals(action)) {
                // Update Status Logic
                String newStatus = request.getParameter("newStatus");
                System.out.println("New Status Input: " + newStatus);

                String sql = "UPDATE ITEMS SET STATUS = ? WHERE ITEM_ID = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, newStatus);
                ps.setInt(2, itemId);
                int rows = ps.executeUpdate();
                System.out.println("Rows updated: " + rows);
                
            } else if ("delete".equals(action)) {
                // Delete Logic
                System.out.println("Deleting Item...");
                String sql = "DELETE FROM ITEMS WHERE ITEM_ID = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, itemId);
                ps.executeUpdate();
            }
            
        } catch (Exception e) {
            // Print actual error to NetBeans console
            System.out.println("CRITICAL ERROR IN SERVLET:");
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e){}
            try { if(conn != null) conn.close(); } catch(Exception e){}
        }

        // 4. Redirect back
        response.sendRedirect("manage_items.jsp?msg=success");
    }
}