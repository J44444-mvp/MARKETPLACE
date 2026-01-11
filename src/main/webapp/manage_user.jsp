<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; margin: 0; }

        /* Sidebar */
        .sidebar { width: 260px; background-color: #800000; color: white; display: flex; flex-direction: column; padding: 20px; position: fixed; height: 100%; }
        .sidebar-header { font-size: 22px; font-weight: bold; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 20px; }
        .sidebar a { text-decoration: none; color: rgba(255, 255, 255, 0.8); padding: 15px; margin-bottom: 10px; display: block; border-radius: 8px; transition: 0.3s; }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.1); color: white; transform: translateX(5px); }
        .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }

        /* Main Content */
        .main-content { margin-left: 260px; flex: 1; padding: 40px; }
        h2 { color: #800000; border-bottom: 2px solid #ddd; padding-bottom: 10px; margin-bottom: 20px; }

        /* Table */
        .table-container { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #800000; color: white; padding: 15px; text-align: left; }
        td { padding: 15px; border-bottom: 1px solid #eee; color: #333; }
        
        .btn-delete { background-color: #d32f2f; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; }
        .btn-delete:hover { background-color: #b71c1c; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manage_items.jsp"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp" class="active"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="admin_report.jsp"><i class="fas fa-chart-bar"></i> Reports</a>
        <a href="LogoutServlet" style="margin-top: auto;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        <h2>Manage Users</h2>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Phone</th> <th>Action</th>
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
                            
                            // Query to get user details including phone
                            String sql = "SELECT * FROM USERS";
                            rs = stmt.executeQuery(sql);
                            
                            while(rs.next()) {
                                int id = rs.getInt("USER_ID");
                                String username = rs.getString("USERNAME");
                                String email = rs.getString("EMAIL");
                                String phone = rs.getString("PHONE_NUMBER"); // <--- Get Phone
                    %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= username %></td>
                        <td><%= email %></td>
                        <td><%= (phone != null ? phone : "-") %></td> <td>
                            <form action="ManageUserServlet" method="POST" style="margin:0;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="userId" value="<%= id %>">
                                <button class="btn-delete" onclick="return confirm('Are you sure you want to delete this user?');">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } catch(Exception e) {
                            e.printStackTrace();
                        } finally {
                            if(conn != null) conn.close();
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>