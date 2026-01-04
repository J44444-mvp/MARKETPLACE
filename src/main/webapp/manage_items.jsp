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
        /* Flexbox is required here for the logout button to stick to the bottom */
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
        
        .sidebar a { 
            text-decoration: none; 
            color: rgba(255, 255, 255, 0.8); 
            padding: 15px; 
            margin-bottom: 10px; 
            display: block; 
            border-radius: 8px; 
            transition: 0.3s; 
        }
        
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.1); color: white; transform: translateX(5px); }
        .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }

        /* --- MAIN CONTENT --- */
        .main-content { margin-left: 260px; flex: 1; padding: 40px; }
        h2 { color: #800000; margin-bottom: 20px; }

        /* --- ITEM LIST --- */
        .item-row {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .item-info h4 { margin: 0 0 5px 0; color: #333; }
        .price-tag { background: #eee; padding: 5px 10px; border-radius: 4px; font-weight: bold; }
        
        .delete-btn {
            background-color: #cc0000;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
        }
        .delete-btn:hover { background-color: #990000; }
        
        /* Update Price Form */
        .update-form { display: flex; gap: 10px; align-items: center; }
        .price-input { padding: 5px; width: 80px; border: 1px solid #ddd; border-radius: 4px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>

        <a href="admin_dashboard.jsp" class="<%= request.getRequestURI().contains("admin_dashboard.jsp") ? "active" : "" %>">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>

        <a href="manage_items.jsp" class="<%= request.getRequestURI().contains("manage_items.jsp") ? "active" : "" %>">
            <i class="fas fa-boxes"></i> Manage Items
        </a>

        <a href="manage_user.jsp" class="<%= request.getRequestURI().contains("manage_user.jsp") ? "active" : "" %>">
            <i class="fas fa-users"></i> Users
        </a>

        <a href="approvals.jsp" class="<%= request.getRequestURI().contains("approvals.jsp") ? "active" : "" %>">
            <i class="fas fa-check-circle"></i> Approvals
        </a>
        
        <a href="admin_report.jsp" class="<%= request.getRequestURI().contains("admin_report.jsp") ? "active" : "" %>">
            <i class="fas fa-chart-bar"></i> Reports
        </a>

        <a href="LogoutServlet" style="margin-top: auto;">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>

    <div class="main-content">
        <h2>Manage Items</h2>
        
        <div style="background:white; padding:20px; border-radius:10px; box-shadow:0 4px 10px rgba(0,0,0,0.05);">
            <table style="width:100%; border-collapse:collapse;">
                <thead>
                    <tr style="background:#800000; color:white; text-align:left;">
                        <th style="padding:15px;">Item</th>
                        <th style="padding:15px;">Price ($)</th>
                        <th style="padding:15px;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM ITEMS WHERE STATUS = 'APPROVED'");
                            
                            while(rs.next()) {
                                int id = rs.getInt("ITEM_ID");
                                String name = rs.getString("ITEM_NAME");
                                double price = rs.getDouble("PRICE");
                    %>
                    <tr style="border-bottom:1px solid #eee;">
                        <td style="padding:15px;"><%= name %></td>
                        <td style="padding:15px;">
                            <form action="AdminItemServlet" method="POST" class="update-form">
                                <input type="hidden" name="action" value="updatePrice">
                                <input type="hidden" name="itemId" value="<%= id %>">
                                <input type="number" step="0.01" name="newPrice" value="<%= price %>" class="price-input">
                                <button type="submit" style="background:none; border:none; color:green; cursor:pointer;"><i class="fas fa-save"></i></button>
                            </form>
                        </td>
                        <td style="padding:15px;">
                            <form action="AdminItemServlet" method="POST">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="itemId" value="<%= id %>">
                                <button type="submit" class="delete-btn" onclick="return confirm('Are you sure?')"><i class="fas fa-trash"></i> Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                            conn.close();
                        } catch(Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>