.<%@page import="java.sql.*"%>

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



        /* --- ITEM TABLE --- */

        .item-table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }

        .item-table th { background-color: #800000; color: white; padding: 15px; text-align: left; }

        .item-table td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; }



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

        

        /* Status Badges */

        .badge { padding: 5px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; }

        .badge-approved { background-color: #e6f9e6; color: green; }

        .badge-pending { background-color: #fff8e1; color: #f57c00; }

        .badge-rejected { background-color: #ffe6e6; color: red; }

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

        <h2>Manage All Items</h2>

        

        <table class="item-table">

            <thead>

                <tr>

                    <th>ID</th>

                    <th>Item Name</th>

                    <th>Price ($)</th>

                    <th>Status</th>

                    <th>Action</th>

                </tr>

            </thead>

            <tbody>

                <%

                    try {

                        Class.forName("org.apache.derby.jdbc.ClientDriver");

                        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

                        Statement stmt = conn.createStatement();

                        

                        // REMOVED 'WHERE' CLAUSE TO SHOW EVERYTHING

                        ResultSet rs = stmt.executeQuery("SELECT * FROM ITEMS ORDER BY ITEM_ID DESC");

                        

                        boolean hasData = false;

                        while(rs.next()) {

                            hasData = true;

                            int id = rs.getInt("ITEM_ID");

                            String name = rs.getString("ITEM_NAME");

                            double price = rs.getDouble("PRICE");

                            String status = rs.getString("STATUS");

                            

                            // Determine badge color

                            String badgeClass = "badge-pending";

                            if("APPROVED".equalsIgnoreCase(status)) badgeClass = "badge-approved";

                            if("REJECTED".equalsIgnoreCase(status)) badgeClass = "badge-rejected";

                %>

                <tr>

                    <td>#<%= id %></td>

                    <td><%= name %></td>

                    <td>

                        <form action="AdminItemServlet" method="POST" class="update-form">

                            <input type="hidden" name="action" value="updatePrice">

                            <input type="hidden" name="itemId" value="<%= id %>">

                            <input type="number" step="0.01" name="newPrice" value="<%= price %>" class="price-input">

                            <button type="submit" style="background:none; border:none; color:green; cursor:pointer;" title="Save Price"><i class="fas fa-save"></i></button>

                        </form>

                    </td>

                    <td>

                        <span class="badge <%= badgeClass %>"><%= status %></span>

                    </td>

                    <td>

                        <form action="AdminItemServlet" method="POST">

                            <input type="hidden" name="action" value="delete">

                            <input type="hidden" name="itemId" value="<%= id %>">

                            <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this item completely?')"><i class="fas fa-trash"></i> Delete</button>

                        </form>

                    </td>

                </tr>

                <%

                        }

                        if(!hasData) {

                %>

                    <tr><td colspan="5" style="text-align:center; padding:20px;">No items found in database.</td></tr>

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



</body>

</html>