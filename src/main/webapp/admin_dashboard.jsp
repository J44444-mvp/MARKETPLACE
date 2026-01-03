<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Campus Marketplace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* --- 1. GENERAL STYLES --- */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; }

        /* --- 2. SIDEBAR (MAROON THEME) --- */
        .sidebar {
            width: 260px;
            background-color: #800000; /* MAROON */
            color: white;
            display: flex;
            flex-direction: column;
            padding: 20px;
            position: fixed;
            height: 100%;
        }

        .sidebar-header {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 40px;
            display: flex;
            align-items: center;
            gap: 10px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }

        .sidebar a {
            text-decoration: none;
            color: rgba(255, 255, 255, 0.8);
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 15px;
            transition: 0.3s;
        }

        .sidebar a:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
            transform: translateX(5px);
        }

        .sidebar a.active {
            background-color: white;
            color: #800000;
            font-weight: bold;
        }

        .logout-btn {
            margin-top: auto;
            background-color: #660000;
            color: white !important;
        }
        .logout-btn:hover { background-color: #4d0000 !important; }

        /* --- 3. MAIN CONTENT --- */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 30px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h2 { color: #333; }

        /* --- 4. INTERESTING STAT CARDS --- */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: transform 0.2s;
        }

        .card:hover {
            transform: translateY(-5px); /* Slight lift effect */
        }

        .card-info h3 { font-size: 36px; margin-bottom: 5px; color: #2d3436; font-weight: 700; }
        .card-info p { color: #636e72; font-size: 15px; font-weight: 500; }

        /* --- NEW ICON STYLES --- */
        .icon-box {
            width: 60px;
            height: 60px;
            border-radius: 50%; /* Makes it a circle */
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
        }

        /* Blue Theme for Students */
        .icon-blue {
            background-color: #e3f2fd; /* Light Blue BG */
            color: #0984e3;           /* Dark Blue Icon */
        }

        /* Green Theme for Items */
        .icon-green {
            background-color: #e8f5e9; /* Light Green BG */
            color: #00b894;           /* Dark Green Icon */
        }

        /* Orange Theme for Pending */
        .icon-orange {
            background-color: #fff3e0; /* Light Orange BG */
            color: #e17055;           /* Dark Orange Icon */
        }

        /* --- 5. TABLE STYLES --- */
        .table-container {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            overflow: hidden; /* For rounded corners */
        }

        .table-header {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
            border-left: 5px solid #800000;
            padding-left: 10px;
        }

        table { width: 100%; border-collapse: collapse; }
        
        th {
            background-color: #800000;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            color: #555;
        }

        tr:hover { background-color: #fcfcfc; }

        .btn-approve {
            background-color: #00b894;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: 0.2s;
        }
        .btn-approve:hover { background-color: #01997a; }

        .status-badge {
            background-color: #ffeaa7;
            color: #d35400;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-user-shield"></i> Admin Panel
        </div>
        
        <a href="admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manage_items.jsp"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp"><i class="fas fa-users"></i> Users</a>
        
        <a href="LogoutServlet" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        
        <div class="header">
            <h2>Welcome, Admin!</h2>
            <div style="color: #666;">
                <i class="fas fa-calendar-alt"></i> Today's Overview
            </div>
        </div>

        <%
            int studentCount = 0;
            int pendingCount = 0;
            int totalItems = 0;

            try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

                PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM USERS WHERE ROLE = 'STUDENT'");
                ResultSet rs1 = ps1.executeQuery();
                if(rs1.next()) studentCount = rs1.getInt(1);

                PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM ITEMS WHERE STATUS = 'PENDING'");
                ResultSet rs2 = ps2.executeQuery();
                if(rs2.next()) pendingCount = rs2.getInt(1);

                PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) FROM ITEMS");
                ResultSet rs3 = ps3.executeQuery();
                if(rs3.next()) totalItems = rs3.getInt(1);
                
                conn.close();
            } catch(Exception e) { e.printStackTrace(); }
        %>

        <div class="stats-container">
            
            <div class="card">
                <div class="card-info">
                    <h3><%= studentCount %></h3>
                    <p>Students Registered</p>
                </div>
                <div class="icon-box icon-blue">
                    <i class="fas fa-user-graduate"></i>
                </div>
            </div>

            <div class="card">
                <div class="card-info">
                    <h3><%= totalItems %></h3>
                    <p>Total Items Listed</p>
                </div>
                <div class="icon-box icon-green">
                    <i class="fas fa-shopping-bag"></i>
                </div>
            </div>

            <div class="card">
                <div class="card-info">
                    <h3><%= pendingCount %></h3>
                    <p>Pending Approvals</p>
                </div>
                <div class="icon-box icon-orange">
                    <i class="fas fa-clock"></i>
                </div>
            </div>

        </div>

        <div class="table-container">
            <div class="table-header">Items Waiting for Approval</div>
            
            <table>
                <thead>
                    <tr>
                        <th>Item Name</th>
                        <th>Seller</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                            String sql = "SELECT i.item_id, i.item_name, i.price, i.status, u.full_name " +
                                         "FROM items i JOIN users u ON i.user_id = u.user_id " +
                                         "WHERE i.status = 'PENDING'";
                            
                            PreparedStatement stmt = conn.prepareStatement(sql);
                            ResultSet rs = stmt.executeQuery();

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><strong><%= rs.getString("item_name") %></strong></td>
                        <td><%= rs.getString("full_name") %></td>
                        <td>$<%= rs.getDouble("price") %></td>
                        <td><span class="status-badge">Pending</span></td>
                        <td>
                            <form action="ApproveServlet" method="POST">
                                <input type="hidden" name="itemId" value="<%= rs.getInt("item_id") %>">
                                <button type="submit" class="btn-approve">
                                    <i class="fas fa-check"></i> Approve
                                </button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                            conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>

    </div>

</body>
</html>