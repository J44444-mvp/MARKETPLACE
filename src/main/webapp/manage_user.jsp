<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users - Admin Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        /* --- GENERAL STYLES --- */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; }

        /* --- SIDEBAR --- */
        .sidebar { width: 260px; background-color: #800000; color: white; display: flex; flex-direction: column; padding: 20px; position: fixed; height: 100%; }
        .sidebar-header { font-size: 22px; font-weight: bold; margin-bottom: 40px; display: flex; align-items: center; gap: 10px; padding-bottom: 20px; border-bottom: 1px solid rgba(255,255,255,0.2); }
        .sidebar a { text-decoration: none; color: rgba(255, 255, 255, 0.8); padding: 15px; margin-bottom: 10px; border-radius: 8px; font-size: 16px; display: flex; align-items: center; gap: 15px; transition: 0.3s; }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.1); color: white; transform: translateX(5px); }
        .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }
        .logout-btn { margin-top: auto; background-color: #660000; color: white !important; }

        /* --- MAIN CONTENT --- */
        .main-content { margin-left: 260px; flex: 1; padding: 30px; }
        .page-title { font-size: 24px; font-weight: bold; margin-bottom: 20px; color: #333; }

        /* --- USER TABLE CARD --- */
        .card { background: white; padding: 0; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); overflow: hidden; }
        
        table { width: 100%; border-collapse: collapse; }
        
        /* Red Header */
        thead { background-color: #800000; color: white; }
        th { padding: 15px; text-align: left; font-weight: 600; font-size: 14px; letter-spacing: 0.5px; }
        
        /* Table Body */
        td { padding: 15px; border-bottom: 1px solid #eee; color: #555; vertical-align: middle; font-size: 14px; }
        tr:hover { background-color: #f9f9f9; }
        
        /* Delete Button */
        .btn-delete {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: 0.2s;
        }
        .btn-delete:hover { background-color: #c82333; }

        .admin-badge { color: #888; font-style: italic; font-size: 13px; }
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
        <div class="page-title">Manage Users</div>

        <div class="card">
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
                            // Fetch all users (Admins and Students)
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM USERS ORDER BY USER_ID ASC");

                            while (rs.next()) {
                                int uId = rs.getInt("user_id");
                                String uName = rs.getString("username");
                                String uEmail = rs.getString("email");
                                String uRole = rs.getString("role");
                    %>
                    <tr>
                        <td><%= uId %></td>
                        <td><%= uName %></td>
                        <td><%= uEmail %></td>
                        <td><%= uRole.toUpperCase() %></td>
                        <td>
                            <% if ("ADMIN".equalsIgnoreCase(uRole)) { %>
                                <span class="admin-badge">(Admin)</span>
                            <% } else { %>
                                <form action="DeleteUserServlet" method="POST" onsubmit="return confirmDelete(event, '<%= uName %>')">
                                    <input type="hidden" name="userId" value="<%= uId %>">
                                    <input type="hidden" name="username" value="<%= uName %>">
                                    
                                    <button type="submit" class="btn-delete">
                                        <i class="fas fa-trash-alt"></i> Delete
                                    </button>
                                </form>
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

    <script>
        // 1. Check if the URL has ?status=success (Triggered after Servlet Redirect)
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');
        const deletedName = urlParams.get('deletedName');

        if (status === 'success' && deletedName) {
            Swal.fire({
                title: 'Deleted!',
                text: 'Successfully deleted ' + deletedName + ' user.',
                icon: 'success',
                confirmButtonColor: '#800000'
            }).then(() => {
                // Optional: Clean the URL so the popup doesn't show again on refresh
                window.history.replaceState({}, document.title, window.location.pathname);
            });
        }

        // 2. (Optional) Small confirmation before submitting the form
        function confirmDelete(event, name) {
            // If you want a double check before sending to server:
            // remove "onsubmit" from form if you don't want this check.
            return confirm("Are you sure you want to delete user " + name + "?");
        }
    </script>

</body>
</html>