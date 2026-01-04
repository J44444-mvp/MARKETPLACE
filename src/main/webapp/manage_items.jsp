<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Items - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Reuse CSS from above */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; }
        .sidebar { width: 260px; background-color: #800000; color: white; display: flex; flex-direction: column; padding: 20px; position: fixed; height: 100%; }
        .sidebar a { text-decoration: none; color: rgba(255,255,255,0.8); padding: 15px; display: flex; align-items: center; gap: 15px; border-radius: 8px; margin-bottom: 10px; transition: 0.3s; }
        .sidebar a:hover, .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }
        .main-content { margin-left: 260px; flex: 1; padding: 30px; }
        
        /* Table & Form Styles */
        .table-container { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #800000; color: white; padding: 15px; text-align: left; }
        td { padding: 10px; border-bottom: 1px solid #eee; vertical-align: middle; }
        
        .form-inline { display: flex; gap: 5px; align-items: center; }
        .form-input { padding: 5px; border: 1px solid #ddd; border-radius: 4px; width: 80px; }
        .btn-update { background-color: #007bff; color: white; border: none; padding: 6px 10px; border-radius: 4px; cursor: pointer; }
        .btn-delete { background-color: #dc3545; color: white; border: none; padding: 6px 10px; border-radius: 4px; cursor: pointer; }
    </style>
</head>
<body>

  <div class="sidebar">
    <div class="sidebar-header">
        <i class="fas fa-user-shield"></i> Admin Panel
    </div>

    <a href="admin_dashboard.jsp" 
       class="<%= request.getRequestURI().contains("admin_dashboard.jsp") ? "active" : "" %>">
        <i class="fas fa-tachometer-alt"></i> Dashboard
    </a>

    <a href="manage_items.jsp" 
       class="<%= request.getRequestURI().contains("manage_items.jsp") ? "active" : "" %>">
        <i class="fas fa-boxes"></i> Manage Items
    </a>

    <a href="manage_user.jsp" 
       class="<%= request.getRequestURI().contains("manage_user.jsp") ? "active" : "" %>">
        <i class="fas fa-users"></i> Users
    </a>

    <a href="approvals.jsp" 
       class="<%= request.getRequestURI().contains("approvals.jsp") ? "active" : "" %>">
        <i class="fas fa-check-circle"></i> Approvals
    </a>

    <a href="LogoutServlet" class="logout-btn">
        <i class="fas fa-sign-out-alt"></i> Logout
    </a>
</div>

    <div class="main-content">
        <h2>Manage Items</h2>
        
        <% if(request.getParameter("msg") != null) { %>
            <div style="background: #d4edda; color: #155724; padding: 15px; margin: 20px 0; border-radius: 5px;">
                <%= request.getParameter("msg") %>
            </div>
        <% } %>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Item</th>
                        <th>Price ($)</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM ITEMS");

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("item_name") %></td>
                        
                        <form action="AdminItemServlet" method="POST">
                            <input type="hidden" name="itemId" value="<%= rs.getInt("item_id") %>">
                            
                            <td>
                                <input type="number" step="0.01" name="price" value="<%= rs.getDouble("price") %>" class="form-input">
                            </td>
                            <td>
                                <select name="status" class="form-input" style="width: 100px;">
                                    <option value="AVAILABLE" <%= "AVAILABLE".equals(rs.getString("status")) ? "selected" : "" %>>Available</option>
                                    <option value="PENDING" <%= "PENDING".equals(rs.getString("status")) ? "selected" : "" %>>Pending</option>
                                    <option value="SOLD" <%= "SOLD".equals(rs.getString("status")) ? "selected" : "" %>>Sold</option>
                                </select>
                            </td>
                            <td>
                                <div class="form-inline">
                                    <button type="submit" name="action" value="update" class="btn-update"><i class="fas fa-save"></i></button>
                                    <button type="submit" name="action" value="delete" class="btn-delete" onclick="return confirm('Delete this item?');"><i class="fas fa-trash"></i></button>
                                </div>
                            </td>
                        </form>
                    </tr>
                    <%
                            }
                            conn.close();
                        } catch (Exception e) { e.printStackTrace(); }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>