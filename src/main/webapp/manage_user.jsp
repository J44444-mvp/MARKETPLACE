<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Reuse your existing Maroon CSS here */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; }
        
        .sidebar { width: 260px; background-color: #800000; color: white; display: flex; flex-direction: column; padding: 20px; position: fixed; height: 100%; }
        .sidebar-header { font-size: 22px; font-weight: bold; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 20px; }
        .sidebar a { text-decoration: none; color: rgba(255,255,255,0.8); padding: 15px; display: flex; align-items: center; gap: 15px; border-radius: 8px; margin-bottom: 10px; transition: 0.3s; }
        .sidebar a:hover, .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }
        
        .main-content { margin-left: 260px; flex: 1; padding: 30px; }
        
        /* Table Styles */
        .table-container { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #800000; color: white; padding: 15px; text-align: left; }
        td { padding: 15px; border-bottom: 1px solid #eee; color: #555; }
        
        .btn-delete { background-color: #dc3545; color: white; border: none; padding: 8px 12px; border-radius: 5px; cursor: pointer; }
        .btn-delete:hover { background-color: #c82333; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manage_items.jsp"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_users.jsp" class="active"><i class="fas fa-users"></i> Users</a>
        <a href="LogoutServlet" style="margin-top: auto; background-color: #660000;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        <h2>Manage Users</h2>
        
        <% if(request.getParameter("msg") != null) { %>
            <div style="background: #d4edda; color: #155724; padding: 15px; margin: 20px 0; border-radius: 5px;">
                <%= request.getParameter("msg") %>
            </div>
        <% } %>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM USERS");

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("user_id") %></td>
                        <td><%= rs.getString("username") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("role") %></td>
                        <td>
                            <% if(!"ADMIN".equalsIgnoreCase(rs.getString("role"))) { %>
                            <form action="AdminUserServlet" method="POST" onsubmit="return confirm('Are you sure? This will delete the user AND all their items.');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="userId" value="<%= rs.getInt("user_id") %>">
                                <button type="submit" class="btn-delete"><i class="fas fa-trash"></i> Delete</button>
                            </form>
                            <% } else { %>
                                <span style="color: grey; font-size: 12px;">(Admin)</span>
                            <% } %>
                        </td>
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