<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Items</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- GENERAL STYLES --- */
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; margin: 0; }

        /* --- SIDEBAR --- */
        .sidebar { 
            width: 260px; 
            background-color: #800000; 
            color: white; 
            display: flex; 
            flex-direction: column; 
            padding: 20px; 
            position: fixed; 
            height: 100%; 
        }
        .sidebar-header { font-size: 22px; font-weight: bold; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 20px; }
        .sidebar a { text-decoration: none; color: rgba(255, 255, 255, 0.8); padding: 15px; margin-bottom: 10px; display: block; border-radius: 8px; transition: 0.3s; }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.1); color: white; transform: translateX(5px); }
        .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }

        /* --- MAIN CONTENT --- */
        .main-content { margin-left: 260px; flex: 1; padding: 40px; }
        h2 { color: #800000; margin-bottom: 20px; }

        /* --- ITEM TABLE --- */
        .item-table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .item-table th { background-color: #800000; color: white; padding: 15px; text-align: left; }
        .item-table td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; }

        .delete-btn { background-color: #cc0000; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; }
        .delete-btn:hover { background-color: #990000; }
        
        /* Update Forms */
        .update-form { display: flex; gap: 8px; align-items: center; }
        .price-input { padding: 5px; width: 80px; border: 1px solid #ddd; border-radius: 4px; }
        .status-select { padding: 5px; border-radius: 4px; border: 1px solid #ccc; background: #fff; cursor: pointer;}

        /* Icons */
        .btn-icon { background: none; border: none; cursor: pointer; font-size: 18px; padding: 5px; transition: 0.2s; }
        .btn-save { color: #28a745; } /* Green for Price Save */
        .btn-save:hover { color: #1e7e34; transform: scale(1.1); }
        .btn-update { color: #007bff; } /* Blue for Status Update */
        .btn-update:hover { color: #0056b3; transform: scale(1.1); }

    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manage_items.jsp" class="active"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="admin_report.jsp"><i class="fas fa-chart-bar"></i> Reports</a>
        <a href="LogoutServlet" style="margin-top: auto;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        <h2>Manage All Items</h2>
        
        <table class="item-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Item Name</th>
                    <th>Price (RM)</th> <th>Update Status</th> <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery("SELECT * FROM ITEMS ORDER BY ITEM_ID DESC");
                        
                        boolean hasData = false;
                        while(rs.next()) {
                            hasData = true;
                            int id = rs.getInt("ITEM_ID");
                            String name = rs.getString("ITEM_NAME");
                            double price = rs.getDouble("PRICE");
                            String status = rs.getString("STATUS");
                %>
                <tr>
                    <td>#<%= id %></td>
                    <td><%= name %></td>
                    
                    <td>
                        <form action="AdminItemServlet" method="POST" class="update-form">
                            <input type="hidden" name="action" value="updatePrice">
                            <input type="hidden" name="itemId" value="<%= id %>">
                            <strong>RM</strong>
                            <input type="number" step="0.01" name="newPrice" value="<%= price %>" class="price-input">
                            <button type="submit" class="btn-icon btn-save" title="Save Price">
                                <i class="fas fa-save"></i>
                            </button>
                        </form>
                    </td>

                    <td>
                        <form action="AdminItemServlet" method="POST" class="update-form">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="itemId" value="<%= id %>">
                            
                            <select name="newStatus" class="status-select">
                                <option value="PENDING"  <%= "PENDING".equalsIgnoreCase(status) ? "selected" : "" %>>Pending</option>
                                <option value="APPROVED" <%= "APPROVED".equalsIgnoreCase(status) ? "selected" : "" %>>Available</option>
                                <option value="REJECTED" <%= "REJECTED".equalsIgnoreCase(status) ? "selected" : "" %>>Rejected</option>
                                <option value="SOLD"     <%= "SOLD".equalsIgnoreCase(status) ? "selected" : "" %>>Sold</option>
                            </select>

                            <button type="submit" class="btn-icon btn-update" title="Update Status">
                                <i class="fas fa-check-circle"></i>
                            </button>
                        </form>
                    </td>

                    <td>
                        <form action="AdminItemServlet" method="POST">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="itemId" value="<%= id %>">
                            <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this item completely?')">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                        if(!hasData) {
                %>
                    <tr><td colspan="5" style="text-align:center; padding:20px;">No items found.</td></tr>
                <%
                        }
                    } catch(Exception e) {
                        e.printStackTrace();
                    } finally {
                         if(rs != null) rs.close();
                         if(stmt != null) stmt.close();
                         if(conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>